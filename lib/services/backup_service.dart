// 备份服务层：负责本地备份文件的读写与记录管理。
// 从 screens/backup.dart 抽离，解决 provider 依赖 UI 层的层级倒置问题。
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/common/secure_storage.dart';
import 'package:wenshiji/models/backup.dart';
import 'package:wenshiji/services/webdav_service.dart';

class BackupService {
  static final BackupService instance = BackupService._internal();
  factory BackupService() => instance;
  BackupService._internal();

  /// 备份文件存放目录名。
  static const _backupDirName = 'backup';

  Future<Directory> _backupDir() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return Directory(path.join(appDocDir.path, _backupDirName));
  }

  /// 获取本地备份记录列表（按文件解析）。
  Future<List<BackupRecord>> getBackupRecords() async {
    final backupDir = await _backupDir();
    if (!await backupDir.exists()) {
      return [];
    }

    // 匹配 yyyy-MM-dd-HH-mm-ss，或带旧版 -数字 后缀的文件名
    // （历史备份名为 `…-10`，需继续识别以免升级后旧备份消失）。
    final fileNameReg = RegExp(r'^\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}(-\d+)?$');

    final List<FileSystemEntity> files = await backupDir
        .list(recursive: false)
        .where((entity) => entity is File)
        .where((entity) {
          final fileName = path.basename(entity.path);
          return fileNameReg.hasMatch(fileName);
        })
        .toList();

    AppLogger().debug('筛选后的合法备份文件: ${files.length} 个');

    // 当前配置的 serverUrl（凭据不再存入记录）
    final serverUrl = await SecureStorage().getServerUrl();

    final recordFutures = files.map((e) async {
      final fileName = path.basename(e.path);
      try {
        final FileStat stat = await e.stat();
        final fileSize = stat.size.toString();
        final modifyTime = stat.modified;

        final localFile = File(path.join(
          (await _backupDir()).path,
          fileName,
        ));
        final fileExists = await localFile.exists();
        String fileContent = '';
        if (fileExists) {
          fileContent = await localFile.readAsString();
        }
        AppLogger().debug(
          '📄 文件: $fileName, 存在: $fileExists, 内容长度: ${fileContent.length}',
        );

        final fileContentMap = jsonDecode(fileContent) as Map<String, dynamic>;
        final backupData = BackupData.fromJson(fileContentMap);

        return BackupRecord(
          serverUrl: serverUrl,
          backupDirectory: backupData.appConfig.backupDirectory,
          id: fileName,
          fileName: fileName,
          size: fileSize,
          timeStr: modifyTime.toString(),
          eventCount: backupData.events.length,
        );
      } catch (err) {
        // 单个备份文件损坏 / 被截断时跳过，不拖垮整个列表。
        AppLogger().error('备份文件解析失败，已跳过: $fileName', error: err);
        return null;
      }
    });

    final records = await Future.wait(recordFutures);
    return records.whereType<BackupRecord>().toList();
  }

  /// 读取并解析本地某个备份文件为 [BackupData]。
  /// 文件不存在 / 内容损坏时抛出异常，由调用方提示用户。
  Future<BackupData> readLocalBackup(String fileName) async {
    final backupDir = await _backupDir();
    final file = File(path.join(backupDir.path, path.basename(fileName)));
    if (!await file.exists()) {
      throw StateError('备份文件不存在: $fileName');
    }
    final content = await file.readAsString();
    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('备份文件格式不正确');
    }
    return BackupData.fromJson(decoded);
  }

  /// 读取并解析任意路径的备份文件（用于刚落地的临时文件）。
  Future<BackupData> readBackupFileAt(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw StateError('备份文件不存在: $filePath');
    }
    final content = await file.readAsString();
    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('备份文件格式不正确');
    }
    return BackupData.fromJson(decoded);
  }

  /// 原子写入本地备份文件：先写临时文件，成功后 rename 覆盖目标，
  /// 避免写入中途被杀留下半截文件。
  Future<File> writeLocalBackupAtomically({
    required String fileName,
    required String content,
  }) async {
    final backupDir = await _backupDir();
    await backupDir.create(recursive: true);
    final safeName = path.basename(fileName);
    final target = File(path.join(backupDir.path, safeName));
    final tmp = File('${target.path}.tmp');
    await tmp.writeAsString(content, flush: true);
    // rename 在同一文件系统上是原子替换。
    return tmp.rename(target.path);
  }

  /// 删除本地备份文件。
  Future<void> deleteBackupFile(String id) async {
    final backupDir = await _backupDir();
    final file = File(path.join(backupDir.path, id));
    if (await file.exists()) {
      await file.delete();
    }
  }

  // ==================== WebDAV 编排 ====================

  /// 上传本地备份文件到远端，并刷新本地缓存（重新拉取远端列表）。
  /// 调用前需自行创建本地文件并写入内容；mkdirAll 由调用方负责（便于独立提示错误）。
  Future<void> uploadBackupAndRefreshLocal({
    required String localFilePath,
    required String remoteDir,
    required WebdavService webdav,
  }) async {
    final fileName = path.basename(localFilePath);
    final remotePath = '$remoteDir/$fileName';
    await webdav.uploadFile(localFilePath, remotePath);
    await _refreshLocalCacheFromRemote(remoteDir: remoteDir, webdav: webdav);
  }

  /// 删除远端备份文件，并刷新本地缓存。
  Future<void> deleteRemoteBackupAndRefreshLocal({
    required String remoteDir,
    required String fileName,
    required WebdavService webdav,
  }) async {
    final remotePath = '$remoteDir/$fileName';
    await webdav.remove(remotePath);
    await _refreshLocalCacheFromRemote(remoteDir: remoteDir, webdav: webdav);
  }

  /// 从远端下载指定备份文件到本地临时路径并返回该路径（不清空缓存目录）。
  /// 供「从某条记录恢复」使用：只取目标文件，避免整目录重下。
  Future<String> downloadRemoteBackupToTemp({
    required String remoteDir,
    required String fileName,
    required WebdavService webdav,
  }) async {
    final safeName = path.basename(fileName);
    final tmpDir = await getTemporaryDirectory();
    final localPath = path.join(tmpDir.path, 'restore_$safeName');
    final remotePath = remoteDir.endsWith('/')
        ? '$remoteDir$safeName'
        : '$remoteDir/$safeName';
    await webdav.downloadFile(remotePath, localPath);
    return localPath;
  }

  /// 重新从远端拉取备份列表到本地缓存目录。
  ///
  /// 实现要点（修复此前「先清空再逐条下载」导致失败即丢缓存的问题）：
  /// 1. 先下载到临时目录，全部成功后再替换正式缓存目录 —— 失败保持旧缓存不变；
  /// 2. 过滤目录项（PROPFIND 可能返回集合自身）；
  /// 3. 远端文件名经 basename + 白名单校验，防止 `..` 路径穿越写到沙盒外。
  Future<void> _refreshLocalCacheFromRemote({
    required String remoteDir,
    required WebdavService webdav,
  }) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final localBackupRoot = path.join(appDocDir.path, _backupDirName);
    final tmpRoot = '$localBackupRoot.tmp';

    // 清理可能残留的临时目录，确保从干净状态开始。
    await _clearDir(tmpRoot);
    await Directory(tmpRoot).create(recursive: true);

    final files = await webdav.readDir(remoteDir);
    final fileNameReg = RegExp(r'^[\w\-.]+$');
    for (final e in files) {
      // 跳过目录（含 PROPFIND 返回的集合自身）与非法文件名。
      if (e.isDir) continue;
      final name = path.basename(e.name);
      if (!fileNameReg.hasMatch(name) || name.contains('..')) {
        AppLogger().warning('跳过可疑的备份文件名: ${e.name}');
        continue;
      }
      final remotePath = remoteDir.endsWith('/')
          ? '$remoteDir$name'
          : '$remoteDir/$name';
      final localPath = path.join(tmpRoot, name);
      await webdav.downloadFile(remotePath, localPath);
    }

    // 全部下载成功后再原子替换：先删旧目录，再把临时目录改名过去。
    await _clearDir(localBackupRoot);
    final tmpDir = Directory(tmpRoot);
    if (await tmpDir.exists()) {
      await tmpDir.rename(localBackupRoot);
    }
  }

  /// 清空本地目录（递归删除，不存在或失败均不抛异常）。
  Future<void> _clearDir(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      AppLogger().debug('清空目录失败: $dirPath, $e');
    }
  }
}
