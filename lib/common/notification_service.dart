import 'dart:ffi';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:wenshiji/models/event.dart';

class NotificationService {
  bool hasNotificationPermission = false;
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
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
      if (!hasNotificationPermission) {
        await openNotificationSettings();
      }

      if (kDebugMode) {
        print('通知服务初始化成功, 时区: $timeZoneName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('通知服务初始化失败: $e');
      }
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



    hasNotificationPermission = true; // 直接标记为 true

    if (kDebugMode) {
      print('后台通知服务初始化成功, 时区: $timeZoneName');
    }
  } catch (e) {
    if (kDebugMode) {
      print('后台通知服务初始化失败: $e');
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
    return false;
  }

  // 打开应用通知设置页面
  Future<void> openNotificationSettings() async {
    if (Platform.isAndroid) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    if (kDebugMode) {
      print('点击了通知: ${notificationResponse.payload}');
    }
  }

  Future<void> scheduleEventNotification({
    required int id,
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
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, 
        payload: payload,
      );

      if (kDebugMode) {
        print('已安排通知: $title 在 $scheduledDate');
      }
    } catch (e) {
      if (kDebugMode) {
        print('安排通知失败: $e');
      }
    }
  }

  Future<void> cancelNotification(String id) async {
    try {
      await _notificationsPlugin.cancel(id: id.hashCode);
      if (kDebugMode) {
        print('已取消通知: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('取消通知失败: $e');
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      if (kDebugMode) {
        print('已取消所有通知');
      }
    } catch (e) {
      if (kDebugMode) {
        print('取消所有通知失败: $e');
      }
    }
  }

/// 检查指定 id 的通知是否已经安排（尚未触发）
Future<bool> isNotificationScheduled(int id) async {
  final List<PendingNotificationRequest> pendingList =
      await _notificationsPlugin.pendingNotificationRequests();
  return pendingList.any((request) => request.id == id);
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
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        print('显示即时通知失败: $e');
      }
    }
  }

  // Future<void> scheduleEventReminders(Event event) async {
  //   if (event.nextEffectiveTime.isAfter(DateTime.now())) {
  //     await scheduleEventNotification(
  //       id: event.id,
  //       title: event.name,
  //       body: event.description.isNotEmpty ? event.description : '',
  //       scheduledDate: event.nextEffectiveTime,
  //       payload: event.id,
  //     );
  //   }
  // }

  Future<void> cancelEventNotifications(String eventId) async {
    await cancelNotification(eventId);
  }
}
