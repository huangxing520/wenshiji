# 温时记 (wenshiji) 重构续作计划

> 本计划是上一份《wenshiji-code-review-and-refactor-plan.md》的**续作**。
> 上一份计划在执行到 B1（Drift 集成）中途上下文丢失，当前项目处于**不可编译状态**。
> 本计划聚焦：① 先恢复编译（完成 B1）；② 续完原计划剩余 9 项任务。

***

## 一、Summary 摘要

上一轮已完成 6 项（A1/A2/A3/A4/B4/B6）+ pubspec 依赖 + WebDAV 凭据迁移。但 B1（Drift）半途中断：`lib/database/wenshiji_database.dart` 已创建却引用了不存在的 `event_dao.dart`，且 `wenshiji_database.g.dart` 从未生成，导致**项目当前无法编译**。

本计划分两段：
- **第一段（紧急）**：完成 B1，恢复编译 — 新建 `event_dao.dart` / `migration.dart` / `event_repository.dart`，改造 `providers/event.dart` / `preferences.dart` / `main.dart`，运行 build_runner。
- **第二段（续作）**：按原计划顺序续完 B2 / B3 / B5 / C1 / C2 / C3 / D1-D8 / E1-E3。

执行后达成：结构化 SQLite 持久化、service 层抽离、路由独立、集中式主题、统一日志与错误处理、零死代码、`flutter analyze` 零警告。

***

## 二、Current State 当前状态（已 grep 验证）

### 2.1 已完成（6 项 + 基础设施）
| 任务 | 状态 | 产物 |
|---|---|---|
| A1 analysis_options | ✅ | `analysis_options.yaml`（include flutter_lints，strict-casts=false） |
| A2 secure storage | ✅ | `lib/common/secure_storage.dart`；`appconfig.dart`/`backup.dart` 移除凭据字段；`backup.dart` screen 改读 SecureStorage |
| A3 路由拼写 | ✅ | `main.dart` 已是 `/achievement` |
| A4 BackupNotifier | ✅ | `providers/backup.dart` 重写，`backup_service.dart` 已建 |
| B4 日志合并 | ✅ | `lib/common/app_logger.dart`（多 sink）；旧 logger.dart/log.dart 已删 |
| B6 http 日志安全 | ✅ | `http.dart` PrettyDioLogger 仅 kDebugMode |
| 依赖 | ✅ | pubspec 已加 drift/sqlite3_flutter_libs/drift_dev/flutter_secure_storage/collection |
| WebDAV 迁移 | ✅ | `main.dart` `_migrateWebdavCredentials()` 已调用 |

### 2.2 待完成（9 项）+ 阻塞点
| 任务 | 状态 | 说明 |
|---|---|---|
| **B1 Drift** | 🔴 **半途中断，项目不可编译** | `wenshiji_database.dart` 引用不存在的 `event_dao.dart`；`.g.dart` 未生成 |
| B2 service 层 | ⏳ | 仅 `backup_service.dart` 已建；webdav/weather/github/image service 待抽 |
| B3 路由独立 | ⏳ | 路由仍内联于 `main.dart` Application 构造函数 |
| B5 providers 拆分 | ⏳ | `event.dart` 含 9 个 provider；`app_config.dart` 已提取 `_update` |
| C1 主题系统 | ⏳ | 301 处硬编码 `Color(0x...)` |
| C2 api_constants | ⏳ | 仍是占位 `baseUrl='https://api.example.com'` |
| C3 stats 生日 | ⏳ | `AppConfig.birthday` 字段已加，UI 未读 |
| D1-D8 代码质量 | ⏳ | 49 print / 8 withOpacity / 60s setState / 死代码 / 重复实现 / 命名 / URL |
| E1-E3 异步错误 | ⏳ | mounted 检查 / Dio onError / Preferences nullable |

