import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wenshiji/common/debouncer.dart';
import 'package:wenshiji/common/http.dart';
import 'package:wenshiji/common/logger.dart';
import 'package:wenshiji/common/permission.dart';
import 'package:wenshiji/common/preferences.dart';
import 'package:wenshiji/constants/config_constant.dart';
import 'package:wenshiji/models/appconfig.dart';
import 'package:wenshiji/models/event.dart';
import 'package:workmanager/workmanager.dart';

class Utils {
  static Utils? _instance;
  Utils._internal();
  factory Utils() {
    _instance ??= Utils._internal();
    return _instance!;
  }
  static Season getSeason(DateTime time) {
    switch (time.month) {
      case 3 || 4 || 5:
        return Season.spring;
      case 6 || 7 || 8:
        return Season.summer;
      case 9 || 10 || 11:
        return Season.autumn;
      case 12 || 1 || 2:
        return Season.winter;
      default:
        return Season.spring;
    }
  }

  void showToast(String? label, String? message) {
    HyperSnackbar.show(
      title: label,
      message: message,
      icon: Icon(Icons.notification_important, color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 132, 129, 129),
      enterAnimationType: HyperSnackAnimationType.scale,
      enterCurve: Curves.elasticOut,
      enterAnimationDuration: const Duration(milliseconds: 500),
      displayDuration: Duration(milliseconds: 800),

      maxWidth: 300,
    );
  }

  void showErrorToast(String? label, String? message) {
    HyperSnackbar.show(
      title: label,
      message: message,
      backgroundColor: const Color.fromARGB(255, 224, 7, 7),
      icon: Icon(Icons.error, color: Colors.white),
      enterAnimationType: HyperSnackAnimationType.scale,
      enterCurve: Curves.easeOut,
      enterAnimationDuration: const Duration(milliseconds: 500),
      displayDuration: Duration(milliseconds: 500),

      maxWidth: 300,
    );
  }

