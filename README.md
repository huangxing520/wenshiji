<!-- ───────────────────────────────────────────────────────────────
     温时记 · Wenshiji
     A Flutter time-counting & life-logging application
     ─────────────────────────────────────────────────────────────── -->

<p align="center">
  <img src="assets/icon/icon.png" width="120" alt="温时记 Logo" />
</p>

<h1 align="center">温时记 · Wenshiji</h1>

<p align="center">
  <em>记录时间流逝，感知生命温度</em>
  <br />
  <em>Count the days that matter — birthdays, anniversaries, habits, and more.</em>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.38+-02569B?logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.8+-0175C2?logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Android-6.0+-3DDC84?logo=android&logoColor=white" alt="Android" /></a>
  <a href="#"><img src="https://img.shields.io/badge/iOS-14+-000000?logo=apple&logoColor=white" alt="iOS" /></a>
  <a href="#"><img src="https://img.shields.io/badge/macOS-supported-000000?logo=apple&logoColor=white" alt="macOS" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Windows-supported-0078D6?logo=windows&logoColor=white" alt="Windows" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Linux-supported-FCC624?logo=linux&logoColor=black" alt="Linux" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Web-supported-4285F4?logo=googlechrome&logoColor=white" alt="Web" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" /></a>
</p>

---

## 📖 简介 | Introduction

**温时记 (Wenshiji)** 是一款记录时间流逝的跨平台 Flutter 应用。它帮助你追踪生日、纪念日、待办事项、节日等所有值得铭记的日子——无论是倒计时期待，还是正计时打卡，温时记都会让时间的流逝变得可视、可感、可回味。

**Wenshiji** is a cross-platform Flutter app for counting down to (or up from) the moments that matter — birthdays, anniversaries, to‑dos, festivals, and beyond. It makes the passage of time visible, tangible, and memorable.

---

## ✨ 功能亮点 | Features

- 🎂 **多类型事件管理** — 生日、事项（倒计时 / 连签计时）、节日（支持公历 / 农历，农历自动换算含闰月）、自定义事件
- 📌 **置顶与星标** — 置顶卡片配合四季渐变动态背景，星标事件快速筛选
- ✅ **快速打卡** — 正计时事件一键签到，连续打卡统计
- 🏅 **成就系统** — 铜 / 银 / 金 / 钻石四级徽章，里程碑达成全屏庆祝
- 📊 **数据统计** — 贡献热力图（年度 / 月度）、人生进度百分比
- 🗄️ **归档管理** — 已完成事件归档，支持搜索与分类筛选
- 🔔 **本地通知** — 免打扰时段、每日聚合推送（早晨 & 傍晚）、后台定期任务
- ☁️ **WebDAV 云备份** — 凭据安全存储（Keystore / Keychain / DPAPI），一键备份与恢复
- 📸 **图片附件** — 多图选取、网格展示、Hero 动画全屏预览（支持缩放平移）
- 🎨 **季节感知 UI** — 首页背景根据当前月份自动切换春 / 夏 / 秋 / 冬配色
- 🌐 **六端覆盖** — Android · iOS · macOS · Windows · Linux · Web

---

| 功能 | 英文 |
|---|---|
| 多类型事件管理 | Multi-type event management (birthday / task / festival / custom) |
| 置顶与星标 | Pin & star events with seasonal animated backgrounds |
| 快速打卡 | One-tap check-in for count-up events with streak tracking |
| 成就系统 | Achievement system — bronze / silver / gold / diamond badges |
| 数据统计 | Contribution heatmap (yearly / monthly) & life-progress percentage |
| 归档管理 | Archive with search & category filter |
| 本地通知 | Do-not-disturb window, daily digest push (morning & evening) |
| WebDAV 云备份 | Encrypted credential storage + one-click cloud backup |
| 图片附件 | Multi-image picker with Hero full‑screen preview & pinch‑zoom |
| 季节感知 UI | Season-aware color palette (spring / summer / autumn / winter) |
| 六端覆盖 | Android · iOS · macOS · Windows · Linux · Web |

---

## 🧱 技术栈 | Tech Stack

| 层级 | Layer | 技术 | Technology |
|---|---|---|---|
| 框架 | Framework | Flutter 3.38+ · Dart 3.8+ |
| 状态管理 | State | Riverpod (`flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`) |
| 数据库 | Database | Drift (SQLite) with custom type converters |
| 路由 | Router | GoRouter (`StatefulShellRoute` for persistent tab state) |
| 数据类 | Models | Freezed + json_serializable (code generation) |
| 网络 | Network | Dio + pretty_dio_logger |
| 通知 | Notifications | flutter_local_notifications + WorkManager |
| 云备份 | Cloud | webdav_client_plus + flutter_secure_storage |
| 监控 | Monitoring | Firebase Crashlytics + Firebase Analytics |
| 日志 | Logging | Custom multi-sink logger (console + file + Crashlytics) |
| CI/CD | CI/CD | GitHub Actions (flutter_build_apk.yml) |
| 构建 | Build | Makefile + build_runner |

---

## 🏗️ 架构 | Architecture

```
┌─────────────────────────────────────────────────┐
│  Screens   (12 screens)                         │
├─────────────────────────────────────────────────┤
│  Providers (Riverpod — 6 files, keepAlive)      │
├─────────────────────────────────────────────────┤
│  Services  (5 services)  │  Models (5 freezed)  │
├─────────────────────────────────────────────────┤
│  DAO       (EventDao)    │  Common (7 utilities) │
├─────────────────────────────────────────────────┤
│  Database  (Drift/SQLite — Events table, 16 cols)│
└─────────────────────────────────────────────────┘
```

