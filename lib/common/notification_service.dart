import 'package:app_settings/app_settings.dart';
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
      hasNotificationPermission = await _checkAndRequestNotificationPermissions();
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
    required String id,
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
        id: id.hashCode,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

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
            playSound: false
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

  Future<void> scheduleEventReminders(Event event) async {
    for (final reminder in event.reminder) {
      DateTime? scheduledDate;

      switch (reminder) {
        case EventReminder.none:
          continue;
        case EventReminder.daily:
          scheduledDate = event.date.subtract(const Duration(days: 1));
          break;
        case EventReminder.weekly:
          scheduledDate = event.date.subtract(const Duration(days: 7));
          break;
        case EventReminder.threeDays:
          scheduledDate = event.date.subtract(const Duration(days: 3));
          break;
        case EventReminder.sevenDays:
          scheduledDate = event.date.subtract(const Duration(days: 7));
          break;
        case EventReminder.fifteenDays:
          scheduledDate = event.date.subtract(const Duration(days: 15));
          break;
        case EventReminder.thirtyDays:
          scheduledDate = event.date.subtract(const Duration(days: 30));
          break;
        case EventReminder.oneHour:
          scheduledDate = event.date.subtract(const Duration(hours: 1));
          break;
      }

      if (scheduledDate != null && scheduledDate.isAfter(DateTime.now())) {
        final reminderTitle = _getReminderTitle(reminder);
        await scheduleEventNotification(
          id: '${event.id}_${reminder.index}',
          title: '$reminderTitle - ${event.name}',
          body: event.description.isNotEmpty ? event.description : '',
          scheduledDate: scheduledDate,
          payload: event.id,
        );
      }
    }
  }

  String _getReminderTitle(EventReminder reminder) {
    switch (reminder) {
      case EventReminder.none:
        return '';
      case EventReminder.daily:
        return '明天';
      case EventReminder.weekly:
        return '一周后';
      case EventReminder.threeDays:
        return '3天后';
      case EventReminder.sevenDays:
        return '7天后';
      case EventReminder.fifteenDays:
        return '15天后';
      case EventReminder.thirtyDays:
        return '30天后';
      case EventReminder.oneHour:
        return '1小时后';
    }
  }

  Future<void> cancelEventNotifications(String eventId) async {
    for (int i = 0; i < EventReminder.values.length; i++) {
      await cancelNotification('${eventId}_$i');
    }
  }
}
