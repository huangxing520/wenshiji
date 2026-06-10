import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/appconfig.freezed.dart';
part 'generated/appconfig.g.dart';
@freezed
abstract class AppConfig with _$AppConfig {
  factory AppConfig({
    // 免打扰
    @Default(false) bool notificationDndOn,
    // 每日聚合推送
    @Default(false) bool notificationDigestOn,
    @Default(22) int notificationStartHour,
    @Default(0) int notificationStartMinute,
    @Default(7) int notificationEndHour,
    @Default(0) int notificationEndMinute,
    @Default('evening') String notificationDigestTime,
    @Default([true, true, true, true, true, true, true]) List<bool> notificationDndDays,
    @Default('/温时记') String backupDirectory,
    @Default('') String backupServerUrl,
    @Default('') String backupUsername,
    @Default('') String backupPassword,
    // 是否设置android workmanager任务
    @Default(false) bool isSettingWorkManager,
  }
    
  ) = _AppConfig;
  factory AppConfig.fromJson(Map<String, Object?> json) =>
      _$AppConfigFromJson(json);
}
