# 温时记 (wenshiji) 项目审查与重构实施计划

> 审查范围：全项目（lib/ + pubspec + 项目根配置）
> 重构程度：激进（含架构改造 — Drift 数据库、secure storage、service 层抽离、主题系统）
> 数据持久化方案：**Drift (SQLite)** 替换 SharedPreferences 全量 JSON 存储

***

## 一、Summary 摘要

对温时记 Flutter 项目进行全量代码审查后，发现 3 个 P0 级问题（WebDAV 凭据明文、路由拼写错误 `/archivement`、BackupNotifier 持久化读写断裂）、多个 P1 性能/安全/工程化问题，以及大量 P2/P3 代码质量问题。

本计划按 5 个阶段执行修复：A) 基础设施与安全 P0；B) 架构改造（Drift + service 层 + router 独立 + 日志合并）；C) 主题与常量系统；D) 代码质量清理（print/withOpacity/死代码/重复实现）；E) 异步与错误处理统一。

执行后将达成：凭据加密存储、结构化数据库、集中式主题、统一日志与错误处理、严格 lint 规则、零死代码。

***

## 二、Current State Analysis 当前状态分析

### 2.1 技术栈

* Flutter SDK `>=3.8.0 <4.0.0`

* 状态管理：Riverpod 3.x（代码生成 + AsyncNotifier）

* 路由：GoRouter 17.x（StatefulShellRoute.indexedStack）

* 持久化：SharedPreferences（事件以全量 JSON 字符串存储）

* 模型：freezed 3.x + json\_serializable

* 网络：dio + pretty\_dio\_logger

* 后台：workmanager + flutter\_local\_notifications

* 远程：Firebase（core/crashlytics/analytics）+ webdav\_client\_plus

* UI：google\_fonts、contribution\_heatmap、hyper\_snackbar

### 2.2 核心问题清单（已 grep 验证，含行号）

| 级别 | 问题                                                                                                                                                      | 位置                                                                                                                                  |
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| P0 | WebDAV 凭据明文存储并序列化到 SharedPreferences                                                                                                                    | `lib/models/appconfig.dart`（backupUsername/backupPassword/backupServerUrl）、`lib/models/backup.dart`（BackupRecord.username/password） |
| P0 | 路由 path 拼写错误 `/archivement`（应为 `/achievement`）                                                                                                          | `lib/main.dart:198`                                                                                                                 |
| P0 | BackupNotifier 读写不一致：`build()` 调用 `screens/backup.dart` 顶层 `getBackupRecords()` 而非本地；`_loadFromLocal()` 死代码（含 3 条硬编码假凭据）                                | `lib/providers/backup.dart:16-67`                                                                                                   |
| P1 | home\_screen 每 60s 空 `setState(() {})` 全量重建                                                                                                             | `lib/screens/home_screen.dart:39-43`                                                                                                |
| P1 | archive `build()` 方法体内写日志，每次重建刷日志                                                                                                                       | `lib/screens/archive.dart:80,82`                                                                                                    |
| P1 | 生产环境 pretty\_dio\_logger 可能记录敏感请求体                                                                                                                      | `lib/common/http.dart`                                                                                                              |
| P1 | 缺少 `analysis_options.yaml`，未启用 flutter\_lints 严格规则                                                                                                      | 项目根                                                                                                                                 |
| P2 | 49 处 `print()` 散落 12 个文件                                                                                                                                | 全局                                                                                                                                  |
| P2 | 301 处硬编码 `Color(0x...)`，无集中式主题系统                                                                                                                        | 16 个文件                                                                                                                              |
| P2 | 8 处弃用 `withOpacity`（应迁 `withValues(alpha:)`）                                                                                                            | `lib/screens/event_detail.dart:317,323,473,516,518,861,915`、`home_screen.dart:1316,1321`                                            |
| P2 | stats.dart 硬编码生日 `1990-03-15`                                                                                                                           | `lib/screens/stats.dart`                                                                                                            |
| P3 | `logger.dart`（AppLogger 控制台）与 `log.dart`（LogWriter 文件）职责重叠命名混淆                                                                                          | `lib/common/`                                                                                                                       |
| P3 | 死代码：`TaskType` 枚举、`EventReminder` 注释枚举、`_hoursRemaining/_minutesRemaining/_secondsRemaining` 字段、`_loadFromLocal()`、`api_constants.dart` 的 `baseUrl` 占位符 | 多处                                                                                                                                  |
| P3 | http.dart 硬编码 Open-Meteo / GitHub API URL（api\_constants 形同虚设）                                                                                          | `lib/common/http.dart:211,219`                                                                                                      |
| P3 | 重复实现：`registerPeriodicTask`（utils + notification\_setting）、`firstWhereOrNull`（本地扩展 vs collection 包）                                                     | 多处                                                                                                                                  |
| P3 | `widget/navigationBar.dart` 类名 `commonNavigationBar` 违反 PascalCase                                                                                      | `lib/widget/navigationBar.dart`                                                                                                     |
| P3 | AppConfigNotifier 12+ setter 重复样板                                                                                                                       | `lib/providers/app_config.dart`                                                                                                     |
| P3 | `Utils` 上帝类（含 showToast/getSampleEvents 等不该在此的逻辑）                                                                                                       | `lib/common/utils.dart`                                                                                                             |
| P3 | `screens/backup.dart` 顶层函数 `_showToast`、`getBackupRecords()` 破坏封装，且 provider 依赖 UI 层（层级倒置）                                                              | `lib/screens/backup.dart:1214`                                                                                                      |
| P3 | 路由配置耦合在 Application 构造函数内                                                                                                                               | `lib/main.dart:154-265`                                                                                                             |
| P3 | 缺少 `mounted` 检查（21 处仅部分覆盖），async gap 后用 BuildContext                                                                                                    | 多处                                                                                                                                  |