### 2.3 关键阻塞细节（必须处理）
1. **Drift 行类名冲突**：`class Events extends Table` 默认生成行类 `Event`，与 freezed 领域模型 `Event` **同名冲突**。必须给 `Events` 表加 `@DataClassName('EventRow')` 注解，使生成行类为 `EventRow`。
2. **import 路径已定**：`wenshiji_database.dart:11` 是 `import 'event_dao.dart';`（同目录相对路径），故 DAO 必须放在 `lib/database/event_dao.dart`（**不是**原计划说的 `lib/database/dao/`）。
3. **生成器顺序**：`event_dao.dart` 需 `part 'event_dao.g.dart'` + `@DriftAccessor`；`wenshiji_database.g.dart` 与 `event_dao.g.dart` 必须同时由 build_runner 生成。故 DAO 文件未创建前 build_runner 无法成功。

***

## 三、第一段：完成 B1 — 恢复编译（紧急）

### 3.1 修改 `lib/database/wenshiji_database.dart`
- 在 `class Events extends Table {` 上方加注解：
  ```dart
  @DataClassName('EventRow')
  class Events extends Table { ... }
  ```
- 其余保持不变（3 个类型转换器 + 表字段 + AppDatabase + _openConnection）。

### 3.2 新建 `lib/database/event_dao.dart`
`EventDao extends DatabaseAccessor<AppDatabase>`，用 `@DriftAccessor(tables: [Events])` + `part 'event_dao.g.dart'`。
- 复用 `wenshiji_database.dart` 已定义的转换器实例（`const`）。
- 方法：
  - `Future<List<Event>> getAllEvents()` — `select(events).get()` → `map(_toModel)`
  - `Stream<List<Event>> watchAllEvents()` — `select(events).watch().map(...)`
  - `Future<Event?> getEventById(String id)` — `(select(events)..where((t) => t.id.equals(id))).getSingleOrNull()`
  - `Future<void> upsertEvent(Event e)` — `into(events).insertOnConflictUpdate(_toCompanion(e))`
  - `Future<void> deleteEvent(String id)` — `(delete(events)..where((t) => t.id.equals(id))).go()`
- 私有映射：
  - `Event _toModel(EventRow r)` — 字段一一对应；`DateTime.fromMillisecondsSinceEpoch(r.date)`；枚举走 `EnumNameConverter.fromSql`；列表走 `DateTimeListConverter`/`StringListConverter.fromSql`。
  - `EventsCompanion _toCompanion(Event e)` — 反向映射；所有字段用 `Value(...)` 包裹。
- **import 别名**：`import '../models/event.dart' as model;`，方法签名返回 `model.Event`，避免与生成的 `EventRow`/未来 `Event` 混淆（加了 `@DataClassName` 后实际无冲突，但别名让意图清晰）。

### 3.3 新建 `lib/repositories/event_repository.dart`（新目录）
薄封装 `EventRepository`，持有 `EventDao`，转调：
```dart
class EventRepository {
  EventRepository(this._dao);
  final EventDao _dao;
  Future<List<Event>> getAllEvents() => _dao.getAllEvents();
  Future<Event?> getEventById(String id) => _dao.getEventById(id);
  Future<void> upsertEvent(Event e) => _dao.upsertEvent(e);
  Future<void> deleteEvent(String id) => _dao.deleteEvent(id);
}
```
**设计决策**：保留 freezed `Event` 作为领域模型，Drift `EventRow` 仅在 DAO 内部使用，不穿透到 UI。

### 3.4 新建 `lib/database/migration.dart`
一次性幂等迁移：
```dart
const _kMigrationDoneKey = 'drift_events_migration_done';

Future<void> migrateEventsFromPrefs(AppDatabase db) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_kMigrationDoneKey) == true) return;  // 幂等
  final raw = prefs.getString('events');
  if (raw != null && raw.isNotEmpty) {
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final events = list.map((j) => Event.fromJson(j as Map<String, dynamic>)).toList();
      for (final e in events) {
        await db.eventDao.upsertEvent(e);  // 批量 upsert
      }
    } catch (e, s) {
      AppLogger().error('Drift 迁移解析失败', error: e, stack: s);
      return;  // 不标记完成，下次重试
    }
  }
  await prefs.setBool(_kMigrationDoneKey, true);
  await prefs.remove('events');  // 清旧 key
}
```
**直接读 SharedPreferences**（不依赖 `Preferences.getEvents()`），这样可安全从 `preferences.dart` 移除 `getEvents/setEvents`。

