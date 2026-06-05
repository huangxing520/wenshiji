import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenshiji/models/appconfig.dart';
part 'generated/app_config.g.dart';

@Riverpod(keepAlive: true)
class AppConfigNotifier extends _$AppConfigNotifier {
   // 本地存储的 Key
  static const _storageKey = 'app_config_data';

  /// 1. 初始化：从本地加载数据（没有则用默认值）
  @override
  Future<AppConfig> build() async {
   return await _loadFromLocal(); // 启动时读取本地数据
   
  }

  // ====================== 【自动加载本地数据】 ======================
  Future<AppConfig> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      // 把本地JSON → 转为AppConfig对象 → 更新状态
     return AppConfig.fromJson(jsonDecode(jsonString));
    }
    return AppConfig();
  }

  // ====================== 【自动保存到本地】 ======================
  Future<void> _saveToLocal(AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(config.toJson());
    await prefs.setString(_storageKey, jsonString);
  }
 Future<void> setNotificationDndOn(bool value) async{
    state = AsyncData(state.requireValue.copyWith(notificationDndOn: value));
    await _saveToLocal(state.requireValue);
  }

  Future<void> setNotificationDigestOn(bool value) async{
   state = AsyncData(state.requireValue.copyWith(notificationDigestOn: value));
    await _saveToLocal(state.requireValue);

  }

  Future<void> setNotificationStartHour(int value) async{
    state = AsyncData(state.requireValue.copyWith(notificationStartHour: value));
        await _saveToLocal(state.requireValue);

  }

  Future<void> setNotificationEndHour(int value) async{
   state = AsyncData(state.requireValue.copyWith(notificationEndHour: value));
    await _saveToLocal(state.requireValue);

  }

  Future<void> setNotificationEndMinute(int value) async{
    state = AsyncData(state.requireValue.copyWith(notificationEndMinute: value));
        await _saveToLocal(state.requireValue);

  }

  Future<void> setNotificationStartMinute(int value) async{
    state = AsyncData(state.requireValue.copyWith(notificationStartMinute: value));
        await _saveToLocal(state.requireValue);

  }
  Future<void> setNotificationDigestTime(String value) async{
    state = AsyncData(state.requireValue.copyWith(notificationDigestTime: value));
        await _saveToLocal(state.requireValue);

  }

  Future<void> setNotificationDndDays(List<bool> value) async{
    state = AsyncData(state.requireValue.copyWith(notificationDndDays: List<bool>.from(value)));
        await _saveToLocal(state.requireValue);
  }
  Future<void> setBackupDirectory(String value) async{
    state = AsyncData(state.requireValue.copyWith(backupDirectory: value));
        await _saveToLocal(state.requireValue);
  }
  Future<void> setBackupServerUrl(String value) async{
    state = AsyncData(state.requireValue.copyWith(backupServerUrl: value));
        await _saveToLocal(state.requireValue);
  }
  Future<void> setBackupUsername(String value) async{
    state = AsyncData(state.requireValue.copyWith(backupUsername: value));
        await _saveToLocal(state.requireValue);
  }
  Future<void> setBackupPassword(String value) async{
    state = AsyncData(state.requireValue.copyWith(backupPassword: value));
        await _saveToLocal(state.requireValue);
  }

}