### 2.3 生成代码一致性

* `lib/providers/generated/*.g.dart` 与 `lib/models/generated/*.{freezed,g}.dart` 均与源声明一致，无手工修改痕迹。

* 唯一瑕疵：`event.g.dart` 顶部中文注释提到 "eventNotifierProvider" 但实际生成 `eventProvider`（生成器模板陈旧注释，非功能 bug，重跑 build\_runner 可刷新）。

***

## 三、Proposed Changes 提议变更

按阶段组织。每阶段含「新建文件 / 修改文件 / 删除文件 / 具体做法」。

### 阶段 A：基础设施与安全（P0）— 4 项

#### A1. 添加 `analysis_options.yaml`（项目根，新建）

* 启用 `flutter_lints`（已在 dev\_dependencies）+ 严格规则：

  * `avoid_print: true`（强制走 AppLogger）

  * `prefer_const_constructors: true`

  * `prefer_const_literals_to_create_immutables: true`

  * `use_build_context_synchronously: warning`

  * `deprecated_member_use: warning`（暴露 withOpacity）

  * `avoid_unused_constructor_parameters`

  * `require_trailing_commas`

  * `unawaited_futures`

  * `cancel_subscriptions`

  * `close_sinks`

* include: `package:flutter_lints/flutter.yaml`

#### A2. WebDAV 凭据迁移到 flutter\_secure\_storage（P0 安全）

* **pubspec.yaml**：添加 `flutter_secure_storage: ^9.2.2`（与 `shared_preferences` 并存）。

* **新建** **`lib/common/secure_storage.dart`**：封装 `SecureStorage` 单例，方法：

  * `Future<void> saveWebdavCredentials({username, password, serverUrl})`

  * `Future<({String username, String password, String serverUrl})?> getWebdavCredentials()`

  * `Future<void> clearWebdavCredentials()`

  * Android 配置（自动）+ iOS keychain（自动）。

* **修改** **`lib/models/appconfig.dart`**：移除 `backupUsername`、`backupPassword`、`backupServerUrl` 三个字段（破坏 schema 变更，需重跑 build\_runner）。

* **修改** **`lib/models/backup.dart`**：从 `BackupRecord` 移除 `username`/`password` 字段（仅保留 recordId、name、serverUrl、timestamp、size、status；凭据不入记录）。

* **修改** **`lib/providers/app_config.dart`**：所有 backup 凭据相关 setter 改为调用 `SecureStorage`。

* **修改** **`lib/screens/backup.dart`**：备份/恢复时通过 `SecureStorage` 读取凭据，不再从 AppConfig。

