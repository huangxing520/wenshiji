import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

class ConfigConstant {
  static const String isInitKey = 'isInit';
  static const String versionKey = 'version';
  static const int defaultVersion = 1;
  static const String configKey = 'app_config_data';
  static const String appName = '温时记';
  static const List<Color> springColor = [Color(0xFFFFB7B2), Color(0xFFA8E6CF)];
  static const List<Color> summerColor = [Color(0xFFFFD93D), Color(0xFF6BCB77)];
  static const List<Color> autumnColor = [Color(0xFFFF8C42), Color(0xFFD43F1A)];
  static const List<Color> winterColor = [Color(0xFFE0F2FE), Color(0xFFB1D4E0)];
  static const List<Color> defaultColor = [ Color(0xFFF7A800),  Color(0xFFF59E0B)];
  static const deviceIdKey = 'unique_device_id';
  static const String owner = "huangxing520";
  static const String repo = "wenshiji";
  static const String githubUrl = 'https://github.com/huangxing520/wenshiji/releases';
  static const String feedbackUrl = 'https://github.com/huangxing520/wenshiji/issues';
}
enum Season {
  @JsonValue(0)
  spring,
  @JsonValue(1)
  summer,
  @JsonValue(2)
  autumn,
  @JsonValue(3)
  winter
}