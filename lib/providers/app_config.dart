import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/constants/config_constant.dart';
import 'package:wenshiji/models/appconfig.dart';
part 'generated/app_config.g.dart';

@Riverpod(keepAlive: true)
class AppConfigNotifier extends _$AppConfigNotifier {
  // 键名以 ConfigConstant.configKey 为单一真相源，避免与 Preferences 各持一份字面量。
  static const _storageKey = ConfigConstant.configKey;

  /// 初始化：从本地加载数据（没有则用默认值）
  @override
  Future<AppConfig> build() async {
    return await _loadFromLocal();
  }

  // ====================== 【自动加载本地数据】 ======================
  Future<AppConfig> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        return AppConfig.fromJson(jsonDecode(jsonString));
      } catch (e, s) {
        // 本地数据损坏时降级为默认配置，而不是让 provider 停留在 error 态
        // （error 态下所有设置项不可用，用户无从恢复）。
        AppLogger().error('AppConfig 解析失败，使用默认配置', error: e, stack: s);
      }
    }
    return AppConfig();
  }

  // ====================== 【自动保存到本地】 ======================
  Future<void> _saveToLocal(AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(config.toJson());
    final ok = await prefs.setString(_storageKey, jsonString);
    if (!ok) {
      throw StateError('写入 AppConfig 失败');
    }
  }

  /// 通用更新方法：消除 12+ setter 的重复样板。
  /// 传入 [updater] 返回新的 AppConfig，自动更新 state 并持久化。
  ///
  /// 关键约束：
  /// - state 处于 error / loading（拿不到现值）时**不写入**，绝不以全默认
  ///   `AppConfig()` 为基线落盘——那会把用户已保存的配置静默覆盖为默认值；
  /// - 落盘失败时回滚 state（界面会看到开关弹回），不向上抛，
  ///   避免 fire-and-forget 的调用点产生未捕获异步异常。
  Future<void> _update(AppConfig Function(AppConfig config) updater) async {
    final current = state.value;
    if (current == null) {
      // 加载失败 / 尚未就绪：拒绝写入。此处不抛异常，因为调用点包含
      // fire-and-forget（如 stats.dart 的 unawaited），抛出会变成未捕获异步错误。
      AppLogger().warning('AppConfig 尚未就绪，忽略本次修改');
      return;
    }
    final next = updater(current);
    state = AsyncData(next);
    try {
      await _saveToLocal(next);
    } catch (e, s) {
      // 回滚到落盘前的值：内存与磁盘保持一致。
      AppLogger().error('保存 AppConfig 失败，已回滚', error: e, stack: s);
      state = AsyncData(current);
    }
  }

  /// 用备份中的配置整体覆盖本地配置（备份恢复用）。
  /// 保留 [AppConfig.isSettingWorkManager]：它是本机任务注册状态，非用户数据，
  /// 由启动同步 / 设置页维护，不应被远端备份改写。
  Future<void> restoreConfig(AppConfig config) async {
    final current = state.value;
    final merged = config.copyWith(
      isSettingWorkManager: current?.isSettingWorkManager ?? false,
    );
    state = AsyncData(merged);
    await _saveToLocal(merged);
  }

  Future<void> setNotificationDndOn(bool value) async {
    await _update((c) => c.copyWith(notificationDndOn: value));
  }

  Future<void> setNotificationDigestOn(bool value) async {
    await _update((c) => c.copyWith(notificationDigestOn: value));
  }

  Future<void> setNotificationStartHour(int value) async {
    await _update((c) => c.copyWith(notificationStartHour: value));
  }

  Future<void> setNotificationEndHour(int value) async {
    await _update((c) => c.copyWith(notificationEndHour: value));
  }

  Future<void> setNotificationEndMinute(int value) async {
    await _update((c) => c.copyWith(notificationEndMinute: value));
  }

  Future<void> setNotificationStartMinute(int value) async {
    await _update((c) => c.copyWith(notificationStartMinute: value));
  }

  Future<void> setNotificationDigestTime(String value) async {
    await _update((c) => c.copyWith(notificationDigestTime: value));
  }

  Future<void> setIsSettingWorkManager(bool value) async {
    await _update((c) => c.copyWith(isSettingWorkManager: value));
  }

  Future<void> setNotificationDndDays(List<bool> value) async {
    await _update(
      (c) => c.copyWith(notificationDndDays: List<bool>.from(value)),
    );
  }

  Future<void> setBackupDirectory(String value) async {
    await _update((c) => c.copyWith(backupDirectory: value));
  }

  Future<void> setBirthday(String value) async {
    await _update((c) => c.copyWith(birthday: value));
  }
}