* **迁移逻辑**：在 `main()` 启动时检测旧 SharedPreferences 中是否存有明文凭据，若有则一次性迁移到 secure storage 后清除明文。

#### A3. 修复路由拼写错误（P0）

* **修改** **`lib/main.dart:198`**：`path: '/archivement'` → `path: '/achievement'`。

* 全项目 grep `/archivement` 引用并同步修正（context.go / GoRoute 调用点）。

#### A4. 修复 BackupNotifier 持久化读写断裂（P0）

* **修改** **`lib/providers/backup.dart`**：

  * 删除死代码 `_loadFromLocal()`（含 3 条硬编码假凭据）。

  * `build()` 改为从本地持久化（SharedPreferences，凭据部分走 secure storage）读取，而非调用 UI 层 `getBackupRecords()`。

  * 确保读写一致：`setBackupRecords`/`deleteBackupRecord` 写入后状态正确刷新。

***

### 阶段 B：架构改造 — 6 项

#### B1. 引入 Drift (SQLite) 替换全量 JSON 存储（核心）

* **pubspec.yaml**：添加

  * `drift: ^2.16.0`

  * `dev_dependencies`: `drift_dev: ^2.16.0`、`sqlite3_flutter_libs: ^0.5.24`

* **新建** **`lib/database/wenshiji_database.dart`**：定义 Drift `AppDatabase extends GeneratedDatabase`，包含 `Events` 表（字段映射 Event 模型：id TEXT PRIMARY KEY, name TEXT, date INTEGER(epoch), nextEffectiveTime INTEGER, type TEXT, priority TEXT, isPinned INTEGER, isStarred INTEGER, checkinTimes TEXT(json), checkinStreakCount INTEGER, isArchived INTEGER, repeatRule TEXT, description TEXT, picturePaths TEXT(json), tags TEXT(json)）。

* **新建** **`lib/database/dao/event_dao.dart`**：`EventDao extends DatabaseAccessor`，方法：

  * `Future<List<Event>> getAllEvents()` / `watchAllEvents()` (Stream)

  * `Future<Event?> getEventById(String id)`

  * `Future<void> upsertEvent(Event e)`

  * `Future<void> deleteEvent(String id)`

  * 过滤查询：`watchFiltered({FilterType, category, includeArchived})`、`watchArchived()`、`watchPinned()`

  * 统计查询：`getStats()` → `Map<String,int>`（count、archivedCount、pinnedCount、streakMax）

* **新建** **`lib/repositories/event_repository.dart`**：`EventRepository` 负责领域模型 ↔ Drift row 映射（保留 freezed `Event` 作为领域模型，Drift table 为持久化层），暴露给 Provider。

* **修改** **`lib/providers/event.dart`**：`EventNotifier` 改为依赖 `EventRepository`（注入），CRUD 走 DB；保留 `keepAlive`。

* **修改** **`lib/common/preferences.dart`**：移除 `getEvents`/`saveEvents`（全量 JSON）方法；保留 AppConfig 序列化（小型配置仍可用 SharedPreferences）。

* **新建** **`lib/database/migration.dart`**：一次性迁移逻辑

  * 首次启动检测 SharedPreferences 中旧 events JSON。

  * 解析 → 批量 insert 到 Drift → 标记 `migration_done=true` → 清除旧 events key。

  * 幂等：已迁移则跳过。

* **修改** **`lib/main.dart`**：初始化 `AppDatabase`（`AppDatabase()` 即惰性连接），运行迁移，通过 ProviderScope overrides 注入 repository。

* **重跑 build\_runner**：`dart run build_runner build --delete-conflicting-outputs` 生成 drift 代码。

#### B2. 抽离 service 层（解决层级倒置）

* **新建** **`lib/services/webdav_service.dart`**：封装 `webdav_client_plus`，方法 `testConnection()`、`listBackups()`、`downloadBackup()`、`uploadBackup()`。凭据通过参数传入（来源 secure storage）。

* **新建** **`lib/services/weather_service.dart`**：从 `http.dart` 抽出 Open-Meteo 调用，返回 `WeatherResponse`。

* **新建** **`lib/services/github_service.dart`**：从 `http.dart` 抽出 GitHub Releases 检查，返回 `GithubRelease`。

