import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenshiji/models/backup.dart';
import 'package:wenshiji/screens/backup.dart';
part 'generated/backup.g.dart';

@Riverpod(keepAlive: true)
class BackupNotifier extends _$BackupNotifier {
  // 本地存储的 Key
  static const _storageKey = 'backup_data';

  /// 1. 初始化：从本地加载数据（没有则用默认值）
  @override
  Future<List<BackupRecord>> build() async {
    return await  getBackupRecords(); // 启动时读取本地数据
  }

  // ====================== 【自动加载本地数据】 ======================
  Future<List<BackupRecord>> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final records = jsonList
          .map((e) => BackupRecord.fromJson(e as Map<String, dynamic>))
          .toList();

      return records;
    }
    return [
      BackupRecord(
        id: '1',
        timeStr: '2025-07-14 08:30',
        size: '12.6 KB',
        eventCount: 12,
        fileName: 'backup_20250714_0830.json',
        serverUrl: 'https://webdav.example.com',
        username: 'user',
        password: 'pass',
        backupDirectory: '/backup',
      ),
      BackupRecord(
        id: '2',
        timeStr: '2025-07-10 22:15',
        size: '11.8 KB',
        eventCount: 11,
        fileName: 'backup_20250710_2215.json',
        serverUrl: 'https://webdav.example.com',
        username: 'user',
        password: 'pass',
        backupDirectory: '/backup',
      ),
      BackupRecord(
        id: '3',
        timeStr: '2025-07-07 09:00',
        size: '10.2 KB',
        eventCount: 10,
        fileName: 'backup_20250707_0900.json',
        serverUrl: 'https://webdav.example.com',
        username: 'user',
        password: 'pass',
        backupDirectory: '/backup',
      ),
    ];
  }

  // ====================== 【自动保存到本地】 ======================
  Future<void> _saveToLocal(List<BackupRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(records);
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> deleteBackupRecord(String id) async {
    final records = state.requireValue;
    final newRecords = List<BackupRecord>.from(records);
    final index = newRecords.indexWhere((element) => element.id == id);
    if (index != -1) {
      newRecords.removeAt(index);
    }
    state = AsyncData(newRecords);
    await _saveToLocal(newRecords);
  }

  Future<void> setBackupRecords(List<BackupRecord> records) async {
    state = AsyncData(records);
    _saveToLocal(records);
  }
}

