// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../wenshiji_database.dart';

// ignore_for_file: type=lint
class $EventsTable extends Events with TableInfo<$EventsTable, EventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextEffectiveTimeMeta = const VerificationMeta(
    'nextEffectiveTime',
  );
  @override
  late final GeneratedColumn<int> nextEffectiveTime = GeneratedColumn<int>(
    'next_effective_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isStarredMeta = const VerificationMeta(
    'isStarred',
  );
  @override
  late final GeneratedColumn<bool> isStarred = GeneratedColumn<bool>(
    'is_starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkinTimesMeta = const VerificationMeta(
    'checkinTimes',
  );
  @override
  late final GeneratedColumn<String> checkinTimes = GeneratedColumn<String>(
    'checkin_times',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _checkinStreakCountMeta =
      const VerificationMeta('checkinStreakCount');
  @override
  late final GeneratedColumn<int> checkinStreakCount = GeneratedColumn<int>(
    'checkin_streak_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<int> archivedAt = GeneratedColumn<int>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLunarMeta = const VerificationMeta(
    'isLunar',
  );
  @override
  late final GeneratedColumn<bool> isLunar = GeneratedColumn<bool>(
    'is_lunar',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_lunar" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _repeatRuleMeta = const VerificationMeta(
    'repeatRule',
  );
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
    'repeat_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _picturePathsMeta = const VerificationMeta(
    'picturePaths',
  );
  @override
  late final GeneratedColumn<String> picturePaths = GeneratedColumn<String>(
    'picture_paths',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    date,
    nextEffectiveTime,
    type,
    priority,
    isPinned,
    isStarred,
    checkinTimes,
    checkinStreakCount,
    isArchived,
    archivedAt,
    isLunar,
    repeatRule,
    description,
    picturePaths,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('next_effective_time')) {
      context.handle(
        _nextEffectiveTimeMeta,
        nextEffectiveTime.isAcceptableOrUnknown(
          data['next_effective_time']!,
          _nextEffectiveTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextEffectiveTimeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_starred')) {
      context.handle(
        _isStarredMeta,
        isStarred.isAcceptableOrUnknown(data['is_starred']!, _isStarredMeta),
      );
    }
    if (data.containsKey('checkin_times')) {
      context.handle(
        _checkinTimesMeta,
        checkinTimes.isAcceptableOrUnknown(
          data['checkin_times']!,
          _checkinTimesMeta,
        ),
      );
    }
    if (data.containsKey('checkin_streak_count')) {
      context.handle(
        _checkinStreakCountMeta,
        checkinStreakCount.isAcceptableOrUnknown(
          data['checkin_streak_count']!,
          _checkinStreakCountMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('is_lunar')) {
      context.handle(
        _isLunarMeta,
        isLunar.isAcceptableOrUnknown(data['is_lunar']!, _isLunarMeta),
      );
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
        _repeatRuleMeta,
        repeatRule.isAcceptableOrUnknown(data['repeat_rule']!, _repeatRuleMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('picture_paths')) {
      context.handle(
        _picturePathsMeta,
        picturePaths.isAcceptableOrUnknown(
          data['picture_paths']!,
          _picturePathsMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      nextEffectiveTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_effective_time'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isStarred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starred'],
      )!,
      checkinTimes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkin_times'],
      )!,
      checkinStreakCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}checkin_streak_count'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived_at'],
      ),
      isLunar: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_lunar'],
      )!,
      repeatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_rule'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      picturePaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}picture_paths'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class EventRow extends DataClass implements Insertable<EventRow> {
  final String id;
  final String name;
  final int date;
  final int nextEffectiveTime;
  final String type;
  final String priority;
  final bool isPinned;
  final bool isStarred;
  final String checkinTimes;
  final int checkinStreakCount;
  final bool isArchived;

  /// 归档时间（自纪元毫秒）。null = 未归档。用于「本月归档」等按归档时间统计，
  /// 取代此前误用 nextEffectiveTime 的做法。
  final int? archivedAt;

  /// 是否农历日期。
  final bool isLunar;
  final String repeatRule;
  final String description;
  final String picturePaths;
  final String tags;
  const EventRow({
    required this.id,
    required this.name,
    required this.date,
    required this.nextEffectiveTime,
    required this.type,
    required this.priority,
    required this.isPinned,
    required this.isStarred,
    required this.checkinTimes,
    required this.checkinStreakCount,
    required this.isArchived,
    this.archivedAt,
    required this.isLunar,
    required this.repeatRule,
    required this.description,
    required this.picturePaths,
    required this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<int>(date);
    map['next_effective_time'] = Variable<int>(nextEffectiveTime);
    map['type'] = Variable<String>(type);
    map['priority'] = Variable<String>(priority);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_starred'] = Variable<bool>(isStarred);
    map['checkin_times'] = Variable<String>(checkinTimes);
    map['checkin_streak_count'] = Variable<int>(checkinStreakCount);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(archivedAt);
    }
    map['is_lunar'] = Variable<bool>(isLunar);
    map['repeat_rule'] = Variable<String>(repeatRule);
    map['description'] = Variable<String>(description);
    map['picture_paths'] = Variable<String>(picturePaths);
    map['tags'] = Variable<String>(tags);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      name: Value(name),
      date: Value(date),
      nextEffectiveTime: Value(nextEffectiveTime),
      type: Value(type),
      priority: Value(priority),
      isPinned: Value(isPinned),
      isStarred: Value(isStarred),
      checkinTimes: Value(checkinTimes),
      checkinStreakCount: Value(checkinStreakCount),
      isArchived: Value(isArchived),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      isLunar: Value(isLunar),
      repeatRule: Value(repeatRule),
      description: Value(description),
      picturePaths: Value(picturePaths),
      tags: Value(tags),
    );
  }

  factory EventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<int>(json['date']),
      nextEffectiveTime: serializer.fromJson<int>(json['nextEffectiveTime']),
      type: serializer.fromJson<String>(json['type']),
      priority: serializer.fromJson<String>(json['priority']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      checkinTimes: serializer.fromJson<String>(json['checkinTimes']),
      checkinStreakCount: serializer.fromJson<int>(json['checkinStreakCount']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      archivedAt: serializer.fromJson<int?>(json['archivedAt']),
      isLunar: serializer.fromJson<bool>(json['isLunar']),
      repeatRule: serializer.fromJson<String>(json['repeatRule']),
      description: serializer.fromJson<String>(json['description']),
      picturePaths: serializer.fromJson<String>(json['picturePaths']),
      tags: serializer.fromJson<String>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<int>(date),
      'nextEffectiveTime': serializer.toJson<int>(nextEffectiveTime),
      'type': serializer.toJson<String>(type),
      'priority': serializer.toJson<String>(priority),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isStarred': serializer.toJson<bool>(isStarred),
      'checkinTimes': serializer.toJson<String>(checkinTimes),
      'checkinStreakCount': serializer.toJson<int>(checkinStreakCount),
      'isArchived': serializer.toJson<bool>(isArchived),
      'archivedAt': serializer.toJson<int?>(archivedAt),
      'isLunar': serializer.toJson<bool>(isLunar),
      'repeatRule': serializer.toJson<String>(repeatRule),
      'description': serializer.toJson<String>(description),
      'picturePaths': serializer.toJson<String>(picturePaths),
      'tags': serializer.toJson<String>(tags),
    };
  }

  EventRow copyWith({
    String? id,
    String? name,
    int? date,
    int? nextEffectiveTime,
    String? type,
    String? priority,
    bool? isPinned,
    bool? isStarred,
    String? checkinTimes,
    int? checkinStreakCount,
    bool? isArchived,
    Value<int?> archivedAt = const Value.absent(),
    bool? isLunar,
    String? repeatRule,
    String? description,
    String? picturePaths,
    String? tags,
  }) => EventRow(
    id: id ?? this.id,
    name: name ?? this.name,
    date: date ?? this.date,
    nextEffectiveTime: nextEffectiveTime ?? this.nextEffectiveTime,
    type: type ?? this.type,
    priority: priority ?? this.priority,
    isPinned: isPinned ?? this.isPinned,
    isStarred: isStarred ?? this.isStarred,
    checkinTimes: checkinTimes ?? this.checkinTimes,
    checkinStreakCount: checkinStreakCount ?? this.checkinStreakCount,
    isArchived: isArchived ?? this.isArchived,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    isLunar: isLunar ?? this.isLunar,
    repeatRule: repeatRule ?? this.repeatRule,
    description: description ?? this.description,
    picturePaths: picturePaths ?? this.picturePaths,
    tags: tags ?? this.tags,
  );
  EventRow copyWithCompanion(EventsCompanion data) {
    return EventRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      nextEffectiveTime: data.nextEffectiveTime.present
          ? data.nextEffectiveTime.value
          : this.nextEffectiveTime,
      type: data.type.present ? data.type.value : this.type,
      priority: data.priority.present ? data.priority.value : this.priority,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isStarred: data.isStarred.present ? data.isStarred.value : this.isStarred,
      checkinTimes: data.checkinTimes.present
          ? data.checkinTimes.value
          : this.checkinTimes,
      checkinStreakCount: data.checkinStreakCount.present
          ? data.checkinStreakCount.value
          : this.checkinStreakCount,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      isLunar: data.isLunar.present ? data.isLunar.value : this.isLunar,
      repeatRule: data.repeatRule.present
          ? data.repeatRule.value
          : this.repeatRule,
      description: data.description.present
          ? data.description.value
          : this.description,
      picturePaths: data.picturePaths.present
          ? data.picturePaths.value
          : this.picturePaths,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('nextEffectiveTime: $nextEffectiveTime, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('isPinned: $isPinned, ')
          ..write('isStarred: $isStarred, ')
          ..write('checkinTimes: $checkinTimes, ')
          ..write('checkinStreakCount: $checkinStreakCount, ')
          ..write('isArchived: $isArchived, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('isLunar: $isLunar, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('description: $description, ')
          ..write('picturePaths: $picturePaths, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    date,
    nextEffectiveTime,
    type,
    priority,
    isPinned,
    isStarred,
    checkinTimes,
    checkinStreakCount,
    isArchived,
    archivedAt,
    isLunar,
    repeatRule,
    description,
    picturePaths,
    tags,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.date == this.date &&
          other.nextEffectiveTime == this.nextEffectiveTime &&
          other.type == this.type &&
          other.priority == this.priority &&
          other.isPinned == this.isPinned &&
          other.isStarred == this.isStarred &&
          other.checkinTimes == this.checkinTimes &&
          other.checkinStreakCount == this.checkinStreakCount &&
          other.isArchived == this.isArchived &&
          other.archivedAt == this.archivedAt &&
          other.isLunar == this.isLunar &&
          other.repeatRule == this.repeatRule &&
          other.description == this.description &&
          other.picturePaths == this.picturePaths &&
          other.tags == this.tags);
}

class EventsCompanion extends UpdateCompanion<EventRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> date;
  final Value<int> nextEffectiveTime;
  final Value<String> type;
  final Value<String> priority;
  final Value<bool> isPinned;
  final Value<bool> isStarred;
  final Value<String> checkinTimes;
  final Value<int> checkinStreakCount;
  final Value<bool> isArchived;
  final Value<int?> archivedAt;
  final Value<bool> isLunar;
  final Value<String> repeatRule;
  final Value<String> description;
  final Value<String> picturePaths;
  final Value<String> tags;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.nextEffectiveTime = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.checkinTimes = const Value.absent(),
    this.checkinStreakCount = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.isLunar = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.description = const Value.absent(),
    this.picturePaths = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String name,
    required int date,
    required int nextEffectiveTime,
    required String type,
    required String priority,
    this.isPinned = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.checkinTimes = const Value.absent(),
    this.checkinStreakCount = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.isLunar = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.description = const Value.absent(),
    this.picturePaths = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       date = Value(date),
       nextEffectiveTime = Value(nextEffectiveTime),
       type = Value(type),
       priority = Value(priority);
  static Insertable<EventRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? date,
    Expression<int>? nextEffectiveTime,
    Expression<String>? type,
    Expression<String>? priority,
    Expression<bool>? isPinned,
    Expression<bool>? isStarred,
    Expression<String>? checkinTimes,
    Expression<int>? checkinStreakCount,
    Expression<bool>? isArchived,
    Expression<int>? archivedAt,
    Expression<bool>? isLunar,
    Expression<String>? repeatRule,
    Expression<String>? description,
    Expression<String>? picturePaths,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (nextEffectiveTime != null) 'next_effective_time': nextEffectiveTime,
      if (type != null) 'type': type,
      if (priority != null) 'priority': priority,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isStarred != null) 'is_starred': isStarred,
      if (checkinTimes != null) 'checkin_times': checkinTimes,
      if (checkinStreakCount != null)
        'checkin_streak_count': checkinStreakCount,
      if (isArchived != null) 'is_archived': isArchived,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (isLunar != null) 'is_lunar': isLunar,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (description != null) 'description': description,
      if (picturePaths != null) 'picture_paths': picturePaths,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? date,
    Value<int>? nextEffectiveTime,
    Value<String>? type,
    Value<String>? priority,
    Value<bool>? isPinned,
    Value<bool>? isStarred,
    Value<String>? checkinTimes,
    Value<int>? checkinStreakCount,
    Value<bool>? isArchived,
    Value<int?>? archivedAt,
    Value<bool>? isLunar,
    Value<String>? repeatRule,
    Value<String>? description,
    Value<String>? picturePaths,
    Value<String>? tags,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      nextEffectiveTime: nextEffectiveTime ?? this.nextEffectiveTime,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isPinned: isPinned ?? this.isPinned,
      isStarred: isStarred ?? this.isStarred,
      checkinTimes: checkinTimes ?? this.checkinTimes,
      checkinStreakCount: checkinStreakCount ?? this.checkinStreakCount,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
      isLunar: isLunar ?? this.isLunar,
      repeatRule: repeatRule ?? this.repeatRule,
      description: description ?? this.description,
      picturePaths: picturePaths ?? this.picturePaths,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (nextEffectiveTime.present) {
      map['next_effective_time'] = Variable<int>(nextEffectiveTime.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isStarred.present) {
      map['is_starred'] = Variable<bool>(isStarred.value);
    }
    if (checkinTimes.present) {
      map['checkin_times'] = Variable<String>(checkinTimes.value);
    }
    if (checkinStreakCount.present) {
      map['checkin_streak_count'] = Variable<int>(checkinStreakCount.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(archivedAt.value);
    }
    if (isLunar.present) {
      map['is_lunar'] = Variable<bool>(isLunar.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (picturePaths.present) {
      map['picture_paths'] = Variable<String>(picturePaths.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('nextEffectiveTime: $nextEffectiveTime, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('isPinned: $isPinned, ')
          ..write('isStarred: $isStarred, ')
          ..write('checkinTimes: $checkinTimes, ')
          ..write('checkinStreakCount: $checkinStreakCount, ')
          ..write('isArchived: $isArchived, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('isLunar: $isLunar, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('description: $description, ')
          ..write('picturePaths: $picturePaths, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventsTable events = $EventsTable(this);
  late final EventDao eventDao = EventDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events];
}

typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required String name,
      required int date,
      required int nextEffectiveTime,
      required String type,
      required String priority,
      Value<bool> isPinned,
      Value<bool> isStarred,
      Value<String> checkinTimes,
      Value<int> checkinStreakCount,
      Value<bool> isArchived,
      Value<int?> archivedAt,
      Value<bool> isLunar,
      Value<String> repeatRule,
      Value<String> description,
      Value<String> picturePaths,
      Value<String> tags,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> date,
      Value<int> nextEffectiveTime,
      Value<String> type,
      Value<String> priority,
      Value<bool> isPinned,
      Value<bool> isStarred,
      Value<String> checkinTimes,
      Value<int> checkinStreakCount,
      Value<bool> isArchived,
      Value<int?> archivedAt,
      Value<bool> isLunar,
      Value<String> repeatRule,
      Value<String> description,
      Value<String> picturePaths,
      Value<String> tags,
      Value<int> rowid,
    });

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextEffectiveTime => $composableBuilder(
    column: $table.nextEffectiveTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkinTimes => $composableBuilder(
    column: $table.checkinTimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkinStreakCount => $composableBuilder(
    column: $table.checkinStreakCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLunar => $composableBuilder(
    column: $table.isLunar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get picturePaths => $composableBuilder(
    column: $table.picturePaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextEffectiveTime => $composableBuilder(
    column: $table.nextEffectiveTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkinTimes => $composableBuilder(
    column: $table.checkinTimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkinStreakCount => $composableBuilder(
    column: $table.checkinStreakCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLunar => $composableBuilder(
    column: $table.isLunar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get picturePaths => $composableBuilder(
    column: $table.picturePaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get nextEffectiveTime => $composableBuilder(
    column: $table.nextEffectiveTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isStarred =>
      $composableBuilder(column: $table.isStarred, builder: (column) => column);

  GeneratedColumn<String> get checkinTimes => $composableBuilder(
    column: $table.checkinTimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get checkinStreakCount => $composableBuilder(
    column: $table.checkinStreakCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLunar =>
      $composableBuilder(column: $table.isLunar, builder: (column) => column);

  GeneratedColumn<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get picturePaths => $composableBuilder(
    column: $table.picturePaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          EventRow,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
          EventRow,
          PrefetchHooks Function()
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> nextEffectiveTime = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<String> checkinTimes = const Value.absent(),
                Value<int> checkinStreakCount = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int?> archivedAt = const Value.absent(),
                Value<bool> isLunar = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> picturePaths = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                name: name,
                date: date,
                nextEffectiveTime: nextEffectiveTime,
                type: type,
                priority: priority,
                isPinned: isPinned,
                isStarred: isStarred,
                checkinTimes: checkinTimes,
                checkinStreakCount: checkinStreakCount,
                isArchived: isArchived,
                archivedAt: archivedAt,
                isLunar: isLunar,
                repeatRule: repeatRule,
                description: description,
                picturePaths: picturePaths,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int date,
                required int nextEffectiveTime,
                required String type,
                required String priority,
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<String> checkinTimes = const Value.absent(),
                Value<int> checkinStreakCount = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int?> archivedAt = const Value.absent(),
                Value<bool> isLunar = const Value.absent(),
                Value<String> repeatRule = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> picturePaths = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                name: name,
                date: date,
                nextEffectiveTime: nextEffectiveTime,
                type: type,
                priority: priority,
                isPinned: isPinned,
                isStarred: isStarred,
                checkinTimes: checkinTimes,
                checkinStreakCount: checkinStreakCount,
                isArchived: isArchived,
                archivedAt: archivedAt,
                isLunar: isLunar,
                repeatRule: repeatRule,
                description: description,
                picturePaths: picturePaths,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      EventRow,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (EventRow, BaseReferences<_$AppDatabase, $EventsTable, EventRow>),
      EventRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
}