* **新建** **`lib/services/backup_service.dart`**：编排备份/恢复流程（调用 webdav\_service + image\_service + database）。

* **移动** **`lib/common/picture_service.dart`** **→** **`lib/services/image_service.dart`**：类名 `ImageService` 不变。

* **修改** **`lib/screens/backup.dart`**：移除顶层函数 `getBackupRecords()`、`_showToast()`；UI 仅调用 service + provider。

* **修改** **`lib/common/http.dart`**：仅保留 Dio 单例 + 拦截器配置 + PrettyDioLogger（见 B6），具体 API 调用迁出。

#### B3. 路由独立成文件

* **新建** **`lib/router/app_router.dart`**：导出 `GoRouter createRouter({required bool isInit, required String version})`，包含全部路由定义。

* **新建** **`lib/router/route_names.dart`**：定义路由 path 常量（`kRouteSplash`、`kRouteHome`、`kRouteAchievement`、`kRouteArchive`、`kRouteEventDetail`、`kRouteAddEvent`、`kRouteAbout`、`kRouteNotificationSetting`、`kRouteBackup`、`kRouteProfile`、`kRouteStats`），消除拼写错误风险。

* **修改** **`lib/main.dart`**：`Application` 构造函数改为 `createRouter(isInit: isInit, version: version)`，移除内联路由。

#### B4. 合并日志系统（消除 logger.dart / log.dart 混淆）

* **新建** **`lib/common/app_logger.dart`**：统一 `AppLogger` 单例，多 sink：

  * 控制台 sink（logger 包 PrettyPrinter，debug only）

  * 文件 sink（写 `network_logs.txt`，原 log.dart 职责）

  * Crashlytics sink（`FirebaseCrashlytics.instance.log()`，error/fatal 级别）

  * 方法：`debug/info/warning/error/fatal(String msg, {Object? error, StackTrace? stack})`

  * release 模式：控制台 sink 关闭，仅文件 + Crashlytics。

* **删除** **`lib/common/logger.dart`**、**删除** **`lib/common/log.dart`**。

* **修改** **`lib/common/http.dart`**：PrettyDioLogger 的 logOutput 重定向到 `AppLogger` 文件 sink。

* 全项目替换 `AppLogger()`/`LogWriter()` 旧引用为统一 `AppLogger`。

#### B5. 拆分超大文件与重复样板

* **拆分** **`lib/providers/event.dart`**（当前包含 9 个 provider）为：

  * `lib/providers/event.dart` — 仅 EventNotifier + eventProvider

  * `lib/providers/event_filter_providers.dart` — selectedCategory、filteredEvents、getEvent

  * `lib/providers/stats_provider.dart` — stats

  * `lib/providers/image_providers.dart` — imageService、savedImagePathsForId、savedImageFilesForId、getCardItems

* **修改** **`lib/providers/app_config.dart`**：提取私有 `Future<void> _update(AppConfig Function(AppConfig) updater)`，12+ setter 复用之消除样板。

#### B6. 生产环境日志安全

* **修改** **`lib/common/http.dart`**：`PrettyDioLogger` 仅在 `kDebugMode` 下启用；release 构建中拦截器不记录请求/响应体（或仅记录 method+url）。

***

### 阶段 C：主题与常量系统 — 3 项

#### C1. 集中式主题系统（消除 301 处硬编码 Color）

* **新建** **`lib/theme/app_colors.dart`**：定义语义色常量类 `AppColors`：

  * `static const Color scaffoldBg = Color(0xFFF7F3ED);`

  * `static const Color surface = Color(0xFFFAF7F0);`

  * `static const Color primary = Color(0xFFD4A853);`

  * `static const Color textPrimary`、`textSecondary`、`border`、`cardBg`、`shadow`…

  * 四季配色：`springColor`/`summerColor`/`autumnColor`/`winterColor`（从 config\_constant.dart 迁入）

* **新建** **`lib/theme/app_theme.dart`**：`ThemeData appTheme` 基于 `ColorScheme.fromSeed(seedColor: AppColors.primary)`，封装常用 `TextTheme`、`CardTheme`、`DividerTheme`。

