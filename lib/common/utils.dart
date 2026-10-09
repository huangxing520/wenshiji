import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:lunar/lunar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/common/notification_service.dart';
import 'package:wenshiji/constants/config_constant.dart';
import 'package:wenshiji/database/wenshiji_database.dart';
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
        AppLogger().info("文件夹删除成功：$folderPath");
      } else {
        AppLogger().debug("文件夹不存在，跳过删除：$folderPath");
      }
    } catch (e) {
      AppLogger().error("删除文件夹失败：$e");
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
      // 农历节日按「农历月/日」换算当年公历（如 2026 春节=2/17、中秋=9/25），
      // 并标记 isLunar 使周年前滚继续按农历计算。
      Event(
        id: '10',
        name: '春节',
        date: _lunarHoliday(now.year, 1, 1),
        nextEffectiveTime: _lunarHoliday(now.year, 1, 1),
        type: EventType.holiday,
        priority: EventPriority.special,
        isPinned: true,
        isStarred: true,
        isLunar: true,
        description: '农历新年',
        tags: ['春节'],
      ),
      Event(
        id: '11',
        name: '中秋节',
        date: _lunarHoliday(now.year, 8, 15),
        nextEffectiveTime: _lunarHoliday(now.year, 8, 15),
        type: EventType.holiday,
        priority: EventPriority.special,
        isStarred: true,
        isLunar: true,
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

/// 样本数据专用：把农历节日（如正月初一 / 八月十五）换算为公历日期。
/// 若该节日在今年已过，则取明年的日期，保证样本始终是「未来」的节日。
static DateTime _lunarHoliday(int year, int lunarMonth, int lunarDay) {
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  var candidate = _lunarToSolarSafe(year, lunarMonth, lunarDay);
  if (candidate.isBefore(today)) {
    candidate = _lunarToSolarSafe(year + 1, lunarMonth, lunarDay);
  }
  return candidate;
}

/// 忽略年份比较「月-日」：当 [b] 的月日不早于 [a] 时返回 true（含同日）。
  /// 原名 isMonthDayBefore 语义与实现不符（实现为 <=），已更名。
  bool isMonthDayNotAfter(DateTime a, DateTime b) {
    if (a.month != b.month) return a.month < b.month;
    return a.day <= b.day;
  }

  /// 按重复规则计算事件在 [from] 当天或之后的「下次生效时间」。
  ///
  /// 这是唯一的推进入口：加载 / 保存 / 后台任务三处都必须经它，
  /// 否则 `nextEffectiveTime` 会停留在创建日，事件过完当天即从首页消失。
  /// 两端均归一到零点，避免时分秒导致的天数漂移。
  /// 农历事件（[Event.isLunar]）的周年按农历月/日换算到当年公历。
  static DateTime nextEffectiveOf(Event e, DateTime from) {
    final fromDay = DateTime(from.year, from.month, from.day);
    final base = e.date;
    switch (e.repeatRule) {
      case RepeatRule.none:
        // 一次性事件：保持原值（可能是过去时间，交给「已过期」逻辑展示）。
        return DateTime(base.year, base.month, base.day);
      case RepeatRule.daily:
        return fromDay;
      case RepeatRule.weekly:
        // 对齐到 base 的星期几；若已过则 +7 天。
        final delta = (base.weekday - fromDay.weekday) % 7;
        return fromDay.add(Duration(days: delta));
      case RepeatRule.monthly:
        return _rollForwardByMonth(base, fromDay);
      case RepeatRule.yearly:
        return _rollForwardByYear(base, fromDay, isLunar: e.isLunar);
    }
  }

  /// 计算 base 的年度纪念日在 from 当天或之后的日期。
  /// 农历事件按「农历月/日」换算当年公历（闰月不存在时回落到同名非闰月）；
  /// 公历事件按公历月/日，2/29 在非闰年回落到 2/28。
  static DateTime _rollForwardByYear(
    DateTime base,
    DateTime fromDay, {
    bool isLunar = false,
  }) {
    if (isLunar) {
      final lunar = _lunarOf(base);
      final lunarMonth = lunar.month; // 负数为闰月
      final lunarDay = lunar.day;
      var candidate = _lunarToSolarSafe(fromDay.year, lunarMonth, lunarDay);
      if (candidate.isBefore(fromDay)) {
        candidate = _lunarToSolarSafe(
          fromDay.year + 1,
          lunarMonth,
          lunarDay,
        );
      }
      return candidate;
    }
    var candidate = _safeDate(fromDay.year, base.month, base.day);
    if (candidate.isBefore(fromDay)) {
      candidate = _safeDate(fromDay.year + 1, base.month, base.day);
    }
    return candidate;
  }

  /// 公历日 → 农历 (月, 日)。月为负数表示闰月。
  static ({int year, int month, int day}) _lunarOf(DateTime solar) {
    final lunar = Lunar.fromDate(DateTime(solar.year, solar.month, solar.day));
    return (year: lunar.getYear(), month: lunar.getMonth(), day: lunar.getDay());
  }

  /// 农历 (年, 月, 日) → 公历 [DateTime]。
  /// [lunarMonth] 为负数表示闰月。目标年若无该闰月，回落到同名非闰月；
  /// 若该农历月天数不足（如小月无三十），回落到当月最后一天。
  static DateTime _lunarToSolarSafe(int lunarYear, int lunarMonth, int lunarDay) {
    var month = lunarMonth;
    if (month < 0) {
      // 目标年不存在该闰月时，用同名非闰月代替（避免 lunar 抛错）。
      final leapMonth = LunarYear.fromYear(lunarYear).getLeapMonth();
      if (leapMonth != -month) {
        month = -month;
      }
    }
    // 该农历月的天数，用于把「三十」回落到「廿九」等。
    final lunarYearObj = LunarYear.fromYear(lunarYear);
    final monthObj = lunarYearObj
        .getMonths()
        .where((m) => m.getYear() == lunarYear && m.getMonth() == month);
    final maxDay = monthObj.isNotEmpty
        ? monthObj.first.getDayCount()
        : 30;
    final day = lunarDay > maxDay ? maxDay : lunarDay;
    final solar = Lunar.fromYmd(lunarYear, month, day).getSolar();
    return DateTime(solar.getYear(), solar.getMonth(), solar.getDay());
  }

  /// 农历 → 公历（界面选择用）。[month] 为负数表示闰月。
  /// 目标年无该闰月或该月天数不足时自动回落（见 [_lunarToSolarSafe]）。
  static DateTime lunarToSolar({
    required int year,
    required int month,
    required int day,
  }) {
    return _lunarToSolarSafe(year, month, day);
  }

  /// 农历日的中文描述，如「正月初一」「闰六月十五」。用于界面展示。
  static String lunarLabel(DateTime solar) {
    final lunar = Lunar.fromDate(DateTime(solar.year, solar.month, solar.day));
    final month = lunar.getMonth();
    final leap = month < 0 ? '闰' : '';
    final monthName = '${LunarUtil.MONTH[month.abs()]}月';
    final dayName = LunarUtil.DAY[lunar.getDay()];
    return '$leap$monthName$dayName';
  }

  /// 计算 base 的「每 N 月」在 from 当天或之后的对应日。
  /// 处理 31 号在小月的情形：回落到该月最后一天。
  static DateTime _rollForwardByMonth(DateTime base, DateTime fromDay) {
    var candidate = _safeDate(fromDay.year, fromDay.month, base.day);
    if (candidate.isBefore(fromDay)) {
      final nextMonth = fromDay.month + 1;
      final y = nextMonth > 12 ? fromDay.year + 1 : fromDay.year;
      final m = nextMonth > 12 ? 1 : nextMonth;
      candidate = _safeDate(y, m, base.day);
    }
    return candidate;
  }

  /// 构造日期，自动把非法日（如 2/30、4/31）回落到该月最后一天。
  static DateTime _safeDate(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }

  Future<String> getDailyNotificationContent() async {
    // 后台 isolate 无 ProviderScope，直接打开 AppDatabase 读取事件。
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final db = AppDatabase();
    try {
      final events = await db.eventDao.getAllEvents();
      // 在内存中按规则前滚（不依赖库中已回填的值，防止升级后未打开过 App 就跑后台任务），
      // 并归一到零点按「天差」比较，避免时分秒把当天到期事件排除在外。
      final withNext = events
          .where((e) => !e.isArchived)
          .map(
            (e) => (
              event: e,
              next: Utils.nextEffectiveOf(e, today),
            ),
          )
          .where((pair) => !pair.next.isBefore(today))
          .toList()
        ..sort((a, b) => a.next.compareTo(b.next));

      final body = withNext.take(5).map((pair) {
        final days = pair.next.difference(today).inDays;
        if (days == 0) {
          return '${pair.event.name}今日到期';
        }
        return '${pair.event.name}还有$days天';
      }).toList().join('。');

      final suffix = withNext.length > 5 ? '。另有 ${withNext.length - 5} 项' : '';
      return body.isNotEmpty ? '$body$suffix' : '今天没有待办事项哦～';
    } finally {
      await db.close();
    }
  }

  Future<int?> getOutsideTime() async {
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final preferences = await SharedPreferences.getInstance();
    final configString = preferences.getString(ConfigConstant.configKey);
    if (configString == null) return null;
    final config = AppConfig.fromJson(jsonDecode(configString));
    // 不打完整的 config：其中包含用户生日等个人数据。
    AppLogger().debug('config loaded: digestOn=${config.notificationDigestOn}');
    if (!config.notificationDigestOn) {
      return null;
    }
    int outsideTime = config.notificationDigestTime == 'morning' ? 8 : 19;
    if (config.notificationDndOn) {
      // notificationDndDays 下标 0=周日..6=周六，而 DateTime.weekday 为 1=周一..7=周日，
      // 故用 %7 归一（周日 7→0），避免周日越界 RangeError。
      if (config.notificationDndDays[tomorrow.weekday % 7]) {
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

  /// 每日提醒任务的唯一名（register / cancel / 查询共用）。
  static const dailyReminderUniqueName = 'daily-reminder';
  static const _dailyReminderTaskName = 'daily-reminder-task';

  /// 注册每日提醒周期任务。幂等：使用 `keep` 策略，已存在时不做任何改动，
  /// 因而不会重置 24h 计时、也不会影响 App 内其它 WorkManager 任务。
  /// 返回是否注册成功，供调用方决定是否落 isSettingWorkManager 标记。
  Future<bool> registerDailyReminderTask() async {
    try {
      await Workmanager().registerPeriodicTask(
        dailyReminderUniqueName,
        _dailyReminderTaskName,
        frequency: const Duration(hours: 24),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
      AppLogger().info('注册每日提醒任务成功');
      return true;
    } catch (e, s) {
      AppLogger().error('注册每日提醒任务失败', error: e, stack: s);
      return false;
    }
  }

  /// 精确取消每日提醒任务（只取消本任务，不动其它任务），
  /// 并清掉已排期但尚未弹出的聚合推送通知。
  Future<void> cancelDailyReminderTask() async {
    try {
      await Workmanager().cancelByUniqueName(dailyReminderUniqueName);
      await NotificationService().cancelNotification(
        NotificationService.dailyDigestKey,
      );
      AppLogger().info('已取消每日提醒任务');
    } catch (e, s) {
      AppLogger().error('取消每日提醒任务失败', error: e, stack: s);
    }
  }
}