  Future<String?> getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;
    return version;
  }

  Future<void> launchInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Utils().showErrorToast('打开失败', '无法打开链接，请检查网络或安装浏览器');
    }
  }

  Future<void> deleteFolder(String folderPath) async {
    try {
      final directory = Directory(folderPath);

      // 先判断文件夹是否存在
      if (await directory.exists()) {
        // recursive: true → 递归删除文件夹内所有文件/子文件夹
        await directory.delete(recursive: true);
        print("文件夹删除成功：$folderPath");
      } else {
        print("文件夹不存在，跳过删除：$folderPath");
      }
    } catch (e) {
      print("删除文件夹失败：$e");
    }
  }

  // 字节(Byte) 转 KB，保留2位小数
  String bytesToKB(int bytes) {
    if (bytes <= 0) return "0 KB";
    double kbSize = bytes / 1024;
    return "${kbSize.toStringAsFixed(2)} KB";
  }

  bool hasToday(List<DateTime> checkinTimes) {
    final today = DateTime.now().toLocal();
    return checkinTimes.contains(DateTime(today.year, today.month, today.day));
  }

  bool isMissed(
    List<DateTime> checkinTimes,
    int checkinStreakCount,
    DateTime createTime,
  ) {
    if (checkinTimes.isEmpty) return true;
    if (!hasToday(checkinTimes)) return true;
    return checkinTimes.last.difference(createTime).inDays !=
        checkinStreakCount - 1;
  }

  int getRemainingTime(DateTime nextCheckinTime) {
    final today = DateTime.now().toLocal();
    final todayZero = DateTime(today.year, today.month, today.day);
    return nextCheckinTime.difference(todayZero).inDays;
  }

  List<Event> getSampleEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      // ========== birthday 生日类型 ==========
      Event(
        id: '1',
        name: '妈妈生日',
        date: today.subtract(const Duration(days: 3)),
        nextEffectiveTime: today.subtract(const Duration(days: 3)),
        type: EventType.birthday,
        priority: EventPriority.high,
        isPinned: true,
        isStarred: true,
        description: '记得准备礼物和蛋糕',
      ),
      Event(
        id: '2',
        name: '爸爸生日',
        date: today.subtract(const Duration(days: 30)),
        nextEffectiveTime: today.add(const Duration(days: 30)),
        type: EventType.birthday,
        priority: EventPriority.mid,
        isStarred: true,
        description: '提前准备礼物',
      ),
      Event(
        id: '3',
        name: '好朋友小明生日',
        date: today.subtract(const Duration(days: 15)),
        nextEffectiveTime: today.add(const Duration(days: 15)),
        type: EventType.birthday,
        priority: EventPriority.low,
      ),

      // ========== task 倒计时任务类型 ==========
      Event(
        id: '4',
        name: '期末考试',
        date: today.subtract(const Duration(days: 20)),
        nextEffectiveTime: today.add(const Duration(days: 20)),
        type: EventType.task,
        priority: EventPriority.high,
        isPinned: true,
        description: '高等数学期末考试',
        repeatRule: RepeatRule.none,
      ),
      Event(
        id: '5',
        name: '项目截止日期',
        date: today.subtract(const Duration(days: 1)),
        nextEffectiveTime: today.add(const Duration(days: 2)),
        type: EventType.task,
        priority: EventPriority.special,
        isStarred: true,
        description: '完成Flutter项目开发',
        repeatRule: RepeatRule.none,
      ),
      Event(
        id: '6',
        name: '已截止',
        date: today.subtract(const Duration(days: 10)),
        nextEffectiveTime: today.subtract(const Duration(days: 3)),
        type: EventType.task,
        priority: EventPriority.high,
        isStarred: true,
        description: '完成Flutter项目开发',
        repeatRule: RepeatRule.none,
      ),
      // ========== dailySignIn 每日签到类型 ==========
      Event(
        id: '7',
        name: '每日背单词',
        date: today.subtract(const Duration(days: 10)),
        nextEffectiveTime: today.add(const Duration(days: 10)),
        repeatRule: RepeatRule.none,
        type: EventType.dailySignIn,
        priority: EventPriority.mid,
        checkinStreakCount: 7,
        checkinTimes: [
          today.subtract(const Duration(days: 10)),
          today.subtract(const Duration(days: 9)),
          today.subtract(const Duration(days: 8)),
          today.subtract(const Duration(days: 6)),
          today.subtract(const Duration(days: 5)),
          today.subtract(const Duration(days: 4)),
          today.subtract(const Duration(days: 2)),
        ],
        description: '每天背50个单词',
      ),
      Event(
        id: '8',
        name: '每日运动',
        date: today.subtract(const Duration(days: 5)),
        nextEffectiveTime: today.add(const Duration(days: 5)),
        repeatRule: RepeatRule.none,
        type: EventType.dailySignIn,
        priority: EventPriority.high,
        checkinStreakCount: 6,
        isStarred: true,
        checkinTimes: [
          today.subtract(const Duration(days: 5)),
          today.subtract(const Duration(days: 4)),
          today.subtract(const Duration(days: 3)),
          today.subtract(const Duration(days: 2)),
          today.subtract(const Duration(days: 1)),
          today,
        ],
        description: '每天运动30分钟',
      ),
      Event(
        id: '9',
        name: '每日阅读',
        date: today.subtract(const Duration(days: 20)),
        nextEffectiveTime: today.subtract(const Duration(days: 3)),
        repeatRule: RepeatRule.none,
        type: EventType.dailySignIn,
        priority: EventPriority.low,
        checkinStreakCount: 12,
        isArchived: true,
        checkinTimes: [
          today.subtract(const Duration(days: 20)),
          today.subtract(const Duration(days: 19)),
          today.subtract(const Duration(days: 18)),
          today.subtract(const Duration(days: 16)),
          today.subtract(const Duration(days: 15)),
          today.subtract(const Duration(days: 14)),
          today.subtract(const Duration(days: 12)),
          today.subtract(const Duration(days: 11)),
          today.subtract(const Duration(days: 10)),
          today.subtract(const Duration(days: 7)),
          today.subtract(const Duration(days: 6)),
          today.subtract(const Duration(days: 5)),
        ],
        description: '每天阅读1小时',
      ),
      Event(
        id: '13',
        name: '每日冥想',
        date: today.subtract(const Duration(days: 35)),
        nextEffectiveTime: today.add(const Duration(days: 5)),
        repeatRule: RepeatRule.none,
        type: EventType.dailySignIn,
        priority: EventPriority.mid,
        checkinStreakCount: 31,
        checkinTimes: List.generate(
          31,
          (index) => today.subtract(Duration(days: 31 - index)),
        ),
        description: '每天冥想15分钟',
      ),
      Event(
        id: '14',
        name: '每日写作',
        date: today.subtract(const Duration(days: 105)),
        nextEffectiveTime: today.add(const Duration(days: 5)),
        repeatRule: RepeatRule.none,
        type: EventType.dailySignIn,
        priority: EventPriority.high,
        checkinStreakCount: 100,
        isStarred: true,
        checkinTimes: List.generate(
          100,
          (index) => today.subtract(Duration(days: 100 - index)),
        ),
        description: '每天写作500字',
      ),
      Event(
        id: '15',
        name: '每日早起',
        date: today.subtract(const Duration(days: 370)),
        nextEffectiveTime: today.add(const Duration(days: 5)),
        repeatRule: RepeatRule.none,
        type: EventType.dailySignIn,
        priority: EventPriority.special,
        checkinStreakCount: 365,
        isStarred: true,
        isPinned: true,
        checkinTimes: List.generate(
          365,
          (index) => today.subtract(Duration(days: 365 - index)),
        ),
        description: '每天6点起床',
      ),

      // ========== holiday 节日类型 ==========
      Event(
        id: '10',
        name: '春节',
        date: DateTime(now.year + 1, 1, 1),
        nextEffectiveTime: DateTime(now.year + 1, 1, 1),
        type: EventType.holiday,
        priority: EventPriority.special,
        isPinned: true,
        isStarred: true,
        description: '农历新年',
        tags: ['春节'],
      ),
      Event(
        id: '11',
        name: '中秋节',
        date: DateTime(now.year, 9, 15),
        nextEffectiveTime: DateTime(now.year, 9, 15),
        type: EventType.holiday,
        priority: EventPriority.special,
        isStarred: true,
        description: '团圆节',
      ),
      Event(
        id: '12',
        name: '国庆节',
        date: DateTime(now.year, 10, 1),
        nextEffectiveTime: DateTime(now.year, 10, 1),
        type: EventType.holiday,
        priority: EventPriority.high,
        description: '祖国生日',
      ),
    ];
  }

  Future<void> _loadWeatherData() async {
    LocationData? location = await permission.getCurrentLocation();
    if (location != null) {
      final lat = location.latitude;
      final lng = location.longitude;
      if (lat != null && lng != null) {
        print('当前位置: $lat, $lng');
        final weather = await HttpUtil().fetchWeather(lat, lng);
      }
    }
  }

  bool isMonthDayBefore(DateTime a, DateTime b) {
    if (a.month != b.month) return a.month < b.month;
    return a.day <= b.day;
  }

  Future<String> getDailyNotificationContent() async {
    // 示例：根据日期返回不同内容
    final now = DateTime.now();
    final events = await preferences.getEvents();
    final filteredEvents =
        events.where((event) => event.nextEffectiveTime.isAfter(now)).toList()
          ..sort((a, b) => a.nextEffectiveTime.compareTo(b.nextEffectiveTime));

    final body = filteredEvents
        .map((e) {
          if (e.nextEffectiveTime.day == now.day + 1) {
            return '${e.name}今日到期，请及时处理';
          } else {
            return '${e.name}还有${e.nextEffectiveTime.difference(now).inDays}天到日期';
          }
        })
        .toList()
        .join('。');
    print(filteredEvents);
    return body.isNotEmpty ? body : '今天没有待办事项哦～';
  }

  Future<int?> getOutsideTime() async {
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final preferences = await SharedPreferences.getInstance();
    final configString = preferences?.getString(ConfigConstant.configKey);
    if (configString == null) return null;
    final config = AppConfig.fromJson(jsonDecode(configString));
    print('config: $config');
    if (!config.notificationDigestOn) {
      return null;
    }
    int outsideTime = config.notificationDigestTime == 'morning' ? 8 : 19;
    if (config.notificationDndOn) {
      if (config.notificationDndDays[tomorrow.weekday]) {
        outsideTime = getRealOutsideTime(
          config.notificationDigestTime == 'morning' ? 8 : 19,
          config.notificationStartHour,
          config.notificationEndHour,
        );
      }
    }
    return outsideTime;
  }

  int getRealOutsideTime(int target, int left, int right) {
    if (left <= right) {
      if (target <= left || target >= right) {
        return target;
      } else {
        return right;
      }
    } else {
      if (target <= left && target >= right) {
        return target;
      } else {
        return right;
      }
    }
  }

  void registerPeriodicTask(Debouncer debouncer) {
    //test();
    debouncer.run(() async {
      await Workmanager().cancelAll(); // 关键：清空所有旧任务

      // await Workmanager().registerOneOffTask(
      //   "test-task-1",
      //   "daily-reminder-task1",
      //   initialDelay: Duration(seconds: 5),
      // );

      try {
        await Workmanager().registerPeriodicTask(
          "daily-reminder", // 唯一任务名
          "daily-reminder-task", // 任务标识（需与 executeTask 匹配）
          frequency: Duration(hours: 24), // 每24小时执行一次
        );
        AppLogger().info('注册每日提醒任务成功');
      } catch (e) {
        AppLogger().error('注册每日提醒任务失败: $e');
      }
    });
  }
}