### 3.5 修改 `lib/providers/event.dart`
- 顶部新增 import：`database/wenshiji_database.dart`、`repositories/event_repository.dart`。
- 新增两个 keepAlive provider（放在 EventNotifier 之前）：
  ```dart
  @Riverpod(keepAlive: true)
  AppDatabase appDatabase(Ref ref) {
    final db = AppDatabase();
    ref.onDispose(db.close);
    return db;
  }

  @Riverpod(keepAlive: true)
  EventRepository eventRepository(Ref ref) {
    final db = ref.watch(appDatabaseProvider);
    return EventRepository(db.eventDao);
  }
  ```
- `EventNotifier` 改造：
  - `build()` 中 `_repository = ref.watch(eventRepositoryProvider)`，然后 `_loadEvents()` 改为 `await _repository.getAllEvents()`（空则 fallback `Utils().getSampleEvents()`，**不持久化样本**）。
  - 删除 `_saveEvents(List<Event>)`（全量 JSON 写）。
  - `addEvent`：`state = AsyncData([...current, e])` 后 `await _repository.upsertEvent(e)`。
  - `updateEvent`：`state = AsyncData(mapped)` 后 `await _repository.upsertEvent(updated)`。
  - `deleteEvent`：`state = AsyncData(filtered)` 后 `await _repository.deleteEvent(id)`。
  - `setArchivedEvent`：copyWith 后 `await _repository.upsertEvent(updated)`。
  - `togglePin`/`toggleStar`/`quickCheckin`：同上，仅 upsert 被改的那条。
  - `deleteAllArchivedEvent`：计算保留列表 → `state = AsyncData(kept)` → 对被删除的每条 `await _repository.deleteEvent(id)`。
- 保留 `selectedCategory` / `filteredEvents` / `getEvent` / `stats` / `imageService` / `savedImagePathsForId` / `savedImageFilesForId` / `getCardItems` 9 个 provider 不动（B5 再拆）。

**行为变更说明（已批准的激进重构）**：原 `_saveEvents` 每次变更全量重写 SharedPreferences，副作用是把首次启动的样本事件也持久化。Drift 改为仅 upsert 变更的那条，**样本事件不再被持久化**（用户增删自己的事件后，下次启动只看到自己的事件）。这是更正确的行为。

### 3.6 修改 `lib/common/preferences.dart`
- 删除 `getEvents()`（85-99 行）与 `setEvents(String)`（101-104 行）。
- 保留 `getConfig`/`setConfig`/`getDeviceId`/`getInitState` 等（AppConfig 仍走 SharedPreferences）。
- 删除文件底部注释代码块（106-117 行）。

### 3.7 修改 `lib/main.dart`
- 新增 import：`database/wenshiji_database.dart`、`database/migration.dart`。
- `main()` 中在 `_migrateWebdavCredentials()` 之后、`runApp` 之前插入：
  ```dart
  final database = AppDatabase();
  await migrateEventsFromPrefs(database);
  ```
- `ProviderScope` 加 overrides：
  ```dart
  ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
    ],
    child: Application(...),
  )
  ```
- `callbackDispatcher` 内的 `print('执行后台任务: $task')` 等 print 暂保留（D1 统一替换）。

### 3.8 运行 build_runner
```bash
dart run build_runner clean
dart run build_runner build
```
预期生成：`lib/database/wenshiji_database.g.dart`、`lib/database/event_dao.g.dart`，并刷新 `lib/providers/generated/event.g.dart`（新增 `appDatabaseProvider`/`eventRepositoryProvider`）。

### 3.9 B1 验收
```bash
flutter analyze
```
应零 error（仍可能有 pre-existing lint warning，D 阶段清理）。手动验证：预置旧 `events` JSON → 启动 → 数据进 Drift → 旧 key 清除 → 二次启动幂等跳过。

***

## 四、第二段：续作任务（按原计划顺序）

