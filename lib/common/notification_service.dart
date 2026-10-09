import 'dart:ffi';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/models/event.dart';

class NotificationService {
  bool hasNotificationPermission = false;
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  /// 初始化通知服务。返回是否成功，失败不再被静默吞掉，交由调用方感知。
  ///
  /// 注意：**不再**在权限被拒时自动跳转系统设置页——那会导致用户拒绝一次后
  /// 每次冷启动都被强行踢到设置页、回不到首页。改为仅记录 [hasNotificationPermission]，
  /// 由通知设置页的「打开系统通知设置」按钮让用户主动开启。
  Future<bool> init() async {
    try {
      tz.initializeTimeZones();
      final TimezoneInfo timezoneInfo =
          await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timezoneInfo.identifier ?? 'Asia/Shanghai';
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );
      hasNotificationPermission =
          await _checkAndRequestNotificationPermissions();

      if (kDebugMode) {
        AppLogger().debug('通知服务初始化成功, 时区: $timeZoneName');
      }
      return true;
    } catch (e, s) {
      AppLogger().error('通知服务初始化失败', error: e, stack: s);
      return false;
    }
  }
// 只在workmanager中初始化后台通知服务调用这个函数
Future<void> initForBackground() async {
  try {
        WidgetsFlutterBinding.ensureInitialized();

    // 时区初始化（必须在 isolate 中重新执行）
    tz.initializeTimeZones();
    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = timezoneInfo.identifier ?? 'Asia/Shanghai';
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // 通知插件初始化（不需要请求权限）
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(settings: initializationSettings);

    // 后台 isolate 不能弹权限框，这里按平台读取真实授权状态，
    // 而不是无脑置 true（否则未授权时通知被系统静默丢弃，调用方却以为已就绪）。
    hasNotificationPermission = await _hasNotificationPermission();

    if (kDebugMode) {
      AppLogger().debug('后台通知服务初始化成功, 时区: $timeZoneName');
    }
  } catch (e) {
    if (kDebugMode) {
      AppLogger().error('后台通知服务初始化失败: $e');
    }
    rethrow;
  }
}



  // 新增：检查并请求通知权限
  Future<bool> _checkAndRequestNotificationPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        // Android 13+ 请求POST_NOTIFICATIONS权限
        final bool? granted = await androidImplementation
            .requestNotificationsPermission();
        return granted ?? false;
      }
      return true; // Android 12及以下默认授予
    }
    if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
      final bool? granted = await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return false;
  }

  /// 仅查询当前授权状态，不弹窗（供后台 isolate 使用）。
  Future<bool> _hasNotificationPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? granted = await androidImplementation
          ?.areNotificationsEnabled();
      return granted ?? true;
    }
    return true;
  }

  // 打开应用通知设置页面
  Future<void> openNotificationSettings() async {
    if (Platform.isAndroid) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    if (kDebugMode) {
      AppLogger().debug('点击了通知: ${notificationResponse.payload}');
    }
  }

  /// 即时通知的固定 id：同一 id 再次 show 会就地更新，避免旧实现用
  /// 秒级时间戳导致「同一秒内两次调用互相覆盖」。
  static const int instantNotificationId = 0x7f0a0001;

  /// 将任意字符串 key 稳定映射为通知 id（FNV-1a，取 31 位非负，兼容 Android int）。
  /// schedule / cancel / isScheduled 三处**必须**共用此函数，否则取消不到已排期的通知。
  static int notificationIdFor(String key) {
    const int fnvOffsetBasis = 0x811c9dc5;
    const int fnvPrime = 0x01000193;
    int hash = fnvOffsetBasis;
    for (final codeUnit in key.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * fnvPrime) & 0x7fffffff;
    }
    return hash;
  }

  Future<void> scheduleEventNotification({
    required String key,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'event_channel',
            '事件提醒',
            channelDescription: '用于事件提醒的通知',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            playSound: true,
            enableVibration: false,
            icon: '@mipmap/ic_launcher',
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notificationsPlugin.zonedSchedule(
        id: notificationIdFor(key),
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, 
        payload: payload,
      );

      if (kDebugMode) {
        AppLogger().debug('已安排通知: $title 在 $scheduledDate');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger().error('安排通知失败: $e');
      }
    }
  }

  /// 按 key 取消通知（与 schedule 使用同一 id 派生）。
  Future<void> cancelNotification(String key) async {
    try {
      await _notificationsPlugin.cancel(id: notificationIdFor(key));
      if (kDebugMode) {
        AppLogger().debug('已取消通知: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger().error('取消通知失败: $e');
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      if (kDebugMode) {
        AppLogger().debug('已取消所有通知');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger().error('取消所有通知失败: $e');
      }
    }
  }

/// 检查指定 key 的通知是否已经安排（尚未触发）
Future<bool> isNotificationScheduled(String key) async {
  final List<PendingNotificationRequest> pendingList =
      await _notificationsPlugin.pendingNotificationRequests();
  final targetId = notificationIdFor(key);
  return pendingList.any((request) => request.id == targetId);
}



  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'instant_channel',
            '即时通知',
            channelDescription: '用于即时通知',
            importance: Importance.max,
            priority: Priority.high,
            playSound: false,
          );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _notificationsPlugin.show(
        id: instantNotificationId,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger().error('显示即时通知失败: $e');
      }
    }
  }

  /// 事件 key → 通知 key。事件提醒若以 `event:<id>` 排期，删除 / 编辑时用同 key 取消。
  static String eventNotificationKey(String eventId) => 'event:$eventId';

  /// 后台每日聚合推送的通知 key（与排期处共用）。
  static const String dailyDigestKey = 'daily-digest';

  /// 取消某个事件已排期的提醒通知。
  Future<void> cancelEventNotifications(String eventId) async {
    await cancelNotification(eventNotificationKey(eventId));
  }
}
