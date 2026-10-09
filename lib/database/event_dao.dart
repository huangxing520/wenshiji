// EventDao: 事件数据访问层（Drift DAO）。
// 负责持久化行 EventRow ↔ freezed 领域模型 Event 的映射。
// freezed Event 作为领域模型保留，Drift 行类仅在 DAO 内部使用，不穿透到 UI。
import 'package:drift/drift.dart';

import '../common/app_logger.dart';
import '../models/event.dart' as model;
import 'wenshiji_database.dart';

part 'generated/event_dao.g.dart';

@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  EventDao(super.db);

  // 类型转换器实例（与 wenshiji_database.dart 中定义的转换器类一致）
  // 未知枚举名时回退到语义最弱的值，避免脏数据被静默提升。
  static final _typeConverter = SafeEnumNameConverter<model.EventType>(
    model.EventType.values,
    fallback: model.EventType.task,
  );
  static final _priorityConverter = SafeEnumNameConverter<model.EventPriority>(
    model.EventPriority.values,
    fallback: model.EventPriority.low,
  );
  static final _repeatConverter = SafeEnumNameConverter<model.RepeatRule>(
    model.RepeatRule.values,
    fallback: model.RepeatRule.none,
  );
  static const _dateTimeListConverter = DateTimeListConverter();
  static const _stringListConverter = StringListConverter();

  /// 读取全部事件（按生效时间升序，保证顺序确定）。
  /// 需按归档/激活过滤的调用方请自行筛选（或在 provider 层用 FilterType）。
  Future<List<model.Event>> getAllEvents() async {
    final rows = await (select(events)
          ..orderBy([(t) => OrderingTerm(expression: t.nextEffectiveTime)]))
        .get();
    return _toModels(rows);
  }

  Stream<List<model.Event>> watchAllEvents() {
    return (select(events)
          ..orderBy([(t) => OrderingTerm(expression: t.nextEffectiveTime)]))
        .watch()
        .map(_toModels);
  }

  /// 逐行降级：单行映射失败只跳过该行并记日志，不让整表读取失败。
  List<model.Event> _toModels(List<EventRow> rows) {
    final result = <model.Event>[];
    for (final row in rows) {
      try {
        result.add(_toModel(row));
      } catch (e) {
        AppLogger().error('事件行解析失败，已跳过: id=${row.id}', error: e);
      }
    }
    return result;
  }

  Future<model.Event?> getEventById(String id) async {
    final row = await (select(events)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  Future<void> upsertEvent(model.Event e) async {
    await into(events).insertOnConflictUpdate(_toCompanion(e));
  }

  /// 仅在行已存在时更新，返回是否命中。
  /// 用于开关类操作（置顶 / 收藏 / 打卡 / 归档）：这些操作作用于界面上的事件，
  /// 可能是未落库的样本数据，绝不能因 `insertOnConflictUpdate` 的 INSERT 分支
  /// 把样本写进真实库。
  Future<bool> updateExistingEvent(model.Event e) async {
    final affected = await (update(events)..where((t) => t.id.equals(e.id)))
        .write(_toCompanion(e));
    return affected > 0;
  }

  /// 批量 upsert（单个事务），供历史数据回填使用。
  Future<void> upsertEvents(List<model.Event> items) async {
    if (items.isEmpty) return;
    await batch((b) {
      b.insertAllOnConflictUpdate(events, items.map(_toCompanion).toList());
    });
  }

  Future<void> deleteEvent(String id) async {
    await (delete(events)..where((t) => t.id.equals(id))).go();
  }

  /// 清空并批量写入事件，整体在事务内执行：
  /// 任一步失败则回滚，不会留下「已清空但只写入一半」的中间态。
  /// 供备份恢复使用。
  Future<void> replaceAllEvents(List<model.Event> items) async {
    await transaction(() async {
      await delete(events).go();
      await batch((b) {
        b.insertAll(events, items.map(_toCompanion).toList());
      });
    });
  }

  model.Event _toModel(EventRow r) {
    return model.Event(
      id: r.id,
      name: r.name,
      date: DateTime.fromMillisecondsSinceEpoch(r.date),
      nextEffectiveTime:
          DateTime.fromMillisecondsSinceEpoch(r.nextEffectiveTime),
      type: _typeConverter.fromSql(r.type),
      priority: _priorityConverter.fromSql(r.priority),
      isPinned: r.isPinned,
      isStarred: r.isStarred,
      checkinTimes: _dateTimeListConverter.fromSql(r.checkinTimes),
      checkinStreakCount: r.checkinStreakCount,
      isArchived: r.isArchived,
      archivedAt: r.archivedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(r.archivedAt!),
      isLunar: r.isLunar,
      repeatRule: _repeatConverter.fromSql(r.repeatRule),
      description: r.description,
      picturePaths: _stringListConverter.fromSql(r.picturePaths),
      tags: _stringListConverter.fromSql(r.tags),
    );
  }

  EventsCompanion _toCompanion(model.Event e) {
    return EventsCompanion(
      id: Value(e.id),
      name: Value(e.name),
      date: Value(e.date.millisecondsSinceEpoch),
      nextEffectiveTime: Value(e.nextEffectiveTime.millisecondsSinceEpoch),
      type: Value(_typeConverter.toSql(e.type)),
      priority: Value(_priorityConverter.toSql(e.priority)),
      isPinned: Value(e.isPinned),
      isStarred: Value(e.isStarred),
      checkinTimes: Value(_dateTimeListConverter.toSql(e.checkinTimes)),
      checkinStreakCount: Value(e.checkinStreakCount),
      isArchived: Value(e.isArchived),
      archivedAt: Value(e.archivedAt?.millisecondsSinceEpoch),
      isLunar: Value(e.isLunar),
      repeatRule: Value(_repeatConverter.toSql(e.repeatRule)),
      description: Value(e.description),
      picturePaths: Value(_stringListConverter.toSql(e.picturePaths)),
      tags: Value(_stringListConverter.toSql(e.tags)),
    );
  }
}
