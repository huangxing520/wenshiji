import 'dart:math';
import 'package:flutter/material.dart';

const _kBg = Color(0xFFFFFDF7);
const _kSurface = Color(0xFFFFFFFF);
const _kFg = Color(0xFF3D2E1E);
const _kMuted = Color(0xFF9E8E7A);
const _kBorder = Color(0xFFE8DCC8);
const _kAccent = Color(0xFFF5A623);
const _kAccentSoft = Color(0xFFFFF3DC);
const _kAccentDeep = Color(0xFFD48B0A);
const _kDanger = Color(0xFFE25B45);
const _kSuccess = Color(0xFF4CAF7D);
const _kCard = Color(0xFFFFFFFF);

class CategoryMeta {
  final String icon;
  final String label;
  final String cls;
  final String checkin;

  CategoryMeta({
    required this.icon,
    required this.label,
    required this.cls,
    required this.checkin,
  });
}

class MilestoneDef {
  final int days;
  final String label;
  final String icon;
  final String tier;

  MilestoneDef({
    required this.days,
    required this.label,
    required this.icon,
    required this.tier,
  });
}

class Event {
  final int id;
  final String name;
  final String cat;
  final String startDate;
  bool checkedToday;

  Event({
    required this.id,
    required this.name,
    required this.cat,
    required this.startDate,
    this.checkedToday = false,
  });
}

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen>
    with TickerProviderStateMixin {
  bool _toastVisible = false;
  String _toastMessage = '';
  bool _showAddModal = false;
  bool _showCelebration = false;
  String _selectedCat = 'quit';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int _nextId = 100;

  final Map<String, CategoryMeta> catMeta = {
    'quit': CategoryMeta(
      icon: '🚭',
      label: '戒烟',
      cls: 'cu-quit',
      checkin: '今日已坚持',
    ),
    'discipline': CategoryMeta(
      icon: '💪',
      label: '自律',
      cls: 'cu-discipline',
      checkin: '今日已打卡',
    ),
    'study': CategoryMeta(
      icon: '📖',
      label: '学习',
      cls: 'cu-study',
      checkin: '今日已学习',
    ),
    'love': CategoryMeta(
      icon: '💕',
      label: '恋爱',
      cls: 'cu-love',
      checkin: '今日在一起',
    ),
  };

  final List<MilestoneDef> milestoneDefs = [
    MilestoneDef(days: 7, label: '7天', icon: '🌱', tier: 'bronze'),
    MilestoneDef(days: 30, label: '30天', icon: '🌿', tier: 'silver'),
    MilestoneDef(days: 100, label: '100天', icon: '🌳', tier: 'gold'),
    MilestoneDef(days: 365, label: '365天', icon: '💎', tier: 'diamond'),
  ];

  final List<Event> events = [
    Event(id: 1, name: '戒烟', cat: 'quit', startDate: '2025-03-08', checkedToday: true),
    Event(id: 2, name: '每日冥想', cat: 'discipline', startDate: '2025-06-15', checkedToday: false),
    Event(id: 3, name: '和小雨在一起', cat: 'love', startDate: '2024-11-20', checkedToday: true),
    Event(id: 4, name: '日语N2备考', cat: 'study', startDate: '2025-05-01', checkedToday: false),
  ];

  Event? _celebrationEvent;
  MilestoneDef? _celebrationMilestone;

  int daysSince(String dateStr) {
    final start = DateTime.parse('${dateStr}T00:00:00');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(start).inDays;
  }

  MilestoneDef? getNextMilestone(int days) {
    for (final m in milestoneDefs) {
      if (days < m.days) return m;
    }
    return null;
  }

  List<MilestoneDef> getEarnedMilestones(int days) {
    return milestoneDefs.where((m) => days >= m.days).toList();
  }

  void showToast(String msg) {
    setState(() {
      _toastMessage = msg;
      _toastVisible = true;
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          _toastVisible = false;
        });
      }
    });
  }

  void checkin(int id) {
    final ev = events.firstWhere((x) => x.id == id);
    if (ev.checkedToday) return;

    setState(() {
      ev.checkedToday = true;
    });

    final days = daysSince(ev.startDate);
    final meta = catMeta[ev.cat]!;
    final hitMilestone = milestoneDefs.firstWhereOrNull((m) => m.days == days);
    if (hitMilestone != null) {
      showCelebration(ev, hitMilestone);
    } else {
      showToast('✓ ${meta.checkin}');
    }
  }

  void showCelebration(Event ev, MilestoneDef milestone) {
    setState(() {
      _celebrationEvent = ev;
      _celebrationMilestone = milestone;
      _showCelebration = true;
    });
  }

  void closeCelebration() {
    setState(() {
      _showCelebration = false;
    });
  }

  void openAddModal() {
    setState(() {
      _nameController.text = '';
      _dateController.text = DateTime.now().toIso8601String().substring(0, 10);
      _selectedCat = 'quit';
      _showAddModal = true;
    });
  }

  void closeAddModal() {
    setState(() {
      _showAddModal = false;
    });
  }

  void addEvent() {
    final name = _nameController.text.trim();
    final date = _dateController.text;

    if (name.isEmpty) {
      showToast('请输入事件名称');
      return;
    }
    if (date.isEmpty) {
      showToast('请选择开始日期');
      return;
    }

    final newEvent = Event(
      id: _nextId++,
      name: name,
      cat: _selectedCat,
      startDate: date,
      checkedToday: false,
    );

    setState(() {
      events.add(newEvent);
    });

    final days = daysSince(date);
    if (days == 0) {
      newEvent.checkedToday = true;
    }

    closeAddModal();
    showToast('开始记录「$name」');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildStatusBar(),
                _buildTopNav(),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          _buildSummaryBanner(),
                          _buildSectionHead('正计时进行中', '🌱'),
                          ..._buildEventList(),
                          _buildSectionHead('成就徽章墙', '🏆'),
                        ]),
                      ),
                      _buildBadgeGrid(),
                      SliverToBoxAdapter(
                        child: const SizedBox(height: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showCelebration) _buildCelebrationOverlay(),
            if (_showAddModal) _buildAddModal(),
            if (_toastVisible) _buildToast(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      color: _kSurface,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(DateTime.now()),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _kFg,
                ),
              ),
              Row(
                children: [
                  _buildStatusIcon(Icons.signal_wifi_4_bar),
                  const SizedBox(width: 5),
                  _buildStatusIcon(Icons.battery_charging_full),
                ],
              ),
            ],
          ),
          Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildStatusIcon(IconData icon) {
    return Icon(
      icon,
      size: 16,
      color: _kFg,
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 56,
      color: _kSurface,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _kAccentSoft,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 22,
                  color: _kAccentDeep,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '正计时成就打卡',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _kFg,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: openAddModal,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _kAccent,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Color(0xFF3D2E1E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner() {
    final totalBadges = events.fold(
      0,
      (sum, ev) => sum + getEarnedMilestones(daysSince(ev.startDate)).length,
    );
    final longest = events.isEmpty
        ? 0
        : events.map((e) => daysSince(e.startDate)).reduce(max);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kAccent, Color(0xFFE8951A), Color(0xFFD48B0A)],
        ),
        boxShadow: [
          BoxShadow(
            color: _kAccent.withValues(alpha: 0.3),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '🏆 坚持的力量',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3D2E1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF3D2E1E).withValues(alpha: 0.08),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryStat(events.length, '进行中'),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: const Color(0xFF3D2E1E).withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildSummaryStat(totalBadges, '已获徽章'),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: const Color(0xFF3D2E1E).withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _buildSummaryStat(longest, '最长天数'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(int value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3D2E1E),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3D2E1E).withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHead(String title, String icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: icon == '🌱' ? _kAccentSoft : const Color(0xFFFFF0E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _kFg,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEventList() {
    return List.generate(
      events.length,
      (index) {
        final ev = events[index];
        final days = daysSince(ev.startDate);
        final meta = catMeta[ev.cat]!;
        final next = getNextMilestone(days);
        final progressPct = next != null ? (days / next.days * 100).clamp(0.0, 100.0) : 100.0;

        Color accentColor;
        switch (ev.cat) {
          case 'quit':
            accentColor = _kDanger;
            break;
          case 'discipline':
            accentColor = _kAccent;
            break;
          case 'study':
            accentColor = _kSuccess;
            break;
          case 'love':
            accentColor = const Color(0xFFFF69B4);
            break;
          default:
            accentColor = _kAccent;
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _kCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            meta.icon,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        meta.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _kMuted,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => checkin(ev.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: ev.checkedToday ? _kAccentSoft : _kAccent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        ev.checkedToday ? '✓ ${meta.checkin}' : '打卡',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: ev.checkedToday ? _kAccentDeep : const Color(0xFF3D2E1E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    days.toString(),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: _kFg,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '天',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _kMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                ev.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _kFg,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DCC8),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: progressPct / 100,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: milestoneDefs.map((m) {
                      final isEarned = days >= m.days;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isEarned ? _kAccent : _kBorder,
                          shape: BoxShape.circle,
                          boxShadow: isEarned
                              ? [
                                  BoxShadow(
                                    color: _kAccent.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                  ),
                                ]
                              : [],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    next != null ? '→ ${next.label}' : '🏆 全部达成',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgeGrid() {
    final allBadges = <Map<String, dynamic>>[];
    for (final ev in events) {
      final days = daysSince(ev.startDate);
      for (final m in milestoneDefs) {
        final earned = days >= m.days;
        allBadges.add({
          'event': ev.name,
          'cat': ev.cat,
          'milestone': m,
          'earned': earned,
        });
      }
    }

    allBadges.sort((a, b) {
      if (a['earned'] != b['earned']) {
        return a['earned'] ? -1 : 1;
      }
      return (a['milestone'] as MilestoneDef)
          .days
          .compareTo((b['milestone'] as MilestoneDef).days);
    });

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final badge = allBadges[index];
            final earned = badge['earned'] as bool;
            final milestone = badge['milestone'] as MilestoneDef;

            Color? badgeColor;
            if (earned) {
              switch (milestone.tier) {
                case 'bronze':
                  badgeColor = const Color(0xFFCD7F32).withValues(alpha: 0.2);
                  break;
                case 'silver':
                  badgeColor = const Color(0xFFC0C0C0).withValues(alpha: 0.2);
                  break;
                case 'gold':
                  badgeColor = const Color(0xFFFFF3DC);
                  break;
                case 'diamond':
                  badgeColor = const Color(0xFFB9F2FF).withValues(alpha: 0.2);
                  break;
              }
            }

            return InkWell(
              onTap: earned
                  ? () {
                      showToast(
                        '${badge['event']} · ${milestone.label} 已达成',
                      );
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                decoration: BoxDecoration(
                  color: earned ? _kAccentSoft : _kCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: earned ? _kAccent : _kBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: earned ? badgeColor : const Color(0xFFE8DCC8),
                        shape: BoxShape.circle,
                        boxShadow: earned
                            ? [
                                BoxShadow(
                                  color: _kAccent.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          earned ? milestone.icon : '🔒',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      milestone.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: earned ? _kFg : _kMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      earned ? badge['event'] : '未解锁',
                      style: TextStyle(
                        fontSize: 10,
                        color: _kMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: allBadges.length,
        ),
      ),
    );
  }

  Widget _buildCelebrationOverlay() {
    if (_celebrationEvent == null || _celebrationMilestone == null) {
      return const SizedBox.shrink();
    }
    final ev = _celebrationEvent!;
    final milestone = _celebrationMilestone!;
    final days = daysSince(ev.startDate);
    final descs = {
      'bronze':
          '万事开头难，你已经迈出了最坚定的第一步。坚持下去，你会感谢现在的自己！',
      'silver':
          '一个月的坚持不是每个人都能做到的，你做到了！这份毅力正在变成习惯。',
      'gold':
          '一百天！这已经不是坚持，而是生活的一部分了。你值得这枚闪亮的徽章！',
      'diamond':
          '整整一年！你用365天证明了自己的决心。这份成就，无人可以替代。',
    };

    return Stack(
      children: [
        Container(
          color: Colors.black.withValues(alpha: 0.6),
          child: Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getBadgeColor(milestone.tier),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getBadgeColor(milestone.tier).withValues(alpha: 0.35),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        milestone.icon,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '成就解锁！',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _kFg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${milestone.label} 徽章',
                    style: TextStyle(
                      fontSize: 14,
                      color: _kMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${ev.name}已达 $days 天',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _kAccentDeep,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    descs[milestone.tier] ?? '恭喜你达成了这个里程碑！',
                    style: TextStyle(
                      fontSize: 13,
                      color: _kMuted,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: closeCelebration,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _kAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '太棒了！',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3D2E1E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getBadgeColor(String tier) {
    switch (tier) {
      case 'bronze':
        return const Color(0xFFCD7F32).withValues(alpha: 0.2);
      case 'silver':
        return const Color(0xFFC0C0C0).withValues(alpha: 0.2);
      case 'gold':
        return const Color(0xFFFFF3DC);
      case 'diamond':
        return const Color(0xFFB9F2FF).withValues(alpha: 0.2);
      default:
        return _kAccentSoft;
    }
  }

  Widget _buildAddModal() {
    return Stack(
      children: [
        Container(
          color: Colors.black.withValues(alpha: 0.45),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
                decoration: const BoxDecoration(
                  color: _kSurface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _kBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '新增正计时',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _kFg,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildFieldLabel('事件名称'),
                    const SizedBox(height: 6),
                    _buildTextField(_nameController, '例如：戒烟第1天'),
                    const SizedBox(height: 14),
                    _buildFieldLabel('开始日期'),
                    const SizedBox(height: 6),
                    _buildTextField(_dateController, '', type: 'date'),
                    const SizedBox(height: 14),
                    _buildFieldLabel('分类'),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: catMeta.entries.map((entry) {
                        final selected = _selectedCat == entry.key;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCat = entry.key;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? _kAccentSoft : _kCard,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? _kAccent : _kBorder,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(entry.value.icon),
                                const SizedBox(width: 5),
                                Text(
                                  entry.value.label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selected ? _kAccentDeep : _kMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: addEvent,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _kAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            '开始记录',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3D2E1E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _kFg,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String placeholder,
      {String type = 'text'}) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 15,
        color: _kFg,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        filled: true,
        fillColor: _kCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kAccent, width: 1.5),
        ),
      ),
      readOnly: type == 'date',
      onTap: type == 'date'
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null && mounted) {
                controller.text = date.toIso8601String().substring(0, 10);
              }
            }
          : null,
    );
  }

  Widget _buildToast() {
    return Center(
      child: AnimatedOpacity(
        opacity: _toastVisible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedScale(
          scale: _toastVisible ? 1 : 0.9,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: _kFg.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _toastMessage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
