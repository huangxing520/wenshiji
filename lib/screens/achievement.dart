import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/widget/navigationBar.dart';

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

class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen>
    with TickerProviderStateMixin {
  bool _toastVisible = false;
  String _toastMessage = '';
  bool _showCelebration = false;
  String _selectedCat = 'quit';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int _nextId = 100;
  Event? _selectedEvent;
  // final Map<String, CategoryMeta> catMeta = {
  //   'quit': CategoryMeta(
  //     icon: '🚭',
  //     label: '戒烟',
  //     cls: 'cu-quit',
  //     checkin: '今日已坚持',
  //   ),
  //   'discipline': CategoryMeta(
  //     icon: '💪',
  //     label: '自律',
  //     cls: 'cu-discipline',
  //     checkin: '今日已打卡',
  //   ),
  //   'study': CategoryMeta(
  //     icon: '📖',
  //     label: '学习',
  //     cls: 'cu-study',
  //     checkin: '今日已学习',
  //   ),
  //   'love': CategoryMeta(
  //     icon: '💕',
  //     label: '恋爱',
  //     cls: 'cu-love',
  //     checkin: '今日在一起',
  //   ),
  // };

  final List<MilestoneDef> milestoneDefs = [
    MilestoneDef(days: 7, label: '7天', icon: '🌱', tier: 'bronze'),
    MilestoneDef(days: 30, label: '30天', icon: '🌿', tier: 'silver'),
    MilestoneDef(days: 100, label: '100天', icon: '🌳', tier: 'gold'),
    MilestoneDef(days: 365, label: '365天', icon: '💎', tier: 'diamond'),
  ];

  // final List<Event> events = [
  //   Event(
  //     id: 1,
  //     name: '戒烟',
  //     cat: 'quit',
  //     startDate: '2025-03-08',
  //     checkedToday: true,
  //   ),
  //   Event(
  //     id: 2,
  //     name: '每日冥想',
  //     cat: 'discipline',
  //     startDate: '2025-06-15',
  //     checkedToday: false,
  //   ),
  //   Event(
  //     id: 3,
  //     name: '和小雨在一起',
  //     cat: 'love',
  //     startDate: '2024-11-20',
  //     checkedToday: true,
  //   ),
  //   Event(
  //     id: 4,
  //     name: '日语N2备考',
  //     cat: 'study',
  //     startDate: '2025-05-01',
  //     checkedToday: false,
  //   ),
  // ];

  MilestoneDef? _celebrationMilestone;

  int daysSince(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(date).inDays;
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

  void checkin(Event event) async {
    await ref.read(eventProvider.notifier).quickCheckin(event.id);
    final hitMilestone = milestoneDefs.firstWhereOrNull(
      (m) => m.days == event.checkinStreakCount,
    );
    if (hitMilestone != null) {
      showCelebration(event, hitMilestone);
    } else {
      showToast('✓ 今日已签到');
    }
  }

  void showCelebration(Event ev, MilestoneDef milestone) {
    setState(() {
      _celebrationMilestone = milestone;
      _showCelebration = true;
      _selectedEvent = ev;
    });
  }

  void closeCelebration() {
    setState(() {
      _showCelebration = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventProvider);
    return events.when(
      data: (data) {
        return Scaffold(
          backgroundColor: _kBg,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    commonNavigationBar(
                      title: '正计时打卡成就',
                      surfaceColor: _kSurface,
                      borderColor: _kAccentSoft,
                      fgColor: _kFg,
                      icon: Icons.arrow_back_ios_new,
                    ),
                    //_buildTopNav(),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              _buildSummaryBanner(data),
                              _buildSectionHead('正计时进行中', '🌱'),
                              ..._buildEventList(),
                              _buildSectionHead('成就徽章墙', '🏆'),
                            ]),
                          ),
                          _buildBadgeGrid(data),
                          SliverToBoxAdapter(child: const SizedBox(height: 40)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_showCelebration) _buildCelebrationOverlay(),
                if (_toastVisible) _buildToast(),
              ],
            ),
          ),
        );
      },
      error: (e, stackTrace) {
        return const Center(child: Text('加载失败'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
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
            onTap: () => context.pop(),
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
          const SizedBox(width: 16),
          Text(
            '正计时成就打卡',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _kFg,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner(List<Event> events) {
    final totalBadges = events.fold(
      0,
      (sum, ev) => sum + getEarnedMilestones(ev.checkinStreakCount).length,
    );
    final longest = events.isEmpty
        ? 0
        : events
              .where((e) => e.type == EventType.dailySignIn)
              .map((e) => e.checkinStreakCount)
              .reduce(max);

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
                Expanded(child: _buildSummaryStat(events.length, '进行中')),
                Container(
                  width: 1,
                  height: 24,
                  color: const Color(0xFF3D2E1E).withValues(alpha: 0.1),
                ),
                Expanded(child: _buildSummaryStat(totalBadges, '已获徽章')),
                Container(
                  width: 1,
                  height: 24,
                  color: const Color(0xFF3D2E1E).withValues(alpha: 0.1),
                ),
                Expanded(child: _buildSummaryStat(longest, '最长天数')),
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
              child: Text(icon, style: const TextStyle(fontSize: 14)),
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
    final events = ref.watch(eventProvider);
    return events.when(
      data: (events) {
        final eventList = events
            .where((ev) => ev.type == EventType.dailySignIn && !ev.isArchived)
            .toList();
        return List.generate(eventList.length, (index) {
          final ev = eventList[index];
          final lapsedTime = daysSince(ev.date);
          final alldays = ev.nextEffectiveTime.difference(ev.date).inDays;
          final progressPct = (lapsedTime / alldays * 100).clamp(0.0, 100.0);
          final accentColors = [
            _kDanger,
            _kAccent,
            _kSuccess,
            const Color(0xFFFF69B4),
          ];
          final accentColor = accentColors[index % 4];
          final checkedToday = Utils().hasToday(ev.checkinTimes);
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
                        const SizedBox(width: 6),
                        Text(
                          ev.name,
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
                      onTap: () => checkin(ev),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: checkedToday ? _kAccentSoft : _kAccent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          checkedToday ? '✓ 今日已打卡' : '打卡',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: checkedToday
                                ? _kAccentDeep
                                : const Color(0xFF3D2E1E),
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
                      ev.checkinStreakCount.toString(),
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
                // const SizedBox(height: 4),
                // Text(
                //   ev.name,
                //   style: TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.w600,
                //     color: _kFg,
                //   ),
                // ),
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
                    // const SizedBox(width: 8),
                    // Row(
                    //   children: milestoneDefs.map((m) {
                    //     final isEarned = days >= m.days;
                    //     return Container(
                    //       margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    //       width: 6,
                    //       height: 6,
                    //       decoration: BoxDecoration(
                    //         color: isEarned ? _kAccent : _kBorder,
                    //         shape: BoxShape.circle,
                    //         boxShadow: isEarned
                    //             ? [
                    //                 BoxShadow(
                    //                   color: _kAccent.withValues(alpha: 0.4),
                    //                   blurRadius: 4,
                    //                 ),
                    //               ]
                    //             : [],
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                    const SizedBox(width: 8),
                    Text(
                      '${alldays.toString()}天',
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
        });
      },
      error: (error, stackTrace) => [Container(child: Text('加载失败'))],
      loading: () => const [CircularProgressIndicator()],
    );
  }

  Widget _buildBadgeGrid(List<Event> events) {
    final allBadges = <Map<String, dynamic>>[];
    for (final ev in events.where((e) => e.type == EventType.dailySignIn)) {
      final days = ev.checkinStreakCount;
      for (final m in milestoneDefs) {
        final earned = days >= m.days;
        if (earned) {
          allBadges.add({'event': ev.name, 'milestone': m, 'earned': earned});
        }
      }
    }

    allBadges.sort((a, b) {
      if (a['earned'] != b['earned']) {
        return a['earned'] ? -1 : 1;
      }
      return (a['milestone'] as MilestoneDef).days.compareTo(
        (b['milestone'] as MilestoneDef).days,
      );
    });
    print(allBadges);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
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
                    showToast('${badge['event']} · ${milestone.label} 已达成');
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: earned ? _kAccentSoft : _kCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: earned ? _kAccent : _kBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
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
                  const SizedBox(height: 4),
                  Text(
                    milestone.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: earned ? _kFg : _kMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    earned ? badge['event'] : '未解锁',
                    style: TextStyle(fontSize: 10, color: _kMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }, childCount: allBadges.length),
      ),
    );
  }

  Widget _buildCelebrationOverlay() {
    final event = _selectedEvent;
    if (event == null) {
      return const SizedBox.shrink();
    }
    final milestone = _celebrationMilestone!;
    final days = event.checkinStreakCount;
    final descs = {
      'bronze': '万事开头难，你已经迈出了最坚定的第一步。坚持下去，你会感谢现在的自己！',
      'silver': '一个月的坚持不是每个人都能做到的，你做到了！这份毅力正在变成习惯。',
      'gold': '一百天！这已经不是坚持，而是生活的一部分了。你值得这枚闪亮的徽章！',
      'diamond': '整整一年！你用365天证明了自己的决心。这份成就，无人可以替代。',
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
                          color: _getBadgeColor(
                            milestone.tier,
                          ).withValues(alpha: 0.35),
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
                    style: TextStyle(fontSize: 14, color: _kMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${event.name}已达 $days 天',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _kAccentDeep,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    descs[milestone.tier] ?? '恭喜你达成了这个里程碑！',
                    style: TextStyle(fontSize: 13, color: _kMuted, height: 1.5),
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

  Widget _buildToast() {
    return Center(
      child: AnimatedOpacity(
        opacity: _toastVisible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedScale(
          scale: _toastVisible ? 1 : 0.9,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