**数据流 / Data flow:**

```
UI (Screens) → Providers (AsyncNotifier) → DAO → Drift DB
                   ↕
              Services (HTTP / WebDAV / Weather / Notification)
```

---

## 📁 项目结构 | Project Structure

```
lib/
├── main.dart                     # 入口 — 初始化 Firebase / DB / 通知 / 后台任务
├── firebase_options.dart         # Firebase 环境配置
├── common/                       # 通用工具
│   ├── app_logger.dart           # 多 sink 日志（控制台 + 文件 + Crashlytics）
│   ├── http.dart                 # Dio 单例 HTTP 客户端
│   ├── preferences.dart          # SharedPreferences 封装
│   ├── secure_storage.dart       # 凭据安全存储 + 明文迁移
│   ├── notification_service.dart # 本地通知单例
│   ├── utils.dart                # Toast / 版本 / 季节 / 样本数据 等
│   ├── debouncer.dart            # 防抖工具
├── database/                     # 数据库层
│   ├── wenshiji_database.dart    # 表定义 + 类型转换器
│   └── event_dao.dart            # 数据访问对象（CRUD）
├── models/                       # 数据模型 (freezed)
│   ├── event.dart                # Event（枚举: EventType / Priority / RepeatRule）
│   ├── appconfig.dart            # AppConfig
│   ├── backup.dart               # BackupRecord / BackupData
│   └── github_release.dart       # Release（版本检测）
├── providers/                    # Riverpod 状态管理
│   ├── event.dart                # EventNotifier（CRUD + 置顶 / 星标 / 打卡 / 归档）
│   ├── event_filter_providers.dart # 分类筛选 / 派生列表
│   ├── stats_provider.dart       # 统计计算
│   ├── image_providers.dart      # 图片选取 / 保存
│   ├── app_config.dart           # AppConfigNotifier (keepAlive)
│   └── backup.dart               # BackupNotifier (keepAlive)
├── router/                       # 路由
│   ├── app_router.dart           # StatefulShellRoute + 独立路由
│   └── route_names.dart          # 路由常量
├── screens/                      # 页面
│   ├── splash_screen.dart        # 闪屏（多层动画）
│   ├── main_shell.dart           # 底部导航外壳（3 Tab）
│   ├── home_screen.dart          # 首页（列表 + 分类 + 置顶卡片）
│   ├── add_event.dart            # 添加 / 编辑事件
│   ├── event_detail.dart         # 事件详情
│   ├── stats.dart                # 数据统计（热力图 + 人生进度）
│   ├── archive.dart              # 归档
│   ├── achievement.dart          # 成就（徽章墙）
│   ├── profile.dart              # 个人中心
│   ├── backup.dart               # WebDAV 备份
│   ├── about.dart                # 关于（版本检测）
│   └── notification_setting.dart # 通知设置
├── services/                     # 服务层
│   ├── backup_service.dart       # 备份编排
│   ├── github_service.dart       # GitHub Release API
│   ├── image_service.dart        # 图片选取 / 保存 / 删除
│   └── webdav_service.dart       # WebDAV 客户端
├── theme/                        # 主题
│   ├── app_colors.dart           # 金色系调色板 + 四季色
│   └── app_theme.dart            # Material 3 ColorScheme
└── widget/                       # 通用组件
    ├── card.dart                 # 图片卡片
    ├── navigationBar.dart        # 通用导航栏
    └── bottom_sheet.dart         # 底部面板工具
```

---

## 🚀 快速开始 | Getting Started

### 环境要求 | Prerequisites

- Flutter SDK ≥ 3.38
- Dart ≥ 3.8
- Android Studio / VS Code
- Firebase 项目（用于 Crashlytics & Analytics，可选）

### 运行步骤 | Steps

```bash
# 1. 克隆仓库
git clone https://github.com/bronzjoy/wenshiji.git
cd wenshiji

# 2. 获取依赖
flutter pub get

# 3. 生成代码（freezed / json / drift / riverpod）
make build-runner
# 或手动执行: dart run build_runner build --delete-conflicting-outputs

# 4. 运行
flutter run
```

### 构建 | Build

```bash
# Debug APK
make apk-debug

# Release APK（单包）
make apk-release

# Release APK（按 CPU 架构分割）
make apk-release-split

# Google Play App Bundle
make aab-release

# 静态代码分析
make analyze
```

> 完整命令列表见项目根目录下的 [`Makefile`](Makefile)。

---

## 📐 设计模式 | Design Patterns

| 模式 | Pattern | 应用场景 |
|---|---|---|
| 单例 | Singleton | NotificationService, SecureStorage, HttpUtil, Utils, BackupService, AppLogger |
| 工厂 | Factory | Drift `AppDatabase` 实例化 |
| 不可变数据类 | Immutable models | Freezed 生成的所有 Model |
| 依赖注入 | DI | Riverpod `Provider<T>` 全局注入 |
| 观察者 | Observer | Riverpod `ref.watch` / `ref.listen` |
| 代码生成 | Code generation | freezed → json_serializable → drift_dev → riverpod_generator |

---

## 📄 开源协议 | License

本项目基于 **MIT License** 开源。详见 [LICENSE](LICENSE) 文件。



