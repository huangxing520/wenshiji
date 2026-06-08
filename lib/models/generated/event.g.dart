// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['id'] as String,
  name: json['name'] as String,
  date: DateTime.parse(json['date'] as String),
  nextEffectiveTime: DateTime.parse(json['nextEffectiveTime'] as String),
  type: $enumDecode(_$EventTypeEnumMap, json['type']),
  priority:
      $enumDecodeNullable(_$EventPriorityEnumMap, json['priority']) ??
      EventPriority.mid,
  isPinned: json['isPinned'] as bool? ?? false,
  isStarred: json['isStarred'] as bool? ?? false,
  checkinTimes:
      (json['checkinTimes'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ??
      const [],
  checkinStreakCount: (json['checkinStreakCount'] as num?)?.toInt() ?? 0,
  isArchived: json['isArchived'] as bool? ?? false,
  repeatRule:
      $enumDecodeNullable(_$RepeatRuleEnumMap, json['repeatRule']) ??
      RepeatRule.none,
  description: json['description'] as String? ?? '',
  picturePaths:
      (json['picturePaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'date': instance.date.toIso8601String(),
  'nextEffectiveTime': instance.nextEffectiveTime.toIso8601String(),
  'type': _$EventTypeEnumMap[instance.type]!,
  'priority': _$EventPriorityEnumMap[instance.priority]!,
  'isPinned': instance.isPinned,
  'isStarred': instance.isStarred,
  'checkinTimes': instance.checkinTimes
      .map((e) => e.toIso8601String())
      .toList(),
  'checkinStreakCount': instance.checkinStreakCount,
  'isArchived': instance.isArchived,
  'repeatRule': _$RepeatRuleEnumMap[instance.repeatRule]!,
  'description': instance.description,
  'picturePaths': instance.picturePaths,
  'tags': instance.tags,
};

const _$EventTypeEnumMap = {
  EventType.birthday: 0,
  EventType.task: 1,
  EventType.dailySignIn: 2,
  EventType.holiday: 3,
};

const _$EventPriorityEnumMap = {
  EventPriority.high: 0,
  EventPriority.mid: 1,
  EventPriority.low: 2,
  EventPriority.special: 3,
};

const _$RepeatRuleEnumMap = {
  RepeatRule.none: 0,
  RepeatRule.daily: 1,
  RepeatRule.weekly: 2,
  RepeatRule.monthly: 3,
  RepeatRule.yearly: 4,
};
