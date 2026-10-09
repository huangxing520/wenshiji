import 'package:flutter/material.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/theme/app_colors.dart';

/// 优先级选择：特级重要 / 重要 / 普通 / 次要。
///
/// 纯展示组件：当前值由 [current] 传入，选择结果通过 [onChanged] 回调。
class PriorityField extends StatelessWidget {
  const PriorityField({
    super.key,
    required this.current,
    required this.onChanged,
    required this.surfaceColor,
    required this.borderColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final EventPriority current;
  final ValueChanged<EventPriority> onChanged;
  final Color surfaceColor;
  final Color borderColor;
  final Color fgColor;
  final Color mutedColor;

  static const _priorities = [
    (EventPriority.special, '特级重要', Color(0xFFE64C3C)),
    (EventPriority.high, '重要', Color(0xFFE67E22)),
    (EventPriority.mid, '普通', AppColors.primary),
    (EventPriority.low, '次要', Color(0xFF27AE60)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '优先级',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _priorities.map((pri) {
              final isSelected = current == pri.$1;
              return GestureDetector(
                onTap: () => onChanged(pri.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  curve: Curves.easeOutCubic,
                  transform: isSelected
                      ? Matrix4.identity().scaledByDouble(1.04, 1.04, 1.0, 1.0)
                      : Matrix4.identity(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? pri.$3 : borderColor,
                      width: 2,
                    ),
                    color: isSelected
                        ? pri.$3.withValues(alpha: 0.1)
                        : surfaceColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pri.$3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pri.$2,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? pri.$3 : mutedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
