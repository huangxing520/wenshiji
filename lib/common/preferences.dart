import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/config_constant.dart';

class Preferences {
  static Preferences? _instance;
  Completer<SharedPreferences?> sharedPreferencesCompleter = Completer();

  Future<bool> get isInit async =>
      await sharedPreferencesCompleter.future != null;

  Preferences._internal() {
    SharedPreferences.getInstance()
        .then((value) => sharedPreferencesCompleter.complete(value))
        .onError((error, stackTrace) => sharedPreferencesCompleter.complete(null));
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

  Future<Map<String, Object?>?> getConfigMap() async {
    try {
      final preferences = await sharedPreferencesCompleter.future;
      final configString = preferences?.getString(ConfigConstant.configKey);
      if (configString == null) return null;
      final Map<String, Object?>? configMap = json.decode(configString);
      return configMap;
    } catch (_) {
      return null;
    }
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
}

final preferences = Preferences();
