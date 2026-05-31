# 温时记

一个优雅的 Flutter 倒计时提醒应用，用于记录重要时刻。

## 功能特性

- 精美的启动页面，带有流畅的动画效果
- 倒计时卡片，实时显示剩余时间（天/时/分/秒）
- 支持添加 emoji 图标和备注信息
- 本地数据存储
- 支持已过期和未过期倒计时的区分显示
- 左滑删除功能

## 技术栈

- Flutter SDK
- Provider (状态管理)
- SharedPreferences (本地存储)
- Intl (日期格式化)
- Uuid (唯一 ID 生成)

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/
│   └── countdown.dart        # 倒计时数据模型
├── providers/
│   └── countdown_provider.dart # 倒计时状态管理
└── screens/
    ├── splash_screen.dart    # 启动页面
    ├── home_screen.dart      # 主页面
    └── add_countdown_screen.dart # 添加倒计时页面
```

## 开始使用

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
flutter run
```

## 开发者说明

这个应用采用了暖色调的设计风格，体现了时间的温暖与珍贵。启动页面的动画完全模拟了提供的 HTML 效果，包括背景粒子、环形动画、文字动画等。
