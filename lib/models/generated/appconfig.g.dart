// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../appconfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
  notificationDndOn: json['notificationDndOn'] as bool? ?? false,
  notificationDigestOn: json['notificationDigestOn'] as bool? ?? false,
  notificationStartHour: (json['notificationStartHour'] as num?)?.toInt() ?? 22,
  notificationStartMinute:
      (json['notificationStartMinute'] as num?)?.toInt() ?? 0,
  notificationEndHour: (json['notificationEndHour'] as num?)?.toInt() ?? 7,
  notificationEndMinute: (json['notificationEndMinute'] as num?)?.toInt() ?? 0,
  notificationDigestTime:
      json['notificationDigestTime'] as String? ?? 'evening',
  notificationDndDays:
      (json['notificationDndDays'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList() ??
      const [false, false, false, false, false, false, false],
);

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'notificationDndOn': instance.notificationDndOn,
      'notificationDigestOn': instance.notificationDigestOn,
      'notificationStartHour': instance.notificationStartHour,
      'notificationStartMinute': instance.notificationStartMinute,
      'notificationEndHour': instance.notificationEndHour,
      'notificationEndMinute': instance.notificationEndMinute,
      'notificationDigestTime': instance.notificationDigestTime,
      'notificationDndDays': instance.notificationDndDays,
    };
