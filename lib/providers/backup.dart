import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wenshiji/models/backup.dart';
import 'package:wenshiji/services/backup_service.dart';
part 'generated/backup.g.dart';

@Riverpod(keepAlive: true)
class BackupNotifier extends _$BackupNotifier {
  /// 初始化：从本地备份文件目录读取记录（source of truth = 文件系统）。
  @override
  Future<List<BackupRecord>> build() async {
    return await BackupService().getBackupRecords();
  }

  /// 删除一条备份记录：删除底层文件并刷新状态。
  Future<void> deleteBackupRecord(String id) async {
    await BackupService().deleteBackupFile(id);
    final records = await BackupService().getBackupRecords();
    state = AsyncData(records);
  }

  /// 设置备份记录列表（备份/恢复完成后调用以刷新状态）。
  Future<void> setBackupRecords(List<BackupRecord> records) async {
    state = AsyncData(records);
  }

  /// 重新从文件系统加载记录。
  Future<void> refresh() async {
    state = const AsyncLoading();
    // 用 guard 兜住异常：目录被删 / 权限被拒时不应永久停在 AsyncLoading。
    state = await AsyncValue.guard(() => BackupService().getBackupRecords());
  }
}
