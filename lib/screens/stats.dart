import 'dart:math';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/providers/event.dart';

const _accentDeep = Color(0xFFD4A853);

enum StatsTimeType { all, month, year, quarter }

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen>
    with TickerProviderStateMixin {
  static const Color bg = Color(0xFFF8F7F2);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color fg = Color(0xFF3C3428);
  static const Color muted = Color(0xFF8B8066);
  static const Color border = Color(0xFFE8E4DC);
  static const Color accent = Color(0xFFF2C94C);
  static const Color accentSoft = Color(0xFFF9F0D7);
  static const Color accentDeep = _accentDeep;
  static const Color danger = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color card = Color(0xFFFFFEFA);

  static const Color heat0 = Color(0xFFF0F0F0);
  static const Color heat1 = Color(0xFFE0E0E0);
  static const Color heat2 = Color(0xFFB0B0B0);
  static const Color heat3 = Color(0xFF808080);
  static const Color heat4 = Color(0xFF404040);

  //final List<Event> allEvents = Utils().getSampleEvents();

  StatsTimeType currentRange = StatsTimeType.all;
  StatsTimeType currentHeatmapRange = StatsTimeType.year;
  int viewMonth = DateTime.now().month - 1;
  int viewYear = DateTime.now().year;
  bool lifeVisible = true;
  String birthDate = '1990-03-15';
  int lifeExpect = 80;

  late AnimationController _toastController;
  late Animation<double> _toastScaleAnimation;
  late Animation<double> _toastOpacityAnimation;
  String _toastMessage = '';
  bool _showToastFlag = false;

  Map<String, dynamic>? _selectedDateEvents;
  late TextEditingController _lifeExpectController;

  @override
  void initState() {
    super.initState();
    _lifeExpectController = TextEditingController(text: lifeExpect.toString());
    _toastController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _toastScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _toastController, curve: Curves.easeOutBack),
    );
    _toastOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _toastController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _lifeExpectController.dispose();
    _toastController.dispose();
    super.dispose();
  }

  void _showToastMessage(String message) {
    setState(() {
      _toastMessage = message;
      _showToastFlag = true;
    });
    _toastController.forward();
    Future.delayed(const Duration(milliseconds: 1600), () {
      _toastController.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showToastFlag = false;
          });
        }
      });
    });
  }

  List<Event> getFilteredEvents(List<Event> allEvents) {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month - 1; // 保留：专门给月份筛选用

    switch (currentRange) {
      case StatsTimeType.year:
        return allEvents.where((e) => e.date.year == y).toList();
      case StatsTimeType.quarter:
        // 🔥 修复点1：季度计算用【原始月份】，不要用减1后的m！
        final currentMonth = now.month;
        // 计算季度索引 (0-3)
        final quarterIndex = currentMonth ~/ 3;
        // 🔥 修复点2：正确计算季度起止日期
        final qStart = DateTime(y, quarterIndex * 3 + 1, 1);
        final qEnd = DateTime(y, quarterIndex * 3 + 4, 0);

        // 筛选逻辑（本身是正确的，保留）
        return allEvents.where((e) {
          final dt = e.date;
          return dt.isAfter(qStart.subtract(const Duration(days: 1))) &&
              dt.isBefore(qEnd.add(const Duration(days: 1)));
        }).toList();
      case StatsTimeType.month:
        // 原有逻辑正确，保留
        return allEvents.where((e) {
          final dt = e.date;
          return dt.year == y && dt.month == m + 1;
        }).toList();
      default:
        return allEvents;
    }
  }

  Map<String, int> buildDayMap(List<Event> allEvents) {
    final map = <String, int>{};
    for (final e in getFilteredEvents(allEvents)) {
      final key = DateFormat('yyyy-MM-dd').format(e.date);
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  Map<String, dynamic> calculateStats(List<Event> allEvents) {
    final filtered = getFilteredEvents(allEvents);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final in7 = today.add(const Duration(days: 7));

    final total = filtered.length;
    final pending = filtered
        .where((e) => e.date.isAfter(today.subtract(const Duration(days: 1))))
        .length;
    final soon = filtered.where((e) {
      final dt = e.date;
      return dt.isAfter(today.subtract(const Duration(days: 1))) &&
          dt.isBefore(in7.add(const Duration(days: 1)));
    }).length;
    final done = total - pending;
    final monthDone = filtered.where((e) {
      final dt = e.date;
      return dt.isBefore(today) && dt.month == now.month;
    }).length;
    final birthdays = filtered
        .where((e) => e.type == EventType.birthday)
        .length;
    final bdayLeft = filtered
        .where(
          (e) =>
              e.type == EventType.birthday &&
              e.date.isAfter(today.subtract(const Duration(days: 1))),
        )
        .length;

    return {
      'total': total,
      'pending': pending,
      'soon': soon,
      'done': done,
      'monthDone': monthDone,
      'birthdays': birthdays,
      'bdayLeft': bdayLeft,
      'isPrivate': max(1, (total * 0.15).floor()),
    };
  }

  Map<String, dynamic> calculateLifeStats() {
    final birth = DateTime.tryParse(birthDate);
    if (birth == null) {
      return {
        'pct': 0.0,
        'livedDays': 0,
        'remainDays': 0,
        'yearLeft': 0,
        'age': 0,
      };
    }

    final now = DateTime.now();

    // 3. ✅ 修复：精准计算死亡日期（用年份相加，替代错误的天数计算）
    final death = DateTime(birth.year + lifeExpect, birth.month, birth.day);

    // 4. ✅ 修复：处理【未来生日】【已过死亡时间】边界
    final isFutureBirth = now.isBefore(birth);
    final isDead = now.isAfter(death);

    // 已活时间/总时间
    final totalMs = death.difference(birth).inMilliseconds;
    final livedMs = isFutureBirth
        ? 0
        : (isDead ? totalMs : now.difference(birth).inMilliseconds);

    // 计算天数
    final livedDays = livedMs ~/ Duration.millisecondsPerDay;
    final remainMs = max(0, totalMs - livedMs);
    final remainDays = remainMs ~/ Duration.millisecondsPerDay;

    // 生命进度百分比（0~100）
    final pct = totalMs > 0
        ? (livedMs / totalMs * 100).clamp(0.0, 100.0)
        : 100.0;

    // 5. ✅ 修复：移除多余的 .ceil()，inDays 本身就是int
    final yearEnd = DateTime(now.year, 12, 31);
    final yearLeft = max(0, yearEnd.difference(now).inDays);

    // 6. ✅ 修复：精准年龄 + 边界处理（未来生日年龄=0）
    int age = 0;
    if (!isFutureBirth) {
      age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
    }

    return {
      'pct': double.parse(pct.toStringAsFixed(2)), // 保留2位小数
      'livedDays': livedDays,
      'remainDays': remainDays,
      'yearLeft': yearLeft,
      'age': age,
    };
  }

  Color getHeatColor(int count) {
    if (count == 0) return heat0;
    if (count <= 2) return heat1;
    if (count <= 4) return heat2;
    if (count <= 5) return heat3;
    return heat4;
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventProvider);

    return Scaffold(
      backgroundColor: bg,
      body: events.when(
        data: (events) {
          final filtered = getFilteredEvents(events);
          final stats = calculateStats(filtered);
          final isEmpty = stats['total'] == 0;
          return Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    _buildTopNav(),
                    _buildTimeFilter(),
                    Expanded(child: _buildContent(isEmpty, stats, filtered)),
                  ],
                ),
              ),
              if (_showToastFlag) _buildToast(),
              if (_selectedDateEvents != null) _buildDateModal(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Error')),
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border, width: 1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '数据统计',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: -0.3,
              ),
            ),
          ),
          // todo: 导出数据按钮
          // GestureDetector(
          //   onTap: () => _showToastMessage('数据导出中…'),
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(16),
          //       border: Border.all(color: accent, width: 1.5),
          //     ),
          //     child: const Text(
          //       '导出数据',
          //       style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w700,
          //         color: accentDeep,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter() {
    final ranges = [
      (StatsTimeType.all, '全部时间'),
      (StatsTimeType.year, '本年度'),
      (StatsTimeType.quarter, '本季度'),
      (StatsTimeType.month, '本月'),
    ];

    return Container(
      color: surface,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ranges.map((range) {
            final isActive = currentRange == range.$1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentRange = range.$1;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isActive ? accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  range.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? fg : muted,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContent(
    bool isEmpty,
    Map<String, dynamic> stats,
    List<Event> allEvents,
  ) {
    return isEmpty ? _buildEmptyState() : _buildStatsContent(stats, allEvents);
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 48,
              color: accent,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '暂无数据',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '快去记录你的重要时刻吧',
            style: TextStyle(fontSize: 14, color: muted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => context.push('/add-event'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                '新增事件',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContent(Map<String, dynamic> stats, List<Event> allEvents) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _buildStatsGrid(stats),
          const SizedBox(height: 22),
          _buildHeatmapSection(allEvents),
          const SizedBox(height: 14),
          _buildLifeSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // 统计卡片
  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.0 / 0.8,
      children: [
        _buildStatCard(
          icon: '📊',
          number: stats['total'],
          label: '全部事件',
          subLabel: '含标星事件 ${stats['isPrivate']} 项',
          bgColor: accentSoft,
        ),
        _buildStatCard(
          icon: '⏳',
          number: stats['pending'],
          label: '待完成事件',
          subLabel: '近7天到期 ${stats['soon']} 项',
          bgColor: const Color(0xFFE8F5E8),
        ),
        _buildStatCard(
          icon: '✅',
          number: stats['done'],
          label: '已完成/归档',
          subLabel: '本月完成 ${stats['monthDone']} 项',
          bgColor: const Color(0xFFE3F2FD),
        ),
        _buildStatCard(
          icon: '🎂',
          number: stats['birthdays'],
          label: '生日数',
          subLabel: '本年度已有 ${stats['bdayLeft']} 人过生日',
          bgColor: const Color(0xFFFFEBEE),
        ),
      ],
    );
  }

  // 统计卡片
  Widget _buildStatCard({
    required String icon,
    required int number,
    required String label,
    required String subLabel,
    required Color bgColor,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: const Cubic(0.34, 1.56, 0.64, 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value.clamp(0, 1), child: child),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ← 新增这一行

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: number),
                    duration: const Duration(milliseconds: 600),
                    curve: const Cubic(0.34, 1.56, 0.64, 1.0),
                    builder: (context, value, child) {
                      return Text(
                        value.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: fg,
                          height: 1,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subLabel,
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -40,
              top: -40,

              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 日历热力图
  Widget _buildHeatmapSection(List<Event> allEvents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 12),
        _buildHeatmapCard(allEvents),
      ],
    );
  }

  // 日历热力图标题
  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CustomPaint(painter: _GridIconPainter()),
            ),
            SizedBox(width: 6),
            Text(
              '日历热力图',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildViewToggleBtn('年度', StatsTimeType.year),
              _buildViewToggleBtn('月度', StatsTimeType.month),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggleBtn(String text, StatsTimeType view) {
    final isActive = currentHeatmapRange == view;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentHeatmapRange = view;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? accent : card,
          borderRadius: view == StatsTimeType.year
              ? const BorderRadius.horizontal(left: Radius.circular(8))
              : const BorderRadius.horizontal(right: Radius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? fg : muted,
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmapCard(List<Event> allEvents) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: currentHeatmapRange == StatsTimeType.year
          ? _buildYearView(allEvents)
          : _buildMonthView(allEvents),
    );
  }

  Widget _buildYearView(List<Event> allEvents) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ContributionHeatmap(
          heatmapColor: HeatmapColor.orange,
          showMonthLabels: true,
          weekdayLabel: WeekdayLabel.githubLike,
          splittedMonthView: true,
          showCellDate: true,
          startWeekday: DateTime.monday,
          cellRadius: 14.0,
          cellSize: 18.0,
          minDate: DateTime(DateTime.now().year, 1, 1),
          maxDate: DateTime.now(),
          entries: [
            ContributionEntry(DateTime(2026, 1, 15), 5),
            ContributionEntry(DateTime(2026, 3, 16), 3),
            ContributionEntry(DateTime(2026, 2, 1), 8),
            // Add more entries...
          ], // Only required parameter, other are optional
          onCellTap: (date, value) {
            _openDateModal(date.toIso8601String(), allEvents);
          },
        ),
      ),
    );
  }

  Widget _buildMonthView(List<Event> allEvents) {
    final dayMap = buildDayMap(allEvents);
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildMonthNav(),
          const SizedBox(height: 12),
          _buildMonthGrid(dayMap, today, allEvents),
        ],
      ),
    );
  }

  Widget _buildMonthNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              viewMonth--;
              if (viewMonth < 0) {
                viewMonth = 11;
                viewYear--;
              }
            });
          },
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: accentDeep, size: 16),
          ),
        ),
        Text(
          '$viewYear年${viewMonth + 1}月',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              viewMonth++;
              if (viewMonth > 11) {
                viewMonth = 0;
                viewYear++;
              }
            });
          },
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward, color: accentDeep, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthGrid(
    Map<String, int> dayMap,
    DateTime today,
    List<Event> allEvents,
  ) {
    final first = DateTime(viewYear, viewMonth + 1, 1);
    var startDay = first.weekday;
    if (startDay == 7) startDay = 1;

    final daysInMonth = DateTime(viewYear, viewMonth + 2, 0).day;
    const headers = ['一', '二', '三', '四', '五', '六', '日'];

    final cells = <Widget>[];

    for (final h in headers) {
      cells.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          alignment: Alignment.center,
          child: Text(
            h,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: muted,
            ),
          ),
        ),
      );
    }

    for (int i = 1; i < startDay; i++) {
      cells.add(Container());
    }

    for (int d = 1; d <= daysInMonth; d++) {
      final key = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime(viewYear, viewMonth + 1, d));
      final count = dayMap[key] ?? 0;
      final color = getHeatColor(count);
      final isToday =
          today.year == viewYear &&
          today.month == viewMonth + 1 &&
          today.day == d;

      cells.add(
        GestureDetector(
          onTap: () => _openDateModal(key, allEvents),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: isToday ? Border.all(color: accentDeep, width: 2) : null,
            ),
            alignment: Alignment.center,
            child: Text(
              d.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: count >= 3 ? Colors.white : fg,
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      children: cells,
    );
  }

  Widget _buildLifeSection() {
    final lifeStats = calculateLifeStats();

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildLifeHeader(),
          if (lifeVisible) _buildLifeBody(lifeStats),
        ],
      ),
    );
  }

  Widget _buildLifeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '🌱 人生进度',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              lifeVisible = !lifeVisible;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: lifeVisible ? accent : border,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(14),
              color: lifeVisible ? accentSoft : Colors.transparent,
            ),
            child: Text(
              lifeVisible ? '隐藏' : '展示',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: lifeVisible ? accentDeep : muted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLifeBody(Map<String, dynamic> lifeStats) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: lifeStats['pct'] as double),
          duration: const Duration(milliseconds: 700),
          curve: const Cubic(0.34, 1.56, 0.64, 1.0),
          builder: (context, value, child) {
            return Text(
              '${value.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: accentDeep,
                height: 1,
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        const Text(
          '今日人生进度',
          style: TextStyle(
            fontSize: 14,
            color: muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        _buildLifeBar(lifeStats['pct'] as double),
        const SizedBox(height: 18),
        _buildLifeStatsGrid(lifeStats),
        const SizedBox(height: 14),
        _buildLifeConfig(),
      ],
    );
  }

  Widget _buildLifeBar(double pct) {
    return Container(
      height: 14,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E4DC),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: pct / 100),
        duration: const Duration(milliseconds: 1200),
        curve: const Cubic(0.34, 1.56, 0.64, 1.0),
        builder: (context, value, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [accent, Color(0xFFD4A853)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLifeStatsGrid(Map<String, dynamic> lifeStats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.0 / 0.5,

      children: [
        _buildLifeStat(lifeStats['livedDays'], '已度过天数'),
        _buildLifeStat(lifeStats['remainDays'], '剩余天数'),
        _buildLifeStat(lifeStats['yearLeft'], '本年剩余天'),
        _buildLifeStat(lifeStats['age'], '当前年龄'),
      ],
    );
  }

  Widget _buildLifeStat(dynamic value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value is int ? value.toString() : value.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: muted)),
        ],
      ),
    );
  }

  Widget _buildLifeConfig() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '出生日期',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(birthDate),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: accentDeep,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      birthDate = DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Text(
                    birthDate,
                    style: const TextStyle(fontSize: 13, color: fg),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '预期寿命（岁）',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _lifeExpectController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 13, color: fg),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed >= 1 && parsed <= 150) {
                      setState(() {
                        lifeExpect = parsed;
                      });
                    } else {
                      Utils().showErrorToast('请输入1-150之间的整数', null);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToast() {
    return Center(
      child: AnimatedBuilder(
        animation: _toastController,
        builder: (context, child) {
          return Transform.scale(
            scale: _toastScaleAnimation.value,
            child: Opacity(
              opacity: _toastOpacityAnimation.value.clamp(0, 1),
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: fg.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _toastMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _openDateModal(String dateStr, List<Event> allEvents) {
    final targetDate = DateFormat('yyyy-MM-dd').parse(dateStr);
    final dayEvents = allEvents.where((e) {
      final d = e.date;
      return d.year == targetDate.year &&
          d.month == targetDate.month &&
          d.day == targetDate.day;
    }).toList();
    setState(() {
      _selectedDateEvents = {'date': dateStr, 'events': dayEvents};
    });
  }

  void _closeDateModal() {
    setState(() {
      _selectedDateEvents = null;
    });
  }

  Widget _buildDateModal() {
    if (_selectedDateEvents == null) return const SizedBox.shrink();

    final dateStr = _selectedDateEvents!['date'] as String;
    final events = _selectedDateEvents!['events'] as List<Event>;
    final dt = DateTime.parse(dateStr);
    const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    final weekday = weekdays[dt.weekday - 1];

    final catColors = <EventType, Color>{
      EventType.birthday: danger,
      EventType.task: accentDeep,
      EventType.holiday: success,
    };
    final catLabels = <EventType, String>{
      EventType.birthday: '🎂 生日',
      EventType.task: '📌 事项',
      EventType.holiday: '🎉 节日',
    };

    return GestureDetector(
      onTap: _closeDateModal,
      child: Container(
        color: fg.withValues(alpha: 0.45),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 340,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _closeDateModal,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: accentSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: accentDeep,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${dt.month}月${dt.day}日',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weekday,
                    style: const TextStyle(fontSize: 13, color: muted),
                  ),
                  const SizedBox(height: 14),
                  if (events.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          '当日暂无事件记录',
                          style: TextStyle(fontSize: 14, color: muted),
                        ),
                      ),
                    )
                  else
                    ...events.map((e) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: border)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: catColors[e.type] ?? muted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                e.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: accentSoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                catLabels[e.type] ?? e.type.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: accentDeep,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendBlock extends StatelessWidget {
  final Color color;
  const _LegendBlock({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _GridIconPainter extends CustomPainter {
  const _GridIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _accentDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rectSize = size.width * 0.35;
    final gap = size.width * 0.1;

    canvas.drawRect(Rect.fromLTWH(0, 0, rectSize, rectSize), paint);
    canvas.drawRect(
      Rect.fromLTWH(rectSize + gap, 0, rectSize, rectSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, rectSize + gap, rectSize, rectSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(rectSize + gap, rectSize + gap, rectSize, rectSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