* **修改** **`lib/main.dart`**：`MaterialApp.router` 的 `theme` 改为 `appTheme`。

* **批量替换**：全项目 `Color(0x...)` 替换为 `AppColors.xxx`。此阶段工作量最大，按文件逐步进行（每文件替换后跑 `flutter analyze`）。

#### C2. 常量集中化

* **修改** **`lib/constants/api_constants.dart`**：

  * 删除占位 `baseUrl = 'https://api.example.com'`。

  * 新增 `openMeteoBaseUrl`、`githubReleasesUrl(owner, repo)`、`dicebearBaseUrl`、`dicebearApiUrl`。

* **修改** **`lib/constants/config_constant.dart`**：保留 owner/repo/githubUrl/feedbackUrl；四季色迁出到 AppColors。

#### C3. stats 生日可配置

* **修改** **`lib/screens/stats.dart`**：移除硬编码 `birthDate='1990-03-15'`；改为从 AppConfig 读取用户设置的生日（若 AppConfig 无该字段，则新增 `birthday` 字段并提供设置入口）。

***

### 阶段 D：代码质量清理（P2-P3）— 8 项

#### D1. 替换 49 处 print() 为 AppLogger

* 全项目 grep `print(`，逐处替换：调试用 → `AppLogger().debug()`；错误用 → `AppLogger().error()`。

* `main.dart` 的 `callbackDispatcher` 内 print 同步替换。

* lint `avoid_print` 启用后作为防回归护栏。

#### D2. 迁移弃用 withOpacity → withValues

* `lib/screens/event_detail.dart`：317、323、473、516、518、861、915（8 处）。

* `lib/screens/home_screen.dart`：1316、1321。

* 替换模板：`color.withOpacity(0.5)` → `color.withValues(alpha: 0.5)`。

#### D3. 修复 home\_screen 60s 全量重建

* **修改** **`lib/screens/home_screen.dart:39-43`**：移除 `Timer.periodic(60s, () => setState((){}))`。

* 将倒计时显示抽到独立 `ConsumerWidget`/`StatelessWidget`，内部用 `StreamBuilder + Stream.periodic(60s)` 或 `ValueListenableBuilder` 局部刷新。

* 确保 `_timer` 在 dispose 中 cancel（保留）。

#### D4. 移除 archive build 中日志

* **修改** **`lib/screens/archive.dart:80,82`**：移除 `AppLogger().info('archivedEvents:...')` 等 build 体内日志；如需调试，改为仅在数据源变化时记录（在 provider 内 `ref.listen`）。

#### D5. 删除死代码

* `lib/models/event.dart`：删除 `TaskType` 枚举（未使用）、`EventReminder` 注释块。

* `lib/screens/event_detail.dart`：删除 `_hoursRemaining`/`_minutesRemaining`/`_secondsRemaining` 字段及关联注释。

* `lib/common/permission.dart`：清理大段注释代码。

* `lib/screens/add_event.dart`：清理注释代码块 + 空 `setState((){})`（81 行）。

* `lib/screens/archive.dart`、`event_detail.dart`：清理注释代码块。

* `lib/constants/api_constants.dart`：删除 `baseUrl` 占位符（C2 已处理）。

#### D6. 消除重复实现

* **修改** **`lib/screens/notification_setting.dart`**：删除 `registerPeriodicTask` 重复实现，统一调用 `Utils.registerPeriodicTask`（或迁到 service）。

* **修改** **`lib/screens/achievement.dart`**：删除本地 `firstWhereOrNull` 扩展，改用 `package:collection`（pubspec 添加 `collection: ^1.18.0`）。

#### D7. 命名规范

* **修改** **`lib/widget/navigationBar.dart`**：类名 `commonNavigationBar` → `CommonNavigationBar`（PascalCase）。全项目引用同步更新。

* **修改** **`lib/screens/backup.dart`**：将顶层函数 `_showToast`、`getBackupRecords` 移入 class 或 service（B2 已部分处理）。

#### D8. profile 硬编码 URL

* **修改** **`lib/screens/profile.dart`**：DiceBear 头像 API URL 迁入 `api_constants.dart`（C2）。

***

### 阶段 E：异步与错误处理统一 — 3 项

#### E1. 审计 mounted 检查

