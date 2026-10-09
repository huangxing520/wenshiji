import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/constants/config_constant.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/widget/home/event_cards.dart';
import 'package:wenshiji/theme/app_colors.dart';
import '../common/preferences.dart';
import '../models/event.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey _listViewKey = GlobalKey();
  final ScrollController _tabScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    preferences.saveInitState(true);
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventProvider);
    final filteredEvents = ref.watch(
      filteredEventsProvider(filterType: FilterType.active),
    );
    //AppLogger().info('filteredEvents: $filteredEvents');
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
                        color: AppColors.primary,
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
              // Row(
              //   children: [
              //     IconButton(
              //       icon: Icon(
              //         Icons.search,
              //         size: 28,
              //         color: Color(0xFF8B7648),
              //       ),
              //       onPressed: () async {
              //         await NotificationService().showInstantNotification(
              //           title: "即时提醒",
              //           body: "这是一条立即弹出的通知",
              //           payload: "test_payload", // 点击通知携带的参数
              //         );
              //       },
              //     ),
              //   ],
              // ),
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
      (EventCategory.dailySignIn, '日程打卡', Icons.trending_up_rounded),
      (EventCategory.star, '星标', Icons.star_rounded),
      (EventCategory.holiday, '节日', Icons.celebration_rounded),
    ];

    // 找到当前选中项的索引
    final activeIndex = categories.indexWhere(
      (item) => item.$1 == currentCategory,
    );

    // 在下一帧滚动到选中项
    if (activeIndex >= 0 && _tabScrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToActiveTab(activeIndex, categories.length);
      });
    }

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFFAF7F0),
      child: ListView.builder(
        key: _listViewKey,
        controller: _tabScrollController,
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
            onTap: () => ref
                .read(selectedCategoryProvider.notifier)
                .setCategory(category),
            selectedColor: Colors.orange,
            unselectedColor: const Color(0xFF8B8066),
          );
        },
      ),
    );
  }

  void _scrollToActiveTab(int index, int totalCount) {
    if (!_tabScrollController.hasClients) return;

    // 估算每个 tab 的宽度（可以根据实际调整）
    const double tabWidth = 100.0;
    const double tabSpacing = 14.0; // margin right
    final double itemWidth = tabWidth + tabSpacing;

    // 计算目标滚动位置，让选中项居中显示
    final screenWidth = MediaQuery.of(context).size.width;
    final double targetOffset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    // 限制滚动范围
    final double maxScroll = _tabScrollController.position.maxScrollExtent;
    final double clampedOffset = targetOffset.clamp(0.0, maxScroll);

    _tabScrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildContent(List<Event> events, Map<String, int> stats) {
    final currentCategory = ref.watch(selectedCategoryProvider);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dx;
        if (velocity.abs() > 100.0) {
          if (velocity > 0 && currentCategory.index > 0) {
            ref
                .read(selectedCategoryProvider.notifier)
                .setCategory(EventCategory.values[currentCategory.index - 1]);
          } else if (velocity < 0 &&
              currentCategory.index < EventCategory.values.length - 1) {
            ref
                .read(selectedCategoryProvider.notifier)
                .setCategory(EventCategory.values[currentCategory.index + 1]);
          }
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 18),
            _buildTodayOverview(stats),
            if (events.isEmpty) _buildEmptyState() else _buildEventList(events),
            const SizedBox(height: 100),
          ],
        ),
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
                label: '进行中日程打卡',
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
      Season.spring => AppColors.springColor,
      Season.summer => AppColors.summerColor,
      Season.autumn => AppColors.autumnColor,
      Season.winter => AppColors.winterColor,
    };
    return CardSpring(
      trigger: currentCategory,
      child: Column(
        children: events.map((event) {
          // 传 ValueKey(event.id)：列表排序含置顶、打卡/归档后整体重排，
          // 没有 key 时 State 会与事件错位（动画重放、打卡状态串位）。
          if (event.isPinned) {
            return PinnedCard(
              key: ValueKey(event.id),
              event: event,
              onLongPress: () => _showContextMenuFor(event.id),
              seasonColors: seasonColors,
              // 置顶的连签事件同样要能打卡。
              onQuickCheckin: () => _quickCheckin(event.id),
            );
          } else {
            return EventCard(
              key: ValueKey(event.id),
              event: event,
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
              color: AppColors.primary,
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
              backgroundColor: AppColors.primary,
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
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.45),
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


  void _showContextMenuFor(String eventId) {
    // 用真正的模态路由承载菜单：此前菜单是 HomeScreen Stack 的子节点，
    // 会被 MainShell 的底部导航盖住且不被遮挡拦截，切 tab 后遮罩仍留在保活的 Home 上。
    final event = ref
        .read(eventProvider)
        .value
        ?.where((e) => e.id == eventId);
    if (event == null || event.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _buildEventActionSheet(sheetContext, eventId),
    );
  }

  Widget _buildEventActionSheet(BuildContext sheetContext, String eventId) {
    Future<void> run(ActionItem action) async {
      try {
        await action.run();
        if (!sheetContext.mounted) return;
        Navigator.of(sheetContext).pop();
        if (action.toast != null) _showToast(action.toast!);
      } catch (e, s) {
        AppLogger().error('事件操作失败: ${action.label}', error: e, stack: s);
        if (sheetContext.mounted) {
          Navigator.of(sheetContext).pop();
          _showToast('操作失败，请重试');
        }
      }
    }

    final actions = <ActionItem>[
      ActionItem(
        icon: Icons.push_pin,
        label: '置顶 / 取消置顶',
        toast: '操作成功',
        run: () => ref.read(eventProvider.notifier).togglePin(eventId),
      ),
      ActionItem(
        icon: Icons.star,
        label: '星标 / 取消星标',
        toast: '操作成功',
        run: () => ref.read(eventProvider.notifier).toggleStar(eventId),
      ),
      ActionItem(
        icon: Icons.edit,
        label: '编辑',
        run: () async {
          final matches = ref
              .read(eventProvider)
              .value
              ?.where((e) => e.id == eventId);
          if (matches != null && matches.isNotEmpty) {
            unawaited(context.push('/add-event', extra: matches.first));
          }
        },
      ),
      ActionItem(
        icon: Icons.archive,
        label: '归档',
        toast: '已归档',
        run: () => ref
            .read(eventProvider.notifier)
            .setArchivedEvent(eventId, true),
      ),
      ActionItem(
        icon: Icons.info,
        label: '详情',
        run: () async => context.push('/event-detail/$eventId'),
      ),
      ActionItem(
        icon: Icons.delete,
        label: '删除',
        isDanger: true,
        toast: '已删除',
        run: () => ref.read(eventProvider.notifier).deleteEvent(eventId),
      ),
    ];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
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
            for (var i = 0; i < actions.length; i++) ...[
              if (actions[i].label == '删除')
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: const Color(0xFFE8E4DC),
                ),
              ContextMenuItem(
                icon: actions[i].icon,
                label: actions[i].label,
                isDanger: actions[i].isDanger,
                // 统一走 run()：即使 action 是同步逻辑也包在 await 里，
                // 写库抛错不会变成未捕获异步异常。
                onTap: () => run(actions[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _quickCheckin(String eventId) async {
    // await 后按结果提示：原来未 await 就固定弹「打卡成功」，
    // 写库失败时仍提示成功。
    try {
      await ref.read(eventProvider.notifier).quickCheckin(eventId);
      if (!mounted) return;
      _showToast('✓ 打卡成功！');
    } catch (e, s) {
      AppLogger().error('打卡失败', error: e, stack: s);
      if (mounted) _showToast('打卡失败，请重试');
    }
  }



  void _showToast(String message) {
    Utils().showToast(message, null);
  }
}

/// 事件长按菜单中的单个操作项（供 _buildEventActionSheet 使用）。
class ActionItem {
  final IconData icon;
  final String label;
  final bool isDanger;
  final String? toast;
  final Future<void> Function() run;

  ActionItem({
    required this.icon,
    required this.label,
    required this.run,
    this.isDanger = false,
    this.toast,
  });
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
