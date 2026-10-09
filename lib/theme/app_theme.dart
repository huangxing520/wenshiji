import 'package:flutter/material.dart';
import 'package:wenshiji/theme/app_colors.dart';

/// 应用全局 [ThemeData]。
///
/// 基于 [AppColors.primary] 金色生成 `ColorScheme`，
/// 保持与原 `main.dart` 内联 `ThemeData` 完全一致的视觉行为。
/// 各屏 bespoke 样式仍由屏幕内 Widget 自行定义，此处仅提供 ColorScheme 基线。
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  useMaterial3: true,
);