* 全项目 grep `await` 后接 BuildContext 使用的位置，补齐 `if (!mounted) return;`。

* 借助 lint `use_build_context_synchronously: warning` 暴露全部遗漏点，逐处修复。

* 重点文件：`add_event.dart`、`event_detail.dart`、`backup.dart`、`stats.dart`、`home_screen.dart`。

#### E2. Dio 统一错误拦截

* **修改** **`lib/common/http.dart`**：添加 `InterceptorsWrapper` 的 `onError`，统一将 DioException 转为用户友好提示（通过 `HyperSnackbar`），避免各处直接 `throw` 或裸 catch。

* 业务层捕获特定错误码做差异化处理，通用错误由拦截器兜底。

#### E3. 修复 Preferences nullable 与 requireValue 不匹配

* **修改** **`lib/common/preferences.dart`**：明确返回类型契约；`getEvents` 在 Drift 迁移后废弃（B1）。

* **修改** **`lib/providers/app_config.dart`**：避免 `state.requireValue` 直接假定非空；提供 `state.maybeWhen(data: ..., orElse: () => AppConfig())` 兜底默认值，降低崩溃风险。

***

## 四、新建/修改/删除文件汇总

### 新建文件（22 个）

```
analysis_options.yaml
lib/common/secure_storage.dart
lib/common/app_logger.dart
lib/database/wenshiji_database.dart
lib/database/dao/event_dao.dart
lib/database/migration.dart
lib/repositories/event_repository.dart
lib/services/webdav_service.dart
lib/services/weather_service.dart
lib/services/github_service.dart
lib/services/backup_service.dart
lib/services/image_service.dart
lib/router/app_router.dart
lib/router/route_names.dart
lib/theme/app_colors.dart
lib/theme/app_theme.dart
lib/providers/event_filter_providers.dart
lib/providers/stats_provider.dart
lib/providers/image_providers.dart
（生成代码）lib/database/wenshiji_database.g.dart（build_runner 产出）
```

### 修改文件（\~25 个）

```
pubspec.yaml
lib/main.dart
lib/models/appconfig.dart          （移除凭据字段）
lib/models/backup.dart             （移除凭据字段）
lib/models/event.dart              （删死枚举）
lib/providers/event.dart           （改用 repository + 拆分）
lib/providers/app_config.dart      （_update 提取 + secure storage）
lib/providers/backup.dart          （读写一致）
lib/common/preferences.dart        （移除 events 全量 JSON）
lib/common/http.dart               （URL 迁出 + 日志安全）
lib/common/utils.dart              （瘦身）
lib/common/permission.dart         （清注释）
lib/constants/api_constants.dart   （真实 URL）
lib/constants/config_constant.dart （四季色迁出）
lib/screens/home_screen.dart       （60s setState + withOpacity）
lib/screens/archive.dart           （build 日志 + 注释）
lib/screens/event_detail.dart      （withOpacity ×8 + 死字段）
lib/screens/add_event.dart         （空 setState + 注释）
lib/screens/stats.dart             （生日可配置）
lib/screens/backup.dart            （顶层函数移除）
lib/screens/notification_setting.dart （删重复方法）
lib/screens/achievement.dart       （用 collection）
lib/screens/profile.dart           （URL 迁出）
lib/widget/navigationBar.dart      （类名 PascalCase）
lib/firebase_options.dart          （评估 measurementId 不一致）
```

### 删除文件（2 个）

```
lib/common/logger.dart    （合并入 app_logger.dart）
lib/common/log.dart       （合并入 app_logger.dart）
```

### 重跑生成

```
dart run build_runner build --delete-conflicting-outputs
（刷新 *.g.dart、*.freezed.dart、wenshiji_database.g.dart）
```

***

## 五、Assumptions & Decisions 假设与决策

