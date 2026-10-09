// event_provider.dart
// 核心事件管理：数据库基础设施 + EventNotifier。
// 分类过滤 / 统计 / 图片 等派生 Provider 已拆分至：
//   - event_filter_providers.dart
//   - stats_provider.dart
//   - image_providers.dart
// 此处重新导出，保持 `import 'providers/event.dart'` 的下游消费方
// （8 个 screen + main.dart）无需修改导入路径。
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/common/notification_service.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/database/wenshiji_database.dart';
import 'package:wenshiji/repositories/event_repository.dart';
import 'package:wenshiji/services/image_service.dart';

export 'package:wenshiji/providers/event_filter_providers.dart';
export 'package:wenshiji/providers/stats_provider.dart';
export 'package:wenshiji/providers/image_providers.dart';

import '../models/event.dart';

part 'generated/event.g.dart';

// ==================== 0. 数据库与仓库（基础设施 Provider） ====================

/// AppDatabase 单例（keepAlive，应用生命周期内常驻）。
/// main() 通过 ProviderScope overrides 注入已初始化并迁移完成的实例。
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

/// EventRepository：领域层访问持久化的入口。
@Riverpod(keepAlive: true)
EventRepository eventRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return EventRepository(db.eventDao);
}

// ==================== 1. 核心事件管理（AsyncNotifier） ====================
/// 自动生成 provider 名称为 eventProvider
@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {
  late final EventRepository _repository;

  /// 初始化加载
  @override
  Future<List<Event>> build() async {
    _repository = ref.watch(eventRepositoryProvider);
    return _loadEvents();
  }

  List<Event> get _currentEvents => state.value ?? [];

  Future<List<Event>> _loadEvents() async {
    try {
      final events = await _repository.getAllEvents();
      if (events.isNotEmpty) {
        return _backfill(events);
      }
      // 首次启动或无数据：返回样本事件（仅展示，不持久化）
      return Utils().getSampleEvents();
    } catch (e, s) {
      AppLogger().error('加载事件数据失败', error: e, stack: s);
      throw Exception('加载失败: $e');
    }
  }

  /// 历史数据一次性回填（幂等）：
  /// 1. 为「生日 / 节日」等本应每年重复、但历史版本保存时从未落库 repeatRule
  ///    （恒为 none）的事件补上年重复规则；
  /// 2. 按规则把 nextEffectiveTime 前滚到「今天或之后」，让过完当天的生日重新回到首页。
  /// 仅当确有变化时才写库，避免每次启动做无谓的写入。
  Future<List<Event>> _backfill(List<Event> events) async {
    final now = DateTime.now();
    final changed = <Event>[];
    final result = <Event>[];

    for (final e in events) {
      var updated = e;
      // 补默认重复规则：生日 / 节日默认每年；每日打卡默认每日。
      if (updated.repeatRule == RepeatRule.none) {
        final inferred = switch (updated.type) {
          EventType.birthday || EventType.holiday => RepeatRule.yearly,
          EventType.dailySignIn => RepeatRule.daily,
          EventType.task => RepeatRule.none,
        };
        if (inferred != RepeatRule.none) {
          updated = updated.copyWith(repeatRule: inferred);
        }
      }
      // 前滚生效时间（未归档的才需要；归档事件保持原样）。
      if (!updated.isArchived) {
        final next = Utils.nextEffectiveOf(updated, now);
        if (next != updated.nextEffectiveTime) {
          updated = updated.copyWith(nextEffectiveTime: next);
        }
      }
      if (updated != e) changed.add(updated);
      result.add(updated);
    }

    if (changed.isNotEmpty) {
      try {
        await _repository.upsertEvents(changed);
        AppLogger().info('历史事件回填：更新 ${changed.length} 条');
      } catch (e, s) {
        // 回填失败不阻断加载，内存中仍返回前滚后的结果。
        AppLogger().error('历史事件回填写库失败', error: e, stack: s);
      }
    }
    return result;
  }

  // 新增事件：先落库，成功后再更新内存状态。
  // 否则写库失败时首页会显示一个「重启后就消失」的幽灵事件。
  Future<void> addEvent(Event event) async {
    await _repository.upsertEvent(event);
    state = AsyncValue.data([..._currentEvents, event]);
  }

  // 更新事件：同样先落库后改内存。
  Future<void> updateEvent(String id, Event updated) async {
    await _repository.upsertEvent(updated);
    final updatedEvents = _currentEvents
        .map((e) => e.id == id ? updated : e)
        .toList();
    state = AsyncValue.data(updatedEvents);
  }

  // 删除事件
  Future<void> deleteEvent(String id) async {
    await _repository.deleteEvent(id);
    await NotificationService().cancelEventNotifications(id);
    await _cleanupEventImages(id);
    final updatedEvents = _currentEvents.where((e) => e.id != id).toList();
    state = AsyncValue.data(updatedEvents);
  }

  /// 删除事件关联的图片文件与记录，避免留下无主的孤儿文件。
  /// 失败仅记日志：图片清理不是主流程，不应阻断事件删除。
  Future<void> _cleanupEventImages(String id) async {
    try {
      await ImageService().deleteAllImagesForId(id);
    } catch (e, s) {
      AppLogger().error('清理事件图片失败: $id', error: e, stack: s);
    }
  }

  // 设置事件归档状态
  Future<void> setArchivedEvent(String id, bool isArchived) async {
    final idx = _currentEvents.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final updated = _currentEvents[idx].copyWith(
      isArchived: isArchived,
      // 归档时记录时间，解除归档时清空。用于「本月归档」统计与恢复入口。
      archivedAt: isArchived ? DateTime.now() : null,
    );
    await _persistToggle(updated);
  }

  // 删除所有归档事件（保留未归档的）
  Future<void> deleteAllArchivedEvent() async {
    // 与归档页展示谓词保持一致：只看 isArchived，
    // 否则「手动归档但到期日在未来」的事件在列表可见却永不被清空。
    final removed = <String>[];
    final kept = <Event>[];
    for (final e in _currentEvents) {
      if (e.isArchived) {
        removed.add(e.id);
      } else {
        kept.add(e);
      }
    }
    for (final id in removed) {
      await _repository.deleteEvent(id);
      await NotificationService().cancelEventNotifications(id);
      await _cleanupEventImages(id);
    }
    state = AsyncValue.data(kept);
  }

  // 切换置顶
  Future<void> togglePin(String id) async {
    final idx = _currentEvents.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final updated =
        _currentEvents[idx].copyWith(isPinned: !_currentEvents[idx].isPinned);
    await _persistToggle(updated);
  }

  // 切换收藏
  Future<void> toggleStar(String id) async {
    final idx = _currentEvents.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final updated =
        _currentEvents[idx].copyWith(isStarred: !_currentEvents[idx].isStarred);
    await _persistToggle(updated);
  }

  // 快速打卡
  Future<void> quickCheckin(String id) async {
    final idx = _currentEvents.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final current = _currentEvents[idx];
    if (Utils().hasToday(current.checkinTimes)) return; // 今日已打卡
    final today = DateTime.now().toLocal();
    final updated = current.copyWith(
      checkinTimes: [
        ...current.checkinTimes,
        DateTime(today.year, today.month, today.day),
      ],
      checkinStreakCount: current.checkinTimes.length + 1,
    );
    AppLogger().info('quickCheckin: $id');
    await _persistToggle(updated);
  }

  /// 持久化开关类改动：只更新已存在的行（不 insert）。
  /// 界面上的样本事件（固定 id '1'..'12'，从未落库）因此不会污染真实库；
  /// 对样本仅更新内存状态以保证交互即时反馈。
  Future<void> _persistToggle(Event updated) async {
    final persisted = await _repository.updateExistingEvent(updated);
    if (!persisted) {
      AppLogger().info('事件 ${updated.id} 未落库（样本数据），仅更新内存状态');
    }
    final idx = _currentEvents.indexWhere((e) => e.id == updated.id);
    if (idx == -1) return;
    final newList = [..._currentEvents];
    newList[idx] = updated;
    state = AsyncValue.data(newList);
  }
}
