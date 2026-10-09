import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/models/backup.dart';

/// 备份记录卡片：时间、大小、事件数，以及恢复/删除操作。
///
/// 纯展示：恢复中状态由 [restoringId] 判断（等于本条 id 时显示「恢复中…」
/// 且禁用其他条目的恢复按钮），操作通过回调触发。
class BackupRecordCard extends StatelessWidget {
  const BackupRecordCard({
    super.key,
    required this.record,
    required this.restoringId,
    required this.onRestore,
    required this.onDelete,
  });

  final BackupRecord record;
  final String? restoringId;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isRestoringThis = restoringId == record.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE0D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('yyyy-MM-dd hh:mm:ss').format(
              DateTime.parse(record.timeStr),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A3828),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _MetaItem(
                icon: Icons.description_outlined,
                text: Utils().bytesToKB(int.parse(record.size)),
              ),
              const SizedBox(width: 14),
              _MetaItem(
                icon: Icons.schedule_outlined,
                text: '${record.eventCount} 条事件',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _RecordButton(
                text: isRestoringThis ? '恢复中…' : '恢复',
                color: const Color(0xFFFFF0D3),
                textColor: const Color(0xFFC78A17),
                onTap: restoringId == null ? onRestore : null,
              ),
              const SizedBox(width: 8),
              _RecordButton(
                text: '删除',
                color: const Color(0xFFF5F0E8),
                textColor: const Color(0xFF9E8870),
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF9E8870)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9E8870)),
        ),
      ],
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton({
    required this.text,
    required this.color,
    required this.textColor,
    this.onTap,
  });

  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