1. **数据库选 Drift**：用户确认。理由：事件需按分类/归档/日期范围过滤、统计聚合、streak 计算，SQL 天然适合；成熟稳定。
2. **freezed 领域模型保留**：Drift 作为持久化层，freezed Event 作为领域模型，repository 负责映射。不直接用 Drift 生成类穿透到 UI（保持类型清晰）。
3. **AppConfig 仍用 SharedPreferences**：配置数据小且扁平，无需 DB；仅凭据迁 secure storage。
4. **凭据字段从 AppConfig/BackupRecord 移除**：破坏 schema 变更，需重跑 build\_runner；提供一次性迁移逻辑读取旧明文凭据。
5. **路由 path 常量化**：通过 `route_names.dart` 防止再次拼写错误。
6. **主题替换分文件进行**：301 处 Color 替换工作量大，按文件逐个替换并跑 analyze，避免一次性大爆炸 diff。
7. **Firebase 配置不动**：firebase\_options.dart 由 FlutterFire CLI 生成，是 Firebase 常规模式；仅记录 web/windows measurementId 不一致需用户确认。
8. **不引入 i18n**：当前仅中文，i18n 不在本次范围（用户未要求）；硬编码中文字符串暂保留。
9. **build\_runner 必须重跑**：模型 schema 变更后生成代码需刷新。
10. **测试策略**：项目当前无测试；本次重构以 `flutter analyze` 零警告 + 手动回归测试为验收，不新增单测（除非用户后续要求）。

***

## 六、Verification 验证步骤

### 阶段性验证

* **A 完成后**：`flutter analyze` 通过；手动验证 WebDAV 备份流程凭据不再出现在 SharedPreferences；`/achievement` 路由可正常跳转；BackupNotifier 重启后状态保留。

* **B 完成后**：迁移测试 — 预置旧 SharedPreferences events JSON，启动 app 后数据出现在 Drift 且旧 key 被清除；service 层无 UI 依赖；路由跳转全通过；日志统一输出到控制台+文件+Crashlytics。

* **C 完成后**：UI 视觉无回归（颜色一致）；stats 生日可设置；api\_constants 被引用。

* **D 完成后**：`flutter analyze` 零 `avoid_print`/`deprecated_member_use` 警告；home\_screen 不再 60s 全量重建（用 Flutter DevTools timeline 验证）；event\_detail 无 withOpacity。

* **E 完成后**：`use_build_context_synchronously` 零警告；Dio 错误统一弹 snackbar。

### 最终验收

1. `flutter analyze` — 零 error、零 warning（除第三方包）。
2. `dart run build_runner build --delete-conflicting-outputs` — 成功无冲突。
3. `flutter pub outdated` — 检查无已知高危漏洞版本。
4. 手动回归测试清单：

   * 首次启动（迁移路径）+ 二次启动（正常路径）

   * 新增/编辑/删除事件（含图片、重复规则、提醒）

   * 归档/取消归档

   * 每日聚合通知（后台任务触发）

   * WebDAV 备份/恢复（凭据保存、连接测试、上传下载）

   * 天气显示、GitHub 版本检查

   * 底部导航三 tab 切换 + 保活

   * 统计页（生日配置后正确计算）

   * 成就页
5. Release 构建验证：`flutter build apk --release`（或对应平台），确认 pretty\_dio\_logger 不泄露、Crashlytics 正常上报。
6. 迁移幂等性：重复启动不重复迁移；旧数据清除后无残留引用。

***

## 七、执行顺序建议（Todo List）

按依赖关系排序，避免前置未完成导致返工：

1. \[A1] 添加 analysis\_options.yaml（先立规矩，后续修改即时受 lint 约束）
2. \[B4] 合并日志系统（后续替换 print 依赖统一 AppLogger）
3. \[A2] secure storage 迁移凭据 + 模型字段移除 + 重跑 build\_runner
4. \[A3] 路由拼写修复
5. \[A4] BackupNotifier 读写一致
6. \[B1] Drift 数据库 + repository + 迁移逻辑 + provider 改造
7. \[B2] service 层抽离
8. \[B3] 路由独立成文件 + route\_names
9. \[B5] providers 拆分 + AppConfig \_update 提取
10. \[B6] http 日志安全
11. \[C1] 主题系统 + 批量替换 Color
12. \[C2] api\_constants 集中化
13. \[C3] stats 生日可配置
14. \[D1-D8] 代码质量清理（可并行，按文件分批）
15. \[E1-E3] 异步与错误处理统一
16. 最终：重跑 build\_runner + flutter analyze + 手动回归

每完成一项更新 todo 状态，每阶段结束跑一次 `flutter analyze` 拦截回归。
