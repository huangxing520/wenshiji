import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wenshiji/common/logger.dart';
import 'package:wenshiji/models/appconfig.dart';
import 'package:wenshiji/models/event.dart';

import '../constants/config_constant.dart';

class Preferences {
  static Preferences? _instance;
  Completer<SharedPreferences?> sharedPreferencesCompleter = Completer();

  Future<bool> get isInit async =>
      await sharedPreferencesCompleter.future != null;

  Preferences._internal() {
    SharedPreferences.getInstance()
        .then((value) => sharedPreferencesCompleter.complete(value))
        .onError(
          (error, stackTrace) => sharedPreferencesCompleter.complete(null),
        );
  }

  factory Preferences() {
    _instance ??= Preferences._internal();
    return _instance!;
  }

  Future<int> getVersion() async {
    final preferences = await sharedPreferencesCompleter.future;
    return preferences?.getInt('version') ?? 0;
  }

  Future<void> setVersion(int version) async {
    final preferences = await sharedPreferencesCompleter.future;
    await preferences?.setInt('version', version);
  }

  Future<void> saveInitState(bool isInit) async {
    final preferences = await sharedPreferencesCompleter.future;
    await preferences?.setBool(ConfigConstant.isInitKey, isInit);
  }

  Future<bool> getInitState() async {
    final preferences = await sharedPreferencesCompleter.future;
    return preferences?.getBool(ConfigConstant.isInitKey) ?? false;
  }

  Future<AppConfig?> getConfig() async {
    try {
      final preferences = await sharedPreferencesCompleter.future;
      final configString = preferences?.getString(ConfigConstant.configKey);
      if (configString == null) return null;
      final config = AppConfig.fromJson(jsonDecode(configString));
      return config;
    } catch (_) {
      return null;
    }
  }

  Future<bool> setConfig(AppConfig config) async {
    final preferences = await sharedPreferencesCompleter.future;
    return preferences?.setString(
          ConfigConstant.configKey,
          json.encode(config),
        ) ??
        false;
  }

  Future<void> setIsSettingWorkManager(bool isSettingWorkManager) async {
    final appConfig = await getConfig();

    if (appConfig == null) {
      return;
    }
   
    final newConfig = appConfig.copyWith(isSettingWorkManager: isSettingWorkManager);
    await setConfig(newConfig);
    
  }

  Future<List<Event>> getEvents() async {
    try {
      final preferences = await sharedPreferencesCompleter.future;
      final eventsString = preferences?.getString('events');
      //AppLogger().info('eventsString: $eventsString');
      if (eventsString == null) return [];

      final List<dynamic> jsonList = json.decode(eventsString);
      return jsonList
          .map((json) => Event.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> setEvents(String eventsString) async {
    final preferences = await sharedPreferencesCompleter.future;
    await preferences?.setString('events', eventsString);
  }

  // Future<Config?> getConfig() async {
  //   final configMap = await getConfigMap();
  //   if (configMap == null) {
  //     return null;
  //   }
  //   return Config.fromJson(configMap);
  // }

  // Future<bool> saveConfig(Config config) async {
  //   final preferences = await sharedPreferencesCompleter.future;
  //   return preferences?.setString(configKey, json.encode(config)) ?? false;
  // }

  Future<void> clearPreferences() async {
    final sharedPreferencesIns = await sharedPreferencesCompleter.future;
    await sharedPreferencesIns?.clear();
  }

  // 获取设备唯一ID（首次生成，之后复用）
  Future<String> getDeviceId() async {
    final sharedPreferencesIns = await sharedPreferencesCompleter.future;
    final storedId = sharedPreferencesIns?.getString(
      ConfigConstant.deviceIdKey,
    );

    if (storedId == null || storedId.isEmpty) {
      final uuid = Uuid();
      // 生成新UUID并存储
      String newId = uuid.v4();
      await sharedPreferencesIns?.setString(ConfigConstant.deviceIdKey, newId);
      return newId;
    }

    return storedId;
  }
}

final preferences = Preferences();