### 4.1 B2 — service 层抽离
- 新建 `lib/services/webdav_service.dart`：封装 `webdav_client_plus`，`testConnection/listBackups/downloadBackup/uploadBackup`，凭据参数化（来自 SecureStorage）。
- 新建 `lib/services/weather_service.dart`：从 `http.dart` 抽 Open-Meteo 调用，返回 `WeatherResponse`。
- 新建 `lib/services/github_service.dart`：从 `http.dart` 抽 GitHub Releases 检查，返回 `GithubRelease`。
- 扩充 `lib/services/backup_service.dart`：编排备份/恢复流程（webdav + image + database）。
- 移动 `lib/common/picture_service.dart` → `lib/services/image_service.dart`（类名 `ImageService` 不变；注意 `ImageService` 内部仍用 SharedPreferences 存图片路径 — 图片元数据是否迁 Drift 留作后续，本次不动以控制范围）。
- 改 `lib/screens/backup.dart`：移除顶层 `getBackupRecords()` / `_showToast`（已是实例方法则确认无残留顶层函数）。
- 改 `lib/common/http.dart`：仅保留 Dio 单例 + 拦截器 + PrettyDioLogger；API 调用迁出。

### 4.2 B3 — 路由独立
- 新建 `lib/router/route_names.dart`：`kRouteSplash/kRouteHome/kRouteAchievement/kRouteArchive/kRouteEventDetail/kRouteAddEvent/kRouteAbout/kRouteNotificationSetting/kRouteBackup/kRouteProfile/kRouteStats`。
- 新建 `lib/router/app_router.dart`：`GoRouter createRouter({required bool isInit, required String version})`，全部路由用 `route_names` 常量。
- 改 `lib/main.dart`：`Application` 构造函数改为 `_router = createRouter(isInit: isInit, version: version)`，移除内联路由（201-284 行）。

### 4.3 B5 — providers 拆分
- `lib/providers/event.dart` 拆为：
  - `event.dart` — 仅 EventNotifier + eventRepository + appDatabase
  - `event_filter_providers.dart` — selectedCategory / filteredEvents / getEvent
  - `stats_provider.dart` — stats
  - `image_providers.dart` — imageService / savedImagePathsForId / savedImageFilesForId / getCardItems
- 各 `part 'generated/xxx.g.dart'` 路径同步调整，重跑 build_runner。
- `app_config.dart` 的 `_update` 提取已在上一轮完成（确认）。

### 4.4 C1 — 集中式主题系统
- 新建 `lib/theme/app_colors.dart`：`AppColors` 语义色常量（scaffoldBg/surface/primary/textPrimary/textSecondary/border/cardBg/shadow）+ 四季色（从 `config_constant.dart` 迁入）。
- 新建 `lib/theme/app_theme.dart`：`ThemeData appTheme` 基于 `ColorScheme.fromSeed(seedColor: AppColors.primary)`，封装 TextTheme/CardTheme/DividerTheme。
- 改 `lib/main.dart`：`MaterialApp.router` 的 `theme` 改 `appTheme`。
- 批量替换 301 处 `Color(0x...)` → `AppColors.xxx`，**按文件逐个替换，每文件后跑 analyze**（避免大爆炸 diff）。

### 4.5 C2 — api_constants 集中化
- 改 `lib/constants/api_constants.dart`：删 `baseUrl='https://api.example.com'`；新增 `openMeteoBaseUrl`/`githubReleasesUrl(owner,repo)`/`dicebearBaseUrl`/`dicebearApiUrl`。
- 改 `lib/constants/config_constant.dart`：四季色迁出到 AppColors（C1）。
- 改 `lib/common/http.dart`（或 weather_service/github_service）：URL 引用 ApiConstants。

### 4.6 C3 — stats 生日可配置
- 改 `lib/screens/stats.dart`：移除硬编码 `1990-03-15`；从 `AppConfig.birthday`（字段已加）读取。
- 若缺设置入口：在 profile 或 stats 页加生日选择器（`flutter_datetime_picker_plus`）写回 AppConfigNotifier。

