import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/theme/app_colors.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _particleController;
  late AnimationController _countdownController;
  late Animation<double> _countdownAnimation;
  final math.Random _random = math.Random();

  final Map<EventPriority, Color> priorityColors = {
    EventPriority.special: const Color(0xFFDE7855),
    EventPriority.high: const Color(0xFFE09D62),
    EventPriority.mid: AppColors.primary,
    EventPriority.low: const Color(0xFF7DB87D),
  };

  final Color bgColor = const Color(0xFFF7F4EE);
  final Color surfaceColor = const Color(0xFFFCFBF8);
  final Color fgColor = const Color(0xFF383A42);
  final Color mutedColor = const Color(0xFF858894);
  final Color borderColor = const Color(0xFFE6E4DF);
  final Color accentColor = AppColors.primary;
  final Color accentSoftColor = const Color(0xFFECE6D9);
  final Color accentDeepColor = const Color(0xFFA17E38);
  List<Particle> _particles = [];
  int _daysRemaining = 0;
  int _hoursRemaining = 0;
  int _minutesRemaining = 0;
  int _secondsRemaining = 0;
  Timer? _dayTick;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initParticles();
    // _calculateCountdown();
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _countdownController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _countdownAnimation = CurvedAnimation(
      parent: _countdownController,
      curve: Curves.elasticOut,
    );
    _countdownController.forward();
    //_startCountdownTimer();
    // 页面停留期间跨天时刷新天数显示（此前 _startCountdownTimer 被注释导致永不更新）。
    _dayTick = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _initParticles() {
    _particles = List.generate(30, (index) {
      return Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.5 + 0.3,
      );
    });
  }

  // void _calculateCountdown() {
  //   final eventDate = DateTime(2025, 7, 18, 9, 0);
  //   final now = DateTime.now();
  //   final difference = eventDate.difference(now);

  //   if (difference.isNegative) {
  //     _daysRemaining = 0;
  //     _hoursRemaining = 0;
  //     _minutesRemaining = 0;
  //     _secondsRemaining = 0;
  //   } else {
  //     _daysRemaining = difference.inDays;
  //     _hoursRemaining = difference.inHours % 24;
  //     _minutesRemaining = difference.inMinutes % 60;
  //     _secondsRemaining = difference.inSeconds % 60;
  //   }
  // }

  // void _startCountdownTimer() {
  //   Future.delayed(const Duration(seconds: 1), () {
  //     if (mounted) {
  //       setState(() {
  //         _calculateCountdown();
  //       });
  //       _startCountdownTimer();
  //     }
  //   });
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 粒子动画以 60fps 重绘整块 hero：切后台/未激活时暂停，避免无谓耗电。
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
    _dayTick?.cancel();
    _particleController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  void _showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: fgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(color: fgColor, fontWeight: FontWeight.w600),
        ),
        content: Text(message, style: TextStyle(color: mutedColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消', style: TextStyle(color: mutedColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              '确认',
              style: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(getEventProvider(widget.eventId));
    final isPinned = event?.isPinned ?? false;
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // _buildStatusBar(statusBarHeight),
                _buildNavigationBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildCountdownHero(isPinned, screenWidth),
                        _buildInfoCards(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        // bottomSheet: _buildBottomActionBar(),
      ),
    );
  }

  Widget _buildStatusBar(double height) {
    return Container(
      height: height > 30 ? height : 24,
      padding: EdgeInsets.only(top: height > 30 ? 10 : 0),
      color: surfaceColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 20),
          Text(
            '9:41',
            style: TextStyle(
              color: fgColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: fgColor, size: 18),
              const SizedBox(width: 4),
              Icon(Icons.wifi, color: fgColor, size: 18),
              const SizedBox(width: 4),
              Icon(Icons.battery_full, color: fgColor, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 0.5)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 图标在最左边
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: fgColor, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          // 文本在整个容器中居中，但左右留有相同空间防止重叠
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32), // 数值≥图标宽度
            child: Text(
              '事件详情',
              style: TextStyle(
                color: fgColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),   
    );
  }

  Widget _buildCountdownHero(bool isPinned, double screenWidth) {
    final event = ref.watch(getEventProvider(widget.eventId));

    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Container(
          width: screenWidth,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentSoftColor,
                accentColor.withValues(alpha:0.3),
                accentSoftColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha:0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    animation: _particleController.value,
                    color: accentColor,
                  ),
                  size: Size(screenWidth - 32, 280),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isPinned)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.push_pin, color: Colors.black, size: 12),
                            SizedBox(width: 4),
                            Text(
                              '已置顶',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildCountdownDisplay(),
                    //const SizedBox(height: 5),
                    Text(
                      // 用日期实际符号判断，而非 isArchived：
                      // 未归档但已过期的事件此前被错误标为「还剩」。
                      ((_dayDiff(event) ?? 0) < 0) ? '已过去' : '还剩',
                      style: TextStyle(
                        color: const Color.fromARGB(110, 63, 67, 63),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event?.name ?? '',
                      style: TextStyle(
                        color: fgColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,

                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: mutedColor,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              if (event?.date != null)
                                Text(
                                  // 农历事件同时展示公历与农历，避免用户困惑。
                                  (event!.isLunar)
                                      ? '${DateFormat('yyyy-MM-dd').format(event.date)}（农历 ${Utils.lunarLabel(event.date)}）'
                                      : DateFormat('yyyy-MM-dd').format(event.date),
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                          _buildPriorityBadge(),
                          //const SizedBox(width: 4),
                          ..._buildCategoryBadge(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 目标日与今天的整天差（两端零点化）：>0 还剩，0 今天，<0 已过去。
  int? _dayDiff(Event? event) {
    if (event == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      event.nextEffectiveTime.year,
      event.nextEffectiveTime.month,
      event.nextEffectiveTime.day,
    );
    return target.difference(today).inDays;
  }

  Widget _buildCountdownDisplay() {
        final event = ref.watch(getEventProvider(widget.eventId));
        if (event == null) return const SizedBox.shrink();
        final diff = _dayDiff(event) ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCountdownUnit(diff.abs().toString(), '天'),
        // //const SizedBox(width: 8),
        // _buildCountdownUnit(_hoursRemaining.toString().padLeft(2, '0'), '时'),
        // const SizedBox(width: 8),
        // _buildCountdownUnit(_minutesRemaining.toString().padLeft(2, '0'), '分'),
        // const SizedBox(width: 8),
        // _buildCountdownUnit(_secondsRemaining.toString().padLeft(2, '0'), '秒'),
      ],
    );
  }

  Widget _buildCountdownUnit(String value, String label) {
    return AnimatedBuilder(
      animation: _countdownAnimation,
      builder: (context, child) {
        final scale = 1.0 + (_countdownAnimation.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha:0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: accentDeepColor,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 4),
                Text(label, style: TextStyle(color: mutedColor, fontSize: 20)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityBadge() {
    final event = ref.watch(getEventProvider(widget.eventId));
    final priority = event?.priority ?? EventPriority.mid;
    final color = priorityColors[priority] ?? accentColor;
    final labels = {
      EventPriority.special: '最高',
      EventPriority.high: '高',
      EventPriority.mid: '中',
      EventPriority.low: '低',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Text(
        '${labels[priority]}优先级',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildCategoryBadge() {
    final categories = {
      'birthday': '🎂 生日',
      'work': '💼 工作',
      'meeting': '📅 会议',
      'travel': '✈️ 旅行',
    };
    final event = ref.watch(getEventProvider(widget.eventId));
    final tags = event?.tags ?? [];
    if (tags.isEmpty) {
      return [SizedBox.shrink()];
    }
    return tags.map((e) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          e,
          style: TextStyle(
            color: fgColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildInfoCards() {
    final event = ref.watch(getEventProvider(widget.eventId));
    final hasImages = (event?.picturePaths ?? const []).isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          //_buildReminderRulesCard(),
          const SizedBox(height: 12),
          _buildNotesCard(),
          // 图片区独立渲染：即使没有备注，有照片也要显示。
          if (hasImages) ...[
            const SizedBox(height: 12),
            _buildImagesCard(),
          ],
          const SizedBox(height: 12),
          //_buildTagsCard(),
        ],
      ),
    );
  }

  Widget _buildImagesCard() {
    final event = ref.watch(getEventProvider(widget.eventId));
    final images = event?.picturePaths ?? const <String>[];
    if (images.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '照片',
            style: TextStyle(
              color: fgColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          InteractiveMultiImageGrid(imageUrls: images),
        ],
      ),
    );
  }

  // Widget _buildReminderRulesCard() {
  //       final event = ref.watch(getEventProvider(widget.eventId));

  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: surfaceColor,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: borderColor),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '提醒与规则',
  //           style: TextStyle(
  //             color: fgColor,
  //             fontSize: 15,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         // _buildInfoRow(
  //         //   Icons.repeat,
  //         //   '重复规则',
  //         //   _getRepeatLabel(eventData['repeat']!),
  //         // ),
  //         const Divider(height: 16, color: Colors.transparent),
  //         _buildInfoRow(
  //           Icons.timer,
  //           '计时模式',
  //           _getTimerModeLabel(event.type['timerMode']!),
  //         ),
  //         const Divider(height: 16, color: Colors.transparent),
  //         _buildInfoRow(
  //           Icons.notifications_active,
  //           '提前提醒',
  //           eventData['reminders']!,
  //         ),
  //         const Divider(height: 16, color: Colors.transparent),
  //         _buildInfoRow(Icons.calendar_month, '日历类型', eventData['calendar']!),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: accentSoftColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: accentColor, size: 16),
        ),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: mutedColor, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: fgColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getRepeatLabel(String repeat) {
    final labels = {
      'yearly': '每年',
      'monthly': '每月',
      'weekly': '每周',
      'daily': '每天',
      'none': '不重复',
    };
    return labels[repeat] ?? repeat;
  }

  String _getTimerModeLabel(String mode) {
    final labels = {'countdown': '倒计时', 'countup': '正计时'};
    return labels[mode] ?? mode;
  }

  Widget _buildNotesCard() {
    final event = ref.watch(getEventProvider(widget.eventId));
    final notes = event?.description ?? '';
    if (notes.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '备注',
                style: TextStyle(
                  color: fgColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentSoftColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${notes.length} 字',
                  style: TextStyle(color: accentDeepColor, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notes,
            style: TextStyle(color: fgColor, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  // Widget _buildTagsCard() {
  //       final event = ref.watch(getEventProvider(widget.eventId));

  //   final tags = eventData['tags']!.split(', ');
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: surfaceColor,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: borderColor),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '分类标签',
  //           style: TextStyle(
  //             color: fgColor,
  //             fontSize: 15,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: tags.map((tag) {
  //             return Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 12,
  //                 vertical: 6,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: accentSoftColor,
  //                 borderRadius: BorderRadius.circular(16),
  //                 border: Border.all(color: borderColor),
  //               ),
  //               child: Text(
  //                 tag,
  //                 style: TextStyle(color: fgColor, fontSize: 13),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildBottomActionBar() {
  //   return Container(
  //     padding: EdgeInsets.only(
  //       left: 16,
  //       right: 16,
  //       top: 12,
  //       bottom: MediaQuery.of(context).padding.bottom + 12,
  //     ),
  //     decoration: BoxDecoration(
  //       color: surfaceColor,
  //       boxShadow: [
  //         BoxShadow(
  //           color: fgColor.withValues(alpha:0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, -5),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildActionButton(Icons.edit, '编辑', () => _showToast(context, '编辑功能')),
  //         _buildActionButton(Icons.share, '分享', () {
  //           _showConfirmDialog(
  //             context,
  //             '分享事件',
  //             '确定要分享这个事件吗？',
  //             () => _showToast(context, '分享成功'),
  //           );
  //         }),
  //         _buildActionButton(Icons.archive, '归档', () {
  //           _showConfirmDialog(
  //             context,
  //             '归档事件',
  //             '归档后可以在归档列表中找到，确定归档吗？',
  //             () {
  //               ref.read(isArchivedProvider.notifier).state = true;
  //               _showToast(context, '已归档');
  //             },
  //           );
  //         }),
  //         _buildActionButton(
  //           Icons.push_pin,
  //           '置顶',
  //           () {
  //             final currentState = ref.read(isPinnedProvider);
  //             ref.read(isPinnedProvider.notifier).state = !currentState;
  //             _showToast(context, currentState ? '已取消置顶' : '已置顶');
  //           },
  //           isActive: ref.watch(isPinnedProvider),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? accentColor.withValues(alpha:0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? accentColor : mutedColor, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? accentColor : mutedColor,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = color.withValues(alpha:
          particle.opacity *
              (0.5 + 0.5 * math.sin(animation * 2 * math.pi + particle.x * 10)),
        )
        ..style = PaintingStyle.fill;

      final x =
          particle.x * size.width +
          math.sin(animation * 2 * math.pi + particle.y * 5) * 10;
      final y =
          particle.y * size.height -
          (animation * particle.speed * 50) % size.height;

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class InteractiveMultiImageGrid extends StatefulWidget {
  const InteractiveMultiImageGrid({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<InteractiveMultiImageGrid> createState() =>
      _InteractiveMultiImageGridState();
}

class _InteractiveMultiImageGridState extends State<InteractiveMultiImageGrid> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.imageUrls
          .map((url) => _buildThumbnail(context, url))
          .toList(),
    );
  }

  // 构建单个缩略图（支持点击放大）
  Widget _buildThumbnail(BuildContext context, String url) {
    final String cleanPath = _cleanPath(url);
    return GestureDetector(
      onTap: () => _showFullImage(context, cleanPath),
      child: Hero(
        // tag 统一用 cleanPath：此前缩略图用原始 url、全屏页用 cleanPath，
        // 带 file:// 前缀时两者不匹配导致 Hero 动画失效。
        tag: cleanPath,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(cleanPath),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            // 缩略图按显示尺寸解码，避免按原图解码占用大量内存。
            cacheWidth: 160,
            errorBuilder: (context, error, stack) => _buildImageError(80, 80),
          ),
        ),
      ),
    );
  }

  /// 去掉 file:// 前缀，得到可交给 File 的本地路径。
  String _cleanPath(String url) =>
      url.startsWith('file://') ? url.replaceFirst('file://', '') : url;

  Widget _buildImageError(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF0ECE4),
      child: const Icon(
        Icons.broken_image_outlined,
        color: Color(0xFF858894),
        size: 24,
      ),
    );
  }

  // 全屏预览大图（支持缩放）
  void _showFullImage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _FullScreenImagePage(url: url)),
    );
  }
}

// 全屏大图页面（内部用 InteractiveViewer 实现缩放）
class _FullScreenImagePage extends StatelessWidget {
  final String url;
  const _FullScreenImagePage({required this.url});

  @override
  Widget build(BuildContext context) {
    // 按屏幕物理像素解码，避免高分辨率照片按原图解码导致 OOM。
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final cacheWidth = (width * dpr).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Hero(
          tag: url,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 5.0,
            child: Image.file(
              File(url),
              fit: BoxFit.contain,
              cacheWidth: cacheWidth,
              errorBuilder: (context, error, stack) => const Padding(
                padding: EdgeInsets.all(32),
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
