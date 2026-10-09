// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupRecord _$BackupRecordFromJson(Map<String, dynamic> json) =>
    _BackupRecord(
      id: json['id'] as String,
      timeStr: json['timeStr'] as String,
      fileName: json['fileName'] as String,
      serverUrl: json['serverUrl'] as String,
      backupDirectory: json['backupDirectory'] as String,
      size: json['size'] as String,
      eventCount: (json['eventCount'] as num).toInt(),
    );

Map<String, dynamic> _$BackupRecordToJson(_BackupRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeStr': instance.timeStr,
      'fileName': instance.fileName,
      'serverUrl': instance.serverUrl,
      'backupDirectory': instance.backupDirectory,
      'size': instance.size,
      'eventCount': instance.eventCount,
    };

_BackupData _$BackupDataFromJson(Map<String, dynamic> json) => _BackupData(
  version: (json['version'] as num?)?.toInt() ?? 1,
  exportedAt: json['exportedAt'] == null
      ? null
      : DateTime.parse(json['exportedAt'] as String),
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Event>[],
  appConfig: AppConfig.fromJson(json['appConfig'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BackupDataToJson(_BackupData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'exportedAt': instance.exportedAt?.toIso8601String(),
      'events': instance.events,
      'appConfig': instance.appConfig,
    };
