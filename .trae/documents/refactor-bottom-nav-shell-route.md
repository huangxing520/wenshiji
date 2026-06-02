# 重构计划：底部导航栏独立 + ShellRoute 切换

## 概述
将 `HomeScreen` 中的底部导航栏提取到独立的 Shell 组件中，通过 GoRouter 的 `ShellRoute` + `StatefulNavigationShell` 实现 tab 切换，各 tab 页面状态保持。

## 当前状态分析

### 问题
- 底部导航栏硬编码在 [home_screen.dart:L90](file:///c:/Users/bron1117/flutter/animation/birtrhday2/lib/screens/home_screen.dart#L90) 的 Column 中
- `isActive` 硬编码为 `true`（首页），其余 tab 仅弹 Toast
- 没有使用 `ShellRoute`，所有路由平级
- `_BottomNavItem` 是 home_screen.dart 的私有类

### 目标架构
```
ShellRoute (MainShell + BottomNavBar)
  ├── /home       → HomeScreen（去掉底部导航）
  ├── /calendar   → CalendarPlaceholder（占位页）
  ├── /discover   → DiscoverPlaceholder（占位页）
  └── /profile    → ProfileScreen（去掉独立导航入口）
```

## 实施步骤

### 步骤 1：创建占位页面
**文件**: 新建 `lib/screens/placeholder_page.dart`

创建 `CalendarPlaceholder` 和 `DiscoverPlaceholder` 两个 StatelessWidget，展示简单的"开发中"界面，风格与项目一致（背景色 `#F7F3ED`，图标 + 文字居中）。

### 步骤 2：创建 Shell 组件
**文件**: 新建 `lib/screens/main_shell.dart`

创建 `MainShell` StatelessWidget，接收 `StatefulNavigationShell`：
- Scaffold 结构，`body` 为 `navigationShell`
- `bottomNavigationBar` 使用自定义 Container + Row（复用原 `_BottomNavItem` 的样式）
- 4 个 tab：首页、日历、发现、我的
- `currentIndex` 从 `navigationShell.currentIndex` 获取
- `onTap` 调用 `navigationShell.goBranch(index)`
- 将 `_BottomNavItem` 从 home_screen.dart 移到此文件（改为公开类或文件级私有均可）

### 步骤 3：修改路由配置
**文件**: [lib/main.dart](file:///c:/Users/bron1117/flutter/animation/birtrhday2/lib/main.dart)

- 引入 `ShellRoute` 和 `StatefulNavigationShell`
- 将 `/homepage` 改为 `ShellRoute` 的子路由
- 添加 `/calendar`、`/discover` 子路由
- 将 `/profile` 移入 ShellRoute 子路由（路径改为 `/profile`，不再需要 queryParameter 传 deviceId）
- `ShellRoute.builder` 返回 `MainShell(navigationShell: navigationShell)`
- 非 tab 路由（`/splash`、`/add-event`、`/event-detail`）保持平级不变
- `initialLocation` 逻辑不变

### 步骤 4：修改 HomeScreen
**文件**: [lib/screens/home_screen.dart](file:///c:/Users/bron1117/flutter/animation/birtrhday2/lib/screens/home_screen.dart)

- 删除 `_buildBottomNav()` 方法（L330-L370）
- 从 build 方法的 Column children 中移除 `_buildBottomNav()`（L90）
- 删除 `_BottomNavItem` 类（L1120-L1165）—— 已移到 main_shell.dart
- 保留其他所有内容不变（_buildTopNav、_buildTabBar、_buildFAB、_buildContextMenu 等）

### 步骤 5：修改 ProfileScreen 路由入口
**文件**: [lib/screens/profile.dart](file:///c:/Users/bron1117/flutter/animation/birtrhday2/lib/screens/profile.dart)

- ProfileScreen 通过 ShellRoute 子路由进入时，不再需要从 queryParameters 获取 deviceId
- 改为从 SharedPreferences 或 Riverpod provider 获取 deviceId
- 如果 ProfileScreen 有独立的返回按钮，需调整为 tab 内导航（去掉返回按钮或改为其他操作）

## 文件变更清单

| 文件 | 操作 | 说明 |
|------|------|------|
| `lib/screens/main_shell.dart` | **新建** | Shell 组件 + 底部导航栏 + _BottomNavItem |
| `lib/screens/placeholder_page.dart` | **新建** | 日历/发现占位页面 |
| `lib/main.dart` | **修改** | 路由改为 ShellRoute 结构 |
| `lib/screens/home_screen.dart` | **修改** | 删除底部导航栏相关代码 |
| `lib/screens/profile.dart` | **修改** | 调整 deviceId 获取方式 |

## 假设与决策
- 使用 `ShellRoute`（用户确认），不用 IndexedStack
- 日历和发现 tab 使用占位页面（用户确认）
- 只提取底部导航栏，不拆分其他类（用户确认）
- ProfileScreen 的 deviceId 获取方式需适配 ShellRoute（从 SharedPreferences 读取）
- 底部导航栏样式保持原有自定义实现（Container + Row + _BottomNavItem），不改用 Material BottomNavigationBar

## 验证步骤
1. `flutter analyze` 无错误
2. 首页正常显示，底部导航栏可见，4个 tab 可切换
3. 切换 tab 时页面状态保持（首页的滚动位置、分类选择等）
4. 从首页进入 add-event / event-detail 等页面时，底部导航栏不显示（这些是平级路由）
5. ProfileScreen 正常加载，deviceId 正确获取
