// event_filter_providers.dart
// 从 event.dart 拆分：分类选择 / 过滤 / 单条查询。
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/providers/event.dart';

part 'generated/event_filter_providers.g.dart';

enum EventCategory { all, birthday, task, dailySignIn, star, holiday }

// ==================== 2. 分类选择（可修改状态 Notifier） ====================
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  EventCategory build() => EventCategory.all;

  void setCategory(EventCategory category) => state = category;
}

enum FilterType { all, archived, active }

@riverpod
List<Event> filteredEvents(Ref ref, {required FilterType filterType}) {
  // 1. 监听依赖（异步数据源 + 分类）
  final eventsAsync = ref.watch(eventProvider);
  final category = ref.watch(selectedCategoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // 2. 用 when 处理异步状态，加载/错误时返回空列表
  return eventsAsync.when(
    data: (events) {
      List<Event> filtered;

      // 按分类过滤
      switch (category) {
        case EventCategory.all:
          filtered = events;
          break;
        case EventCategory.birthday:
          filtered = events.where((e) => e.type == EventType.birthday).toList();
          break;
        case EventCategory.task:
          filtered = events.where((e) => e.type == EventType.task).toList();
          break;
        case EventCategory.dailySignIn:
          filtered = events
              .where((e) => e.type == EventType.dailySignIn)
              .toList();
          break;
        case EventCategory.star:
          filtered = events.where((e) => e.isStarred).toList();
          break;
        case EventCategory.holiday:
          filtered = events.where((e) => e.type == EventType.holiday).toList();
          break;
      }

      // 按激活/归档过滤：两个分支互补，且只看归档标志。
      // 此前 archived 含 `|| nextEffectiveTime.isBefore(today)`（把「过期」当「已归档」）
      // 且与 active 不互斥，导致过期事件被误列为归档、归档后卡片原地不动。
      filtered = filtered.where((e) {
        switch (filterType) {
          case FilterType.all:
            return true;
          case FilterType.archived:
            return e.isArchived;
          case FilterType.active:
            return !e.isArchived;
        }
      }).toList();

      // 排序：置顶优先 → 按类型分组 → 组内比较。
      // 之前只按 a.type 分支比较（cmp(a,b) 与 cmp(b,a) 规则不同），违反反对称性，
      // 会让 sort 结果不稳定、每次发射都重排跳动。
      filtered.sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        final aSign = a.type == EventType.dailySignIn ? 1 : 0;
        final bSign = b.type == EventType.dailySignIn ? 1 : 0;
        if (aSign != bSign) return aSign.compareTo(bSign);
        if (aSign == 1) {
          // 打卡类：已坚持天数降序
          return today
              .difference(b.date)
              .inDays
              .compareTo(today.difference(a.date).inDays);
        }
        // 其他：距生效日升序
        return a.date
            .difference(today)
            .inDays
            .compareTo(b.date.difference(today).inDays);
      });

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}
@riverpod
Event? getEvent(Ref ref, String id) {
  final eventsAsync = ref.watch(eventProvider);
  return eventsAsync.when(
    data: (events) {
      // 找不到时返回 null（而非抛 StateError），等待删除/归档后订阅方自行处理空态。
      final matches = events.where((e) => e.id == id);
      return matches.isEmpty ? null : matches.first;
    },
    loading: () => null,
    error: (_, __) => null,
  );
}
