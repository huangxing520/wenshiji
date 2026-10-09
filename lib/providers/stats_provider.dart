// stats_provider.dart
// 从 event.dart 拆分：统计信息派生 Provider。
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/providers/event_filter_providers.dart';

part 'generated/stats_provider.g.dart';

// ==================== 4. 派生 Provider：统计信息 ====================
@riverpod
Map<String, int> stats(Ref ref) {
  final events = ref.watch(filteredEventsProvider(filterType: FilterType.all));

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final threeDaysLater = today.add(const Duration(days: 3));
  final yesterday = today.subtract(const Duration(days: 1));

  final todayCount = events
      .where(
        (e) =>
            e.type != EventType.dailySignIn &&
            e.nextEffectiveTime.year == today.year &&
            e.nextEffectiveTime.month == today.month &&
            e.nextEffectiveTime.day == today.day,
      )
      .length;

  final upcomingCount = events
      .where(
        (e) =>
            // 「近 3 天」窗口：today-1 .. today+3，之前多加了 3 天实际变成 6 天窗口。
            e.nextEffectiveTime.isAfter(yesterday) &&
            e.nextEffectiveTime.isBefore(threeDaysLater) &&
            (e.priority == EventPriority.special ||
                e.priority == EventPriority.high),
      )
      .length;

  final dailySignInCount = events
      .where(
        (e) =>
            e.type == EventType.dailySignIn &&
            e.nextEffectiveTime.isAfter(yesterday),
      )
      .length;

  return {
    'today': todayCount,
    'upcoming': upcomingCount,
    'dailySignIn': dailySignInCount,
  };
}
