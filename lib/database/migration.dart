// 一次性迁移：将旧 SharedPreferences 中的 events 全量 JSON 迁入 Drift。
// 幂等：成功后写入迁移完成标记并清除旧 key，下次启动直接跳过。
// 失败不标记，下次启动重试。
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/database/wenshiji_database.dart';
import 'package:wenshiji/models/event.dart';

const _kMigrationDoneKey = 'drift_events_migration_done';

Future<void> migrateEventsFromPrefs(AppDatabase db) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_kMigrationDoneKey) == true) return; // 幂等

  final raw = prefs.getString('events');
  if (raw != null && raw.isNotEmpty) {
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final events = list
          .map((j) => Event.fromJson(j as Map<String, dynamic>))
          .toList();
      // 批量写入（单事务）：避免逐条 await 造成 N 次 fsync，也保证要么全成功要么全回滚。
      await db.eventDao.upsertEvents(events);
      AppLogger().info('Drift 迁移完成：导入 ${events.length} 条事件');
    } catch (e, s) {
      // 不标记完成，下次启动重试（旧 key 保留，重试时 upsert 幂等）。
      AppLogger().error('Drift 迁移失败', error: e, stack: s);
      return;
    }
  }
  await prefs.setBool(_kMigrationDoneKey, true);
  await prefs.remove('events'); // 清除旧 key
}