### 4.7 D1-D8 — 代码质量清理
- **D1**：49 处 `print(` → `AppLogger().debug/error`，逐文件替换。
- **D2**：8 处 `withOpacity` → `withValues(alpha:)`（event_detail.dart 7 处 + home_screen.dart 2 处）。
- **D3**：`home_screen.dart:39-43` 移除 60s `setState((){})`，倒计时抽独立 widget 用 `Stream.periodic` 局部刷新。
- **D4**：`archive.dart:80,82` 移除 build 体内日志。
- **D5**：删 `event.dart` 的 `TaskType` 枚举 + 注释 `EventReminder`；`event_detail.dart` 死字段；`permission.dart`/`add_event.dart` 注释代码；`api_constants.dart` 占位 baseUrl（C2 已处理）。
- **D6**：`notification_setting.dart` 删重复 `registerPeriodicTask`；`achievement.dart` 用 `package:collection` 的 `firstWhereOrNull`。
- **D7**：`widget/navigationBar.dart` 类名 `commonNavigationBar` → `CommonNavigationBar`，全项目引用同步。
- **D8**：`profile.dart` DiceBear URL 迁入 `api_constants.dart`。

### 4.8 E1-E3 — 异步与错误处理
- **E1**：grep `await` 后用 BuildContext 处补 `if (!mounted) return;`，借 `use_build_context_synchronously: warning` 暴露遗漏点。重点：add_event/event_detail/backup/stats/home_screen。
- **E2**：`http.dart` 加 `InterceptorsWrapper.onError`，统一 DioException → HyperSnackbar 友好提示。
- **E3**：`providers/app_config.dart` 避免 `state.requireValue`，用 `state.maybeWhen(data: ..., orElse: () => AppConfig())` 兜底。

***

## 五、Verification 最终验证

1. `dart run build_runner clean && dart run build_runner build` — 成功无冲突。
2. `flutter analyze` — 零 error、零 warning（除第三方包）。
3. 迁移幂等性：预置旧 events JSON → 启动 → 数据进 Drift → 旧 key 清除 → 二次启动跳过。
4. 手动回归：
   - 新增/编辑/删除事件（含图片、重复规则）
   - 归档/取消归档/批量删除归档
   - 置顶/收藏/快速打卡
   - 后台每日聚合通知
   - WebDAV 备份/恢复（凭据走 SecureStorage）
   - 天气 / GitHub 版本检查
   - 底部三 tab 切换保活
   - stats 生日配置后正确计算
5. Release 构建验证 `flutter build apk --release`：pretty_dio_logger 不泄露、Crashlytics 上报正常。

***

## 六、Assumptions & Decisions 假设与决策

1. **行类名冲突**：`Events` 表加 `@DataClassName('EventRow')`，避免与 freezed `Event` 同名。
2. **DAO 路径**：放 `lib/database/event_dao.dart`（同目录），匹配 `wenshiji_database.dart` 已有的 `import 'event_dao.dart'`。
3. **EventNotifier 保留内存 state**：仍 `state = AsyncData(List<Event>)`，仅持久化后端换 Drift。降低对 `filteredEvents/stats/getEvent` 等 consumer 的冲击（B5 拆分时再评估是否切 Stream）。
4. **样本事件不再持久化**：Drift 仅 upsert 变更的那条，首次启动样本事件在用户首次增删后不再保留。已批准的激进重构范围内可接受。
5. **迁移直接读 SharedPreferences**：不依赖 `Preferences.getEvents()`，故可安全从 `preferences.dart` 移除该方法。
6. **图片元数据不迁 Drift**：`ImageService` 仍用 SharedPreferences 存路径列表（控制本次范围；图片路径与事件耦合度低，后续可单独评估）。
7. **AppConfig 仍用 SharedPreferences**：配置小且扁平，无需 DB。
8. **不引入 i18n / 不新增单测**：以 analyze 零警告 + 手动回归为验收（沿用原计划决策）。
9. **执行顺序**：B1 必须最先（恢复编译）；B1 完成后跑一次 analyze 作为 checkpoint；其余按 B2→B3→B5→C1→C2→C3→D→E 顺序，每阶段结束跑 analyze 拦回归。

***

## 七、执行顺序 Todo

1. 🔴 **B1 完成**（恢复编译）— 3.1~3.8，含 build_runner
2. ✅ checkpoint：`flutter analyze` 零 error
3. B2 service 层
4. B3 路由独立
5. B5 providers 拆分 + 重跑 build_runner
6. C1 主题系统（最大工作量，分文件）
7. C2 api_constants
8. C3 stats 生日
9. D1-D8 代码质量（可并行分批）
10. E1-E3 异步错误处理
11. 最终：重跑 build_runner + flutter analyze + 手动回归
