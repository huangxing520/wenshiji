import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with TickerProviderStateMixin {
  static const Color bg = Color(0xFFF8F7F2);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color fg = Color(0xFF3C3428);
  static const Color muted = Color(0xFF8B8066);
  static const Color border = Color(0xFFE8E4DC);
  static const Color accent = Color(0xFFF2C94C);
  static const Color accentSoft = Color(0xFFF9F0D7);
  static const Color accentDeep = Color(0xFFD4A853);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color card = Color(0xFFFFFEFA);

  static const Color heat0 = Color(0xFFF0F0F0);
  static const Color heat1 = Color(0xFFE0E0E0);
  static const Color heat2 = Color(0xFFB0B0B0);
  static const Color heat3 = Color(0xFF808080);
  static const Color heat4 = Color(0xFF404040);

  final List<Map<String, dynamic>> allEvents = [
    {'id': 1, 'name': '妈妈生日', 'date': '2025-07-18', 'cat': 'birthday', 'priority': 'high', 'reminders': 2},
    {'id': 2, 'name': '项目一期交付', 'date': '2025-07-15', 'cat': 'task', 'priority': 'high', 'reminders': 3},
    {'id': 3, 'name': '中秋节', 'date': '2025-09-06', 'cat': 'holiday', 'priority': 'mid', 'reminders': 1},
    {'id': 4, 'name': '小李生日', 'date': '2025-07-22', 'cat': 'birthday', 'priority': 'mid', 'reminders': 2},
    {'id': 5, 'name': '健身卡续费', 'date': '2025-07-20', 'cat': 'task', 'priority': 'low', 'reminders': 1},
    {'id': 6, 'name': '国庆节', 'date': '2025-10-01', 'cat': 'holiday', 'priority': 'mid', 'reminders': 1},
    {'id': 7, 'name': '老王生日', 'date': '2025-07-15', 'cat': 'birthday', 'priority': 'mid', 'reminders': 2},
    {'id': 8, 'name': '结婚纪念日', 'date': '2025-08-12', 'cat': 'task', 'priority': 'high', 'reminders': 3},
    {'id': 9, 'name': '小美生日', 'date': '2025-03-22', 'cat': 'birthday', 'priority': 'mid', 'reminders': 1},
    {'id': 10, 'name': '季度汇报', 'date': '2025-06-30', 'cat': 'task', 'priority': 'high', 'reminders': 2},
    {'id': 11, 'name': '端午节', 'date': '2025-05-31', 'cat': 'holiday', 'priority': 'low', 'reminders': 1},
    {'id': 12, 'name': '老爸生日', 'date': '2025-11-05', 'cat': 'birthday', 'priority': 'high', 'reminders': 2},
    {'id': 13, 'name': '驾照到期', 'date': '2025-04-10', 'cat': 'task', 'priority': 'mid', 'reminders': 3},
    {'id': 14, 'name': '儿童节', 'date': '2025-06-01', 'cat': 'holiday', 'priority': 'low', 'reminders': 0},
    {'id': 15, 'name': '小红生日', 'date': '2025-12-20', 'cat': 'birthday', 'priority': 'mid', 'reminders': 1},
    {'id': 16, 'name': '年会', 'date': '2025-01-18', 'cat': 'task', 'priority': 'high', 'reminders': 2},
    {'id': 17, 'name': '春节', 'date': '2025-01-29', 'cat': 'holiday', 'priority': 'mid', 'reminders': 1},
    {'id': 18, 'name': '小张生日', 'date': '2025-09-14', 'cat': 'birthday', 'priority': 'low', 'reminders': 1},
  ];

  String currentRange = 'all';
  String currentView = 'month';
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

  @override
  void initState() {
    super.initState();
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

  List<Map<String, dynamic>> getFilteredEvents() {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month - 1;
    final d = now.day;

    switch (currentRange) {
      case 'year':
        return allEvents.where((e) => DateTime.parse(e['date']).year == y).toList();
      case 'quarter':
        final qStart = DateTime(y, (m ~/ 3) * 3, 1);
        final qEnd = DateTime(y, (m ~/ 3) * 3 + 3, 0);
        return allEvents.where((e) {
          final dt = DateTime.parse(e['date']);
          return dt.isAfter(qStart.subtract(const Duration(days: 1))) &&
              dt.isBefore(qEnd.add(const Duration(days: 1)));
        }).toList();
      case 'month':
        return allEvents.where((e) {
          final dt = DateTime.parse(e['date']);
          return dt.year == y && dt.month == m + 1;
        }).toList();
      case '30d':
        final start = DateTime(y, m + 1, d - 30);
        return allEvents.where((e) => DateTime.parse(e['date']).isAfter(start.subtract(const Duration(days: 1)))).toList();
      default:
        return allEvents;
    }
  }

  Map<String, int> buildDayMap() {
    final map = <String, int>{};
    getFilteredEvents().forEach((e) {
      final key = e['date'];
      map[key] = (map[key] ?? 0) + 1;
    });
    return map;
  }

  Map<String, dynamic> calculateStats() {
    final filtered = getFilteredEvents();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final in7 = today.add(const Duration(days: 7));

    final total = filtered.length;
    final pending = filtered.where((e) => DateTime.parse(e['date']).isAfter(today.subtract(const Duration(days: 1)))).length;
    final soon = filtered.where((e) {
      final dt = DateTime.parse(e['date']);
      return dt.isAfter(today.subtract(const Duration(days: 1))) &&
          dt.isBefore(in7.add(const Duration(days: 1)));
    }).length;
    final done = total - pending;
    final monthDone = filtered.where((e) {
      final dt = DateTime.parse(e['date']);
      return dt.isBefore(today) && dt.month == now.month;
    }).length;
    final birthdays = filtered.where((e) => e['cat'] == 'birthday').length;
    final bdayLeft = filtered.where((e) => e['cat'] == 'birthday' &&
        DateTime.parse(e['date']).isAfter(today.subtract(const Duration(days: 1)))).length;

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
    final birth = DateTime.parse(birthDate);
    final now = DateTime.now();
    final death = DateTime(birth.year + lifeExpect, birth.month, birth.day);

    final livedMs = now.difference(birth).inMilliseconds;
    final totalMs = death.difference(birth).inMilliseconds;
    final remainMs = totalMs - livedMs;
    final livedDays = livedMs ~/ (1000 * 60 * 60 * 24);
    final remainDays = max(0, remainMs ~/ (1000 * 60 * 60 * 24));
    final pct = min(100.0, max(0.0, (livedMs / totalMs) * 100));

    final yearEnd = DateTime(now.year, 12, 31);
    final yearLeft = max(0, (yearEnd.difference(now).inDays).ceil());
    final age = now.year - birth.year;

    return {
      'pct': pct,
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
    final stats = calculateStats();
    final isEmpty = stats['total'] == 0;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildStatusBar(),
                _buildTopNav(),
                _buildTimeFilter(),
                Expanded(
                  child: _buildContent(isEmpty, stats),
                ),
              ],
            ),
          ),
          if (_showToastFlag) _buildToast(),
          if (_selectedDateEvents != null) _buildDateModal(),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      color: surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 30)),
            builder: (context, snapshot) {
              return Text(
                DateFormat('HH:mm').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              );
            },
          ),
          const Row(
            children: [
              Icon(Icons.signal_cellular_alt, size: 16, color: fg),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 16, color: fg),
            ],
          ),
        ],
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
          GestureDetector(
            onTap: () => _showToastMessage('返回首页'),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: accentDeep),
            ),
          ),
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
          GestureDetector(
            onTap: () => _showToastMessage('数据导出中…'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent, width: 1.5),
              ),
              child: const Text(
                '导出数据',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: accentDeep,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter() {
    final ranges = [
      ('all', '全部时间'),
      ('year', '本年度'),
      ('quarter', '本季度'),
      ('month', '本月'),
      ('30d', '近30天'),
    ];

    return Container(
      color: surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  range.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? const Color(0xFF3C3428) : muted,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContent(bool isEmpty, Map<String, dynamic> stats) {
    return isEmpty ? _buildEmptyState() : _buildStatsContent(stats);
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
            child: const Icon(Icons.notifications_none, size: 48, color: accent),
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
            style: TextStyle(
              fontSize: 14,
              color: muted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => _showToastMessage('跳转新增事件'),
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
                  color: Color(0xFF3C3428),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContent(Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _buildStatsGrid(stats),
          const SizedBox(height: 22),
          _buildHeatmapSection(),
          const SizedBox(height: 14),
          _buildLifeSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildStatCard(
          icon: '📊',
          number: stats['total'],
          label: '全部事件',
          subLabel: '含私密事件 ${stats['isPrivate']} 项',
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
          label: '高频生日数',
          subLabel: '本年度待过 ${stats['bdayLeft']} 人',
          bgColor: const Color(0xFFFFEBEE),
        ),
      ],
    );
  }

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
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 16),
                ),
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
              style: const TextStyle(
                fontSize: 11,
                color: muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 12),
        _buildHeatmapCard(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CustomPaint(
                painter: _GridIconPainter(),
              ),
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
              _buildViewToggleBtn('年度', 'year'),
              _buildViewToggleBtn('月度', 'month'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggleBtn(String text, String view) {
    final isActive = currentView == view;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentView = view;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? accent : card,
          borderRadius: view == 'year'
              ? const BorderRadius.horizontal(left: Radius.circular(8))
              : const BorderRadius.horizontal(right: Radius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF3C3428) : muted,
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmapCard() {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(16),
      child: currentView == 'year' ? _buildYearView() : _buildMonthView(),
    );
  }

  Widget _buildYearView() {
    final dayMap = buildDayMap();
    final y = DateTime.now().year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthLabels(),
        const SizedBox(height: 6),
        _buildYearHeatmapBody(y, dayMap),
        const SizedBox(height: 12),
        _buildHeatmapLegend(),
      ],
    );
  }

  Widget _buildMonthLabels() {
    final months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
    return Row(
      children: months.map((m) {
        return Expanded(
          child: Text(
            m,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYearHeatmapBody(int year, Map<String, int> dayMap) {
    final jan1 = DateTime(year, 1, 1);
    var startOffset = jan1.weekday;
    if (startOffset == 7) startOffset = 0;

    final dec31 = DateTime(year, 12, 31);
    var current = DateTime(year, 1, 1);
    current = current.subtract(Duration(days: (startOffset + 6) % 7));

    final weeks = <Widget>[];

    while (current.isBefore(dec31.add(const Duration(days: 1))) || current.weekday != 1) {
      final week = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final isCurrentYear = current.year == year;
        final key = DateFormat('yyyy-MM-dd').format(current);
        final count = dayMap[key] ?? 0;
        final color = getHeatColor(count);

        week.add(
          GestureDetector(
            onTap: isCurrentYear ? () => _openDateModal(key) : null,
            child: Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.symmetric(vertical: 1.5),
              decoration: BoxDecoration(
                color: isCurrentYear ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
        current = current.add(const Duration(days: 1));
      }
      weeks.add(
        Column(children: week),
      );
      if (current.isAfter(dec31) && current.weekday == 1) break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDayLabels(),
        const SizedBox(width: 4),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: weeks.map((w) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: w,
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayLabels() {
    const labels = ['', '一', '', '三', '', '五', ''];
    return Column(
      children: labels.map((l) => Container(
        width: 20,
        height: 17,
        alignment: Alignment.centerRight,
        child: Text(
          l,
          style: const TextStyle(
            fontSize: 9,
            color: muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildHeatmapLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('少', style: TextStyle(fontSize: 11, color: muted)),
        SizedBox(width: 6),
        _LegendBlock(color: heat0),
        _LegendBlock(color: heat1),
        _LegendBlock(color: heat2),
        _LegendBlock(color: heat3),
        _LegendBlock(color: heat4),
        SizedBox(width: 6),
        Text('多', style: TextStyle(fontSize: 11, color: muted)),
      ],
    );
  }

  Widget _buildMonthView() {
    final dayMap = buildDayMap();
    final today = DateTime.now();

    return Column(
      children: [
        _buildMonthNav(),
        const SizedBox(height: 12),
        _buildMonthGrid(dayMap, today),
      ],
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

  Widget _buildMonthGrid(Map<String, int> dayMap, DateTime today) {
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
      final key = DateFormat('yyyy-MM-dd').format(DateTime(viewYear, viewMonth + 1, d));
      final count = dayMap[key] ?? 0;
      final color = getHeatColor(count);
      final isToday = today.year == viewYear &&
          today.month == viewMonth + 1 &&
          today.day == d;

      cells.add(
        GestureDetector(
          onTap: () => _openDateModal(key),
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: muted,
            ),
          ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Text(
                    birthDate,
                    style: const TextStyle(
                      fontSize: 13,
                      color: fg,
                    ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border, width: 1.5),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: lifeExpect.toString()),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    color: fg,
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed >= 1 && parsed <= 150) {
                      setState(() {
                        lifeExpect = parsed;
                      });
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
              opacity: _toastOpacityAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF3C3428).withValues(alpha: 0.92),
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

  void _openDateModal(String dateStr) {
    final dayEvents = allEvents.where((e) => e['date'] == dateStr).toList();
    setState(() {
      _selectedDateEvents = {
        'date': dateStr,
        'events': dayEvents,
      };
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
    final events = _selectedDateEvents!['events'] as List;
    final dt = DateTime.parse(dateStr);
    const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    final weekday = weekdays[dt.weekday - 1];

    final catColors = <String, Color>{
      'birthday': danger,
      'task': accentDeep,
      'holiday': success,
    };
    final catLabels = <String, String>{
      'birthday': '🎂 生日',
      'task': '📌 事项',
      'holiday': '🎉 节日',
    };

    return GestureDetector(
      onTap: _closeDateModal,
      child: Container(
        color: const Color(0xFF3C3428).withValues(alpha: 0.45),
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
                        child: const Icon(Icons.close, color: accentDeep, size: 16),
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
                    style: const TextStyle(
                      fontSize: 13,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (events.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          '当日暂无事件记录',
                          style: TextStyle(
                            fontSize: 14,
                            color: muted,
                          ),
                        ),
                      ),
                    )
                  else
                    ...events.map((e) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: border),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: catColors[e['cat']] ?? muted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                e['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: accentSoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                catLabels[e['cat']] ?? e['cat'],
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
      ..color = _StatsScreenState.accentDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rectSize = size.width * 0.35;
    final gap = size.width * 0.1;

    canvas.drawRect(Rect.fromLTWH(0, 0, rectSize, rectSize), paint);
    canvas.drawRect(Rect.fromLTWH(rectSize + gap, 0, rectSize, rectSize), paint);
    canvas.drawRect(Rect.fromLTWH(0, rectSize + gap, rectSize, rectSize), paint);
    canvas.drawRect(Rect.fromLTWH(rectSize + gap, rectSize + gap, rectSize, rectSize), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
