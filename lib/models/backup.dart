import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wenshiji/models/appconfig.dart';
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
    required String username,
    required String password,
    required String backupDirectory,
    required String size,
    required int eventCount,
  }) = _BackupRecord;
  factory BackupRecord.fromJson(Map<String, Object?> json) =>
      _$BackupRecordFromJson(json);
}
@freezed
abstract class BackupData with _$BackupData {
  const factory BackupData({
    required AppConfig appConfig,

  }) = _BackupData;
  factory BackupData.fromJson(Map<String, Object?> json) =>
      _$BackupDataFromJson(json);
}