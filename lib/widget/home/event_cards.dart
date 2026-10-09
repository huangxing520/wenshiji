// 首页事件卡片相关组件与工具。
// 从 home_screen.dart 抽离，供置顶卡与普通卡共用。
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/theme/app_colors.dart';

/// 事件类型的中文标签。
String typeLabel(EventType type) {
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

class PinnedCard extends StatefulWidget {
  final Event event;
  final VoidCallback onLongPress;
  final List<Color> seasonColors;
  /// 每日打卡入口。置顶的 dailySignIn 事件此前没有打卡入口，必须先取消置顶才能打卡。
  final VoidCallback? onQuickCheckin;

  const PinnedCard({
    super.key,
    required this.event,
    required this.onLongPress,
    required this.seasonColors,
    this.onQuickCheckin,
  });

  @override
  State<PinnedCard> createState() => PinnedCardState();
}

class PinnedCardState extends State<PinnedCard>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 粒子动画是 60fps 常驻重绘：App 切到后台/未激活时暂停，避免无谓耗电。
    if (!mounted) return;
    if (state == AppLifecycleState.resumed) {
      if (!_particleController.isAnimating) _particleController.repeat();
    } else {
      _particleController.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.primary.withValues(alpha: 0.35),
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
                        '${widget.event.nextEffectiveTime.month}月${widget.event.nextEffectiveTime.day}日 · ${typeLabel(widget.event.type)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF302D26).withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      LiveDays(
                        targetDate: widget.event.nextEffectiveTime,
                        builder: (context, days) =>
                            widget.event.type == EventType.dailySignIn
                            // 打卡类事件显示正计时天数（距开始日），
                            // 避免与普通卡片「距下次生效」口径矛盾。
                            ? _buildPinnedCheckinRow(context)
                            : TweenAnimationBuilder<int>(
                          key: ValueKey<int>(days),
                          // 过期事件 days 为负，若直接作为 tween 终点会反向动画，这里收敛到 0。
                          tween: IntTween(begin: 0, end: days < 0 ? 0 : days),
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
                      typeLabel(widget.event.type),
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


  /// 置顶的连签计时卡：显示已进行天数 + 打卡按钮。
  Widget _buildPinnedCheckinRow(BuildContext context) {
    final event = widget.event;
    final checkedToday = Utils().hasToday(event.checkinTimes);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(event.date.year, event.date.month, event.date.day);
    final elapsed = today.difference(start).inDays;
    final canCheckin = !checkedToday && widget.onQuickCheckin != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${elapsed < 0 ? 0 : elapsed}',
          style: const TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            color: Color(0xFF302D26),
            fontFamily: 'KaiTi',
            height: 1,
          ),
        ),
        const SizedBox(width: 4),
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Text(
            '天',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF302D26),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: canCheckin ? widget.onQuickCheckin : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: checkedToday
                    ? const Color(0xFFE8F5E8)
                    : const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                checkedToday ? '今日已打卡' : '打卡',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: checkedToday
                      ? const Color(0xFF5A8A4A)
                      : AppColors.amberOrange,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LiveDays extends StatefulWidget {
  final DateTime targetDate;
  final Widget Function(BuildContext context, int days) builder;

  const LiveDays({required this.targetDate, required this.builder});

  @override
  State<LiveDays> createState() => LiveDaysState();
}

class LiveDaysState extends State<LiveDays> {
  late int _days;
  StreamSubscription<void>? _sub;

  static int _computeDays(DateTime target) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // target 也必须归一到零点，否则 Duration.inDays 向零截断会出现
    // 「昨天显示今天」或「剩余 -1 天」的偏差。
    final targetDay = DateTime(target.year, target.month, target.day);
    return targetDay.difference(today).inDays;
  }

  @override
  void initState() {
    super.initState();
    _days = _computeDays(widget.targetDate);
    _sub = Stream.periodic(const Duration(seconds: 60)).listen((_) {
      final newDays = _computeDays(widget.targetDate);
      if (mounted && newDays != _days) {
        setState(() => _days = newDays);
      }
    });
  }

  @override
  void didUpdateWidget(covariant LiveDays oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetDate != widget.targetDate) {
      final newDays = _computeDays(widget.targetDate);
      if (newDays != _days) {
        _days = newDays;
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _days);
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

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onLongPress;
  final VoidCallback onQuickCheckin;

  const EventCard({
    super.key,
    required this.event,
    required this.onLongPress,
    required this.onQuickCheckin,
  });

  @override
  Widget build(BuildContext context) {
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
                          typeLabel(event.type),
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
                                        : AppColors.amberOrange,
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
                                        : AppColors.amberOrange,
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
            LiveDays(
              targetDate: event.nextEffectiveTime,
              builder: (context, days) {
                final isExpired = days < 0;
                final isToday = days == 0;
                final daysText = isExpired
                    ? '已过期'
                    : (isToday ? '今天' : days.toString());
                final daysLabel = (isExpired || isToday) ? '' : '天';
                return Column(
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
                );
              },
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
        return AppColors.primary;
      case EventPriority.low:
        return const Color(0xFF4CAF50);
      case EventPriority.special:
        return const Color(0xFF9C27B0);
    }
  }

  String typeLabel(EventType type) {
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

class ContextMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final VoidCallback onTap;

  const ContextMenuItem({
    required this.icon,
    required this.label,
    this.isDanger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  behavior: HitTestBehavior.opaque,
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
  Timer? _playTimer;

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
      if (!mounted) return;
      // 用可取消的 Timer 替代 Future.delayed：否则 dispose 后延迟回调仍会
      // 触碰已释放的 controller，触发 "Ticker used after being disposed"。
      _playTimer?.cancel();
      _playTimer = Timer(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        _controller.reset(); // 重置到初始状态
        _controller.forward(); // 重新播放
      });
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
    _playTimer?.cancel();
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
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // AnimatedContainer 自动实现状态切换的平滑动画
      child: Container(
        //duration: const Duration(milliseconds: 500), // 切换动画时长
        // curve: Curves.easeOut,
        padding: padding,
        margin: const EdgeInsets.only(right: 14, bottom: 12),
        decoration: BoxDecoration(
          // 背景色：选中时白色，未选中时透明（和整体背景融合）
          color: isSelected ? selectedColor : Colors.transparent,
          // 胶囊圆角（根据内边距调整，实现椭圆效果）
          borderRadius: BorderRadius.circular(32),
          // 未选中时添加边框
          // border: isSelected
          //     ? null
          //     : Border.all(color: const Color.fromARGB(255, 115, 114, 114).withValues(alpha:0.3), width:2),
          // 选中时的柔和外发光（匹配你截图里的暖黄高亮）
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFE8B2).withValues(alpha:0.6), // 暖黄色发光
                    blurRadius: 16, // 模糊半径，控制发光柔和度
                    spreadRadius: 2, // 扩散半径，控制发光范围
                    offset: const Offset(0, 2), // 轻微向下偏移，更自然
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.transparent, // 未选中时的微弱阴影
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min, // 自适应宽度，不占多余空间
          children: [
            // 图标
            //Icon(icon, color: isSelected ? Colors.white : unselectedColor),
            //const SizedBox(width: 8), // 图标和文字的间距
            // 标签文字
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                // 选中时加粗
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                // 颜色：选中时橙色，未选中时深棕色
                color: isSelected ? Colors.white : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
