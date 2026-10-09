import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wenshiji/models/appconfig.dart';
import 'package:wenshiji/models/event.dart';
part 'generated/backup.freezed.dart';
part 'generated/backup.g.dart';
enum BackupStatus { success, failed }

@freezed
abstract class BackupRecord with _$BackupRecord {
  const factory BackupRecord({
    required String id,
    required String timeStr,
    required String fileName,
    required String serverUrl,
    required String backupDirectory,
    required String size,
    required int eventCount,
  }) = _BackupRecord;
  factory BackupRecord.fromJson(Map<String, Object?> json) =>
      _$BackupRecordFromJson(json);
}

/// 备份载荷：包含恢复所需的全部数据。
///
/// - [version]：备份格式版本。1 = 仅 AppConfig（历史遗留，无事件）；2 = 含事件列表。
/// - [exportedAt]：导出时间；历史文件缺失，故可空。
/// - [events]：全部事件；历史文件缺失，默认空列表。
@freezed
abstract class BackupData with _$BackupData {
  const factory BackupData({
    @Default(1) int version,
    DateTime? exportedAt,
    @Default(<Event>[]) List<Event> events,
    required AppConfig appConfig,
  }) = _BackupData;
  factory BackupData.fromJson(Map<String, Object?> json) =>
      _$BackupDataFromJson(json);
}