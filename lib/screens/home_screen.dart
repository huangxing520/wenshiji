import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:wenshiji/common/http.dart';
import 'package:wenshiji/common/logger.dart';
import 'package:wenshiji/common/notification_service.dart';
import 'package:wenshiji/common/permission.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/constants/config_constant.dart';
import 'package:wenshiji/providers/event.dart';
import '../common/preferences.dart';
import '../models/event.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;
  bool _showContextMenu = false;
  String? _selectedEventId;
  final GlobalKey _listViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    preferences.saveInitState(true);
    //_loadWeatherData();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventProvider);
    final filteredEvents = ref.watch(filteredEventsProvider(filterType: FilterType.active));
    AppLogger().info('filteredEvents: $filteredEvents');
    final stats = ref.watch(statsProvider);
    final currentCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopNav(),
                _buildTabBar(currentCategory),
                Expanded(
                  child: eventsAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4A853),
                      ),
                    ),
                    error: (error, stackTrace) =>
                        Center(child: Text('加载失败: $error')),
                    data: (_) => _buildContent(filteredEvents, stats),
                  ),
                ),
              ],
            ),
          ),
          _buildFAB(),
          _buildContextMenu(),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 30)),
      builder: (context, snapshot) {
        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: const Color(0xFFFAF7F0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ConfigConstant.appName,
                style: TextStyle(
                  fontFamily: 'ZhiMangXing', // 使用在 yaml 中定义的名称
                  fontSize: 30,
                  color: Color(0xFFD4AF37), // 设置字体颜色
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 28,
                      color: Color(0xFF8B7648),
                    ),
                    onPressed: () async {
                      await NotificationService().showInstantNotification(
                        title: "即时提醒",
                        body: "这是一条立即弹出的通知",
                        payload: "test_payload", // 点击通知携带的参数
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(EventCategory currentCategory) {
    final List<(EventCategory, String, IconData)> categories = [
      (EventCategory.all, '全部', (Icons.view_list_rounded)),
      (EventCategory.birthday, '生日', (Icons.cake_rounded)),
      (EventCategory.task, '事项', (Icons.push_pin_rounded)),
      (EventCategory.dailySignIn, '正计时', Icons.trending_up_rounded),
      (EventCategory.star, '星标', Icons.star_rounded),
      (EventCategory.holiday, '节日', Icons.celebration_rounded),
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFFAF7F0),
      child: ListView.builder(
        key: _listViewKey,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final (category, label, icon) = categories[index];
          final isActive = currentCategory == category;
          return CategoryTabItem(
            key: ValueKey('tab_$index'),
            label: label,
            icon: icon,
            isSelected: isActive,
            onTap: () =>
                ref.read(selectedCategoryProvider.notifier).state = category,
            selectedColor: Colors.orange,
            unselectedColor: const Color(0xFF8B8066),
          );
        },
      ),
    );
  }

  Widget _buildContent(List<Event> events, Map<String, int> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 18),
          _buildTodayOverview(stats),
          if (events.isEmpty) _buildEmptyState() else _buildEventList(events),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTodayOverview(Map<String, int> stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatPill(number: stats['today'] ?? 0, label: '今日待提醒'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatPill(number: stats['upcoming'] ?? 0, label: '近3天重点'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatPill(
                number: stats['dailySignIn'] ?? 0,
                label: '进行中正计时',
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
      ],
    );
  }

  Widget _buildEventList(List<Event> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentCategory = ref.watch(selectedCategoryProvider);
    final season = Utils.getSeason(today);
    final seasonColors = switch (season) {
      Season.spring => ConfigConstant.springColor,
      Season.summer => ConfigConstant.summerColor,
      Season.autumn => ConfigConstant.autumnColor,
      Season.winter => ConfigConstant.winterColor,
      _ => ConfigConstant.defaultColor,
    };
    return CardSpring(
      trigger: currentCategory,
      child: Column(
        children: events.map((event) {
          if (event.isPinned) {
            return _PinnedCard(
              event: event,
              onLongPress: () => _showContextMenuFor(event.id),
              seasonColors: seasonColors,
            );
          } else {
            return _EventCard(
              event: event,
              today: today,
              onLongPress: () => _showContextMenuFor(event.id),
              onQuickCheckin: () => _quickCheckin(event.id),
            );
          }
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D4A0),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.notifications_none,
              size: 36,
              color: const Color(0xFFD4A853),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无提醒事件',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF383428),
              fontFamily: 'KaiTi',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '点击下方按钮，添加你的第一个重要时刻',
            style: TextStyle(fontSize: 14, color: const Color(0xFF8B8066)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('/add-event'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A853),
              foregroundColor: const Color(0xFF383428),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              '快速添加事件',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Positioned(
      right: 20,
      bottom: 10,
      child: GestureDetector(
        onTap: () => context.push('/add-event'),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFD4A853),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4A853).withValues(alpha: 0.45),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(Icons.add, size: 28, color: const Color(0xFF383428)),
        ),
      ),
    );
  }

  Widget _buildContextMenu() {
    if (!_showContextMenu) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => setState(() {
        _showContextMenu = false;
        _selectedEventId = null;
      }),
      child: Container(
        color: const Color(0xFF383428).withValues(alpha: 0.4),
        child: Center(
          child: Container(
            width: 272,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 48,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ContextMenuItem(
                  icon: Icons.push_pin,
                  label: '置顶 / 取消置顶',
                  onTap: () {
                    if (_selectedEventId != null) {
                      ref
                          .read(eventProvider.notifier)
                          .togglePin(_selectedEventId!);
                      _showToast('操作成功');
                    }
                    setState(() => _showContextMenu = false);
                  },
                ),
                _ContextMenuItem(
                  icon: Icons.star,
                  label: '星标 / 取消星标',
                  onTap: () {
                    if (_selectedEventId != null) {
                      ref
                          .read(eventProvider.notifier)
                          .toggleStar(_selectedEventId!);
                      _showToast('操作成功');
                    }
                    setState(() => _showContextMenu = false);
                  },
                ),
                _ContextMenuItem(
                  icon: Icons.edit,
                  label: '编辑',
                  onTap: () {
                    _showToast('编辑功能开发中');
                    setState(() => _showContextMenu = false);
                  },
                ),
                _ContextMenuItem(
                  icon: Icons.archive,
                  label: '归档',
                  onTap: () {
                    if (_selectedEventId != null) {
                      ref
                          .read(eventProvider.notifier)
                          .deleteEvent(_selectedEventId!);
                      _showToast('已归档');
                    }
                    setState(() => _showContextMenu = false);
                  },
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: const Color(0xFFE8E4DC),
                ),
                _ContextMenuItem(
                  icon: Icons.delete,
                  label: '删除',
                  isDanger: true,
                  onTap: () {
                    if (_selectedEventId != null) {
                      ref
                          .read(eventProvider.notifier)
                          .deleteEvent(_selectedEventId!);
                      _showToast('已删除');
                    }
                    setState(() => _showContextMenu = false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenuFor(String eventId) {
    setState(() {
      _showContextMenu = true;
      _selectedEventId = eventId;
    });
  }

  void _quickCheckin(String eventId) {
    ref.read(eventProvider.notifier).quickCheckin(eventId);
    _showToast('✓ 打卡成功！');
  }

  // void _openAddModal() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => const AddEventScreen()),
  //   );
  // }

  void _showToast(String message) {
    Utils().showToast(message, null);
  }
}

class _StatPill extends StatelessWidget {
  final int number;
  final String label;

  const _StatPill({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E4DC)),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: number),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF8B6F3A),
                  fontFamily: 'KaiTi',
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8B8066),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedCard extends StatefulWidget {
  final Event event;
  final VoidCallback onLongPress;
  final List<Color> seasonColors;

  const _PinnedCard({
    required this.event,
    required this.onLongPress,
    required this.seasonColors,
  });

  @override
  State<_PinnedCard> createState() => _PinnedCardState();
}

class _PinnedCardState extends State<_PinnedCard>
    with TickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toLocal();

    final days = widget.event.nextEffectiveTime.difference(today).inDays;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            //padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.seasonColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4A853).withValues(alpha: 0.35),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                _PinnedParticles(controller: _particleController),
                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(90),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: -60,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '置顶',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.event.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF302D26),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${widget.event.nextEffectiveTime.month}月${widget.event.nextEffectiveTime.day}日 · ${_getTypeLabel(widget.event.type)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF302D26).withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: days),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.1, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutBack,
                            builder: (context, animValue, child) {
                              return Transform.translate(
                                offset: Offset(0, 10 * (1 - animValue)),
                                child: Transform.scale(
                                  scale: 0.5 + (0.5 * animValue),
                                  child: Opacity(
                                    opacity: animValue.clamp(0.0, 1.0),
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF302D26),
                                    fontFamily: 'KaiTi',
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '天',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(
                                      0xFF302D26,
                                    ).withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getTypeLabel(widget.event.type),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF302D26),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(EventType type) {
    switch (type) {
      case EventType.birthday:
        return '🎂 生日';
      case EventType.task:
        return '📌 事项';
      case EventType.dailySignIn:
        return '📈 连签计时';
      case EventType.holiday:
        return '🎉 节日';
    }
  }
}

class _PinnedParticles extends StatefulWidget {
  final AnimationController controller;

  const _PinnedParticles({required this.controller});

  @override
  State<_PinnedParticles> createState() => _PinnedParticlesState();
}

class _PinnedParticlesState extends State<_PinnedParticles> {
  final List<_ParticleData> _particles = [];

  @override
  void initState() {
    super.initState();
    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < 8; i++) {
      _particles.add(
        _ParticleData(
          left: 10 + (i * 10.0) + (i % 2 == 0 ? 5 : 0),
          size: 4 + (i % 3) * 2.0,
          delay: i * 0.3,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                progress: widget.controller.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ParticleData {
  final double left;
  final double size;
  final double delay;

  _ParticleData({required this.left, required this.size, required this.delay});
}

class _ParticlePainter extends CustomPainter {
  final List<_ParticleData> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final adjustedProgress = (progress + particle.delay) % 1.0;
      final y = size.height * (1 - adjustedProgress * 0.8);
      final opacity = adjustedProgress < 0.1
          ? adjustedProgress * 10
          : adjustedProgress > 0.9
          ? (1 - adjustedProgress) * 10
          : 1.0;
      final scale = 1.0 - (adjustedProgress * 0.8);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5 * opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width * (particle.left / 100), y),
        particle.size * scale,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final DateTime today;
  final VoidCallback onLongPress;
  final VoidCallback onQuickCheckin;

  const _EventCard({
    required this.event,
    required this.today,
    required this.onLongPress,
    required this.onQuickCheckin,
  });

  @override
  Widget build(BuildContext context) {
    final days = Utils().getRemainingTime(event.nextEffectiveTime);

    final isToday = event.type != EventType.task && days == 0;
    final daysText = isToday
        ? '今天'
        : (event.type == EventType.dailySignIn
              ? days.toString()
              : days.toString());
    final daysLabel = isToday ? '' : '天';

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E4DC)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getTypeColor(event.type),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            if (event.type != EventType.dailySignIn)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getPriorityColor(event.priority),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: _getPriorityColor(
                        event.priority,
                      ).withValues(alpha: 0.35),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event.isStarred ? '⭐ ' : ''}${event.name}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF383428),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.type == EventType.dailySignIn
                        ? '开始于 ${event.date.month}月${event.date.day}日'
                        : '${event.nextEffectiveTime.month}月${event.nextEffectiveTime.day}日',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8B8066),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8D4A0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getTypeLabel(event.type),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B6F3A),
                          ),
                        ),
                      ),
                      if (event.type == EventType.dailySignIn)
                        GestureDetector(
                          onTap: Utils().hasToday(event.checkinTimes)
                              ? null
                              : onQuickCheckin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Utils().hasToday(event.checkinTimes)
                                  ? const Color(0xFFE8F5E8)
                                  : const Color(0xFFFFF3E8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Utils().hasToday(event.checkinTimes)
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFFF9800),
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  Utils().hasToday(event.checkinTimes)
                                      ? (Utils().isMissed(
                                              event.checkinTimes,
                                              event.checkinStreakCount,
                                              event.date,
                                            )
                                            ? '打卡${event.checkinTimes.length}天'
                                            : '连续打卡${event.checkinTimes.length}天')
                                      : '今日未打卡',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Utils().hasToday(event.checkinTimes)
                                        ? const Color(0xFF5A8A4A)
                                        : const Color(0xFFFF9800),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              children: [
                Text(
                  daysText,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: event.type == EventType.dailySignIn
                        ? const Color(0xFF5A8A4A)
                        : const Color(0xFF8B6F3A),
                    fontFamily: 'KaiTi',
                  ),
                ),
                if (daysLabel.isNotEmpty)
                  Text(
                    daysLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8B8066),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(EventType type) {
    switch (type) {
      case EventType.birthday:
        return const Color(0xFFFF6B6B);
      case EventType.task:
        return const Color(0xFF8B6F3A);
      case EventType.dailySignIn:
        return const Color(0xFF4CAF50);
      case EventType.holiday:
        return const Color(0xFF9C27B0);
    }
  }

  Color _getPriorityColor(EventPriority priority) {
    switch (priority) {
      case EventPriority.high:
        return const Color(0xFFFF6B6B);
      case EventPriority.mid:
        return const Color(0xFFD4A853);
      case EventPriority.low:
        return const Color(0xFF4CAF50);
      case EventPriority.special:
        return const Color(0xFF9C27B0);
    }
  }

  String _getTypeLabel(EventType type) {
    switch (type) {
      case EventType.birthday:
        return '🎂 生日';
      case EventType.task:
        return '📌 事项';
      case EventType.dailySignIn:
        return '📈 连签计时';
      case EventType.holiday:
        return '🎉 节日';
    }
  }
}

class _ContextMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final VoidCallback onTap;

  const _ContextMenuItem({
    required this.icon,
    required this.label,
    this.isDanger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDanger
                  ? const Color(0xFFFF6B6B)
                  : const Color(0xFF8B8066),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDanger
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF383428),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 整体卡片入场动画（整个组件一次动画，无逐个）
class CardSpring extends StatefulWidget {
  final Widget child;
  final dynamic trigger;
  const CardSpring({super.key, required this.child, required this.trigger});

  @override
  State<CardSpring> createState() => _CardSpringState();
}

class _CardSpringState extends State<CardSpring>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 动画时长 500ms
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // 弹性曲线（和你 CSS 完全一致）
    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.34, 1.56, 0.64, 1.0),
    );
    // 直接启动，无延迟、无逐个
    _playAnimation();
  }

  void _playAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _controller.reset(); // 重置到初始状态
          _controller.forward(); // 重新播放
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CardSpring oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _controller.reset(); // 重置到初始状态
      _controller.forward(); // 重新播放
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _animation.value)),
            child: Transform.scale(
              scale: 0.95 + 0.05 * _animation.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

// 单个分类标签选项
class CategoryTabItem extends StatelessWidget {
  // 标签文字
  final String label;
  // 标签图标（支持系统Icon、自定义图片）
  final IconData icon;
  // 是否选中
  final bool isSelected;
  // 点击回调
  final VoidCallback onTap;
  // 文字大小（可选）
  final double fontSize;
  // 内边距（控制选项大小）
  final EdgeInsetsGeometry padding;
  final Color selectedColor;
  final Color unselectedColor;
  const CategoryTabItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    this.fontSize = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // AnimatedContainer 自动实现状态切换的平滑动画
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // 切换动画时长
        curve: Curves.easeOut,
        padding: padding,
        margin: const EdgeInsets.only(right: 14, top: 4),
        decoration: BoxDecoration(
          // 背景色：选中时白色，未选中时透明（和整体背景融合）
          color: Colors.white,
          // 胶囊圆角（根据内边距调整，实现椭圆效果）
          borderRadius: BorderRadius.circular(32),
          // 选中时的柔和外发光（匹配你截图里的暖黄高亮）
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFE8B2).withOpacity(0.6), // 暖黄色发光
                    blurRadius: 16, // 模糊半径，控制发光柔和度
                    spreadRadius: 2, // 扩散半径，控制发光范围
                    offset: const Offset(0, 2), // 轻微向下偏移，更自然
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // 自适应宽度，不占多余空间
          children: [
            // 图标
            Icon(icon, color: isSelected ? selectedColor : unselectedColor),
            const SizedBox(width: 8), // 图标和文字的间距
            // 标签文字
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                // 选中时加粗
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                // 颜色：选中时橙色，未选中时深棕色
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
