import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wenshiji/models/event.dart';

/// 归档列表中的单条事件卡片：名称、类型标签、打卡信息、日期，
/// 以及右侧的恢复 / 删除操作。
///
/// 纯展示：类型标签文案由 [typeLabel] 传入（页面按 categoryTabs 映射），
/// 操作通过回调触发。
class ArchiveItemCard extends StatelessWidget {
  const ArchiveItemCard({
    super.key,
    required this.item,
    required this.typeLabel,
    required this.tagColor,
    required this.tagBgColor,
    required this.onOpenDetail,
    required this.onRestore,
    required this.onDelete,
  });

  final Event item;
  final String typeLabel;
  final Color tagColor;
  final Color tagBgColor;
  final VoidCallback onOpenDetail;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(61, 46, 30, 0.06),
            offset: Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onOpenDetail,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3D2E1E),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: tagBgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              typeLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: tagColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (item.type == EventType.dailySignIn) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Color(0xFF5A9E4F),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '累计打卡${item.checkinStreakCount}天',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5A9E4F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 3),
                      Text(
                        DateFormat('yyyy-MM-dd').format(item.date),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFB8A48A),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ArchiveActionButton(
                      text: '恢复',
                      bgColor: const Color(0xFFFFF1D6),
                      textColor: const Color(0xFFD4922E),
                      onTap: onRestore,
                    ),
                    const SizedBox(height: 6),
                    ArchiveActionButton(
                      text: '删除',
                      bgColor: const Color(0xFFFFF0F0),
                      textColor: const Color(0xFFE06060),
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 归档卡片右侧的小型操作按钮。
class ArchiveActionButton extends StatelessWidget {
  const ArchiveActionButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  final String text;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
