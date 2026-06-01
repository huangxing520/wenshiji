// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['id'] as String,
  name: json['name'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$EventTypeEnumMap, json['type']),
  priority:
      $enumDecodeNullable(_$EventPriorityEnumMap, json['priority']) ??
      EventPriority.mid,
  isPinned: json['isPinned'] as bool? ?? false,
  isStarred: json['isStarred'] as bool? ?? false,
  hasCheckin: json['hasCheckin'] as bool? ?? false,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  checkedToday: json['checkedToday'] as bool? ?? false,
  reminder:
      (json['reminder'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EventReminderEnumMap, e))
          .toList() ??
      const [EventReminder.none],
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
  'type': _$EventTypeEnumMap[instance.type]!,
  'priority': _$EventPriorityEnumMap[instance.priority]!,
  'isPinned': instance.isPinned,
  'isStarred': instance.isStarred,
  'hasCheckin': instance.hasCheckin,
  'streak': instance.streak,
  'checkedToday': instance.checkedToday,
  'reminder': instance.reminder.map((e) => _$EventReminderEnumMap[e]!).toList(),
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

const _$EventReminderEnumMap = {
  EventReminder.none: 0,
  EventReminder.daily: 1,
  EventReminder.weekly: 2,
  EventReminder.threeDays: 3,
  EventReminder.sevenDays: 4,
  EventReminder.fifteenDays: 5,
  EventReminder.thirtyDays: 6,
  EventReminder.oneHour: 7,
};
