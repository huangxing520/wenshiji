import 'dart:ui';

/// 应用共享调色板 —— 单一真相源。
///
/// 分三部分：
/// 1. **品牌主色**：[primary] 即 app 金色种子，作为 `ColorScheme.fromSeed` 的种子，
///    并在多屏作为强调色（accent）复用。
/// 2. **设计调色板**：迁自 `about.dart` 的 19 个文件私有 `_k` 常量，公开为具名色，
///    消除跨文件同值漂移；棕色梯度用于文本/图标，琥珀/橙色系用于品牌强调与按钮，
///    功能色（green/blue/purple/red/success/warning）用于状态与分类。
/// 3. **四季色**：迁自 `config_constant.dart`，按季节切换的渐变色对。
///
/// 各屏幕 bespoke 设计色（渐变端点、局部点缀色等）仍以字面量保留在屏幕文件中，
/// 仅此处共享色集中管理。
class AppColors {
  AppColors._();

  // ==================== 1. 品牌主色 ====================
  /// 应用品牌金色，作为 `ColorScheme.fromSeed` 的种子色，
  /// 并在 add_event / event_detail / home_screen / splash_screen / stats 等屏作为强调色。
  static const Color primary = Color(0xFFD4A853);

  // ==================== 2. 设计调色板 ====================
  // ---- 棕色文本/图标梯度（迁自 about.dart 的 _kPrimaryDark / _kPrimary / _kSecondary / _kTertiary / _kQuaternary） ----
  /// 最深棕 —— 标题、强调文本、主要图标。
  static const Color textPrimary = Color(0xFF5D4037);
  /// 正文棕 —— 模态/协议正文、次要按钮文本。
  static const Color textSecondary = Color(0xFF795548);
  /// 描述棕 —— 菜单描述、版本号。
  static const Color textTertiary = Color(0xFF8D6E63);
  /// 副标题棕 —— 副标题、页脚。
  static const Color textQuaternary = Color(0xFFA1887F);
  /// 最浅棕 —— chevron 图标、版权声明。
  static const Color textFaint = Color(0xFFBCAAA4);

  // ---- 琥珀/橙色系（迁自 about.dart 的 _kAmber / _kOrange / _kAmberDark / _kAmberOrange） ----
  static const Color amber = Color(0xFFFFC107);
  static const Color orange = Color(0xFFFFA726);
  static const Color amberDark = Color(0xFFFF8F00);
  static const Color amberOrange = Color(0xFFFF9800);

  // ---- 功能色 ----
  static const Color green = Color(0xFF81C784);
  static const Color blue = Color(0xFF64B5F6);
  static const Color purple = Color(0xFFBA68C8);
  static const Color red = Color(0xFFFF5722);
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFB300);

  // ---- 闪屏背景渐变（迁自 about.dart 的 _kSplashBgTop / _kSplashBgMid / _kSplashBgBottom） ----
  static const Color splashBgTop = Color(0xFFFFF8E1);
  static const Color splashBgMid = Color(0xFFFFF3E0);
  static const Color splashBgBottom = Color(0xFFFFE0B2);

  // ---- 分隔线（迁自 about.dart 的 _kDividerColor） ----
  static const Color divider = Color(0x1FFFA000);

  // ==================== 3. 四季色（迁自 config_constant.dart） ====================
  /// 春 —— 樱粉 + 薄荷。
  static const List<Color> springColor = [Color(0xFFFFB7B2), Color(0xFFA8E6CF)];
  /// 夏 —— 向日葵金 + 翠绿。
  static const List<Color> summerColor = [Color(0xFFFFD93D), Color(0xFF6BCB77)];
  /// 秋 —— 暖橙 + 枫红。
  static const List<Color> autumnColor = [Color(0xFFFF8C42), Color(0xFFD43F1A)];
  /// 冬 —— 冰蓝 + 雾灰蓝。
  static const List<Color> winterColor = [Color(0xFFE0F2FE), Color(0xFFB1D4E0)];
  /// 默认 —— 琥珀金 + 深金。
  static const List<Color> defaultColor = [Color(0xFFF7A800), Color(0xFFF59E0B)];
}
