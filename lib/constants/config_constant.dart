import 'package:freezed_annotation/freezed_annotation.dart';

class ConfigConstant {
  static const String isInitKey = 'isInit';
  static const String versionKey = 'version';
  static const int defaultVersion = 1;
  static const String configKey = 'app_config_data';
  static const String appName = '温时记';
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