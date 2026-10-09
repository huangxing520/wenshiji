import 'package:flutter/material.dart';

/// 计时模式选择：倒计时 / 连签计时。
///
/// 纯展示：[isCountdown] 传入当前选择，[onChanged] 回调切换结果。
class TimerField extends StatelessWidget {
  const TimerField({
    super.key,
    required this.isCountdown,
    required this.onChanged,
    required this.surfaceColor,
    required this.accentColor,
    required this.borderColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final bool isCountdown;
  final ValueChanged<bool> onChanged;
  final Color surfaceColor;
  final Color accentColor;
  final Color borderColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '计时模式（连签计时模式可以记录连续签到的天数）',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _option(
                  emoji: '⏳',
                  label: '倒计时',
                  selected: isCountdown,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _option(
                  emoji: '📈',
                  label: '连签计时',
                  selected: !isCountdown,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _option({
    required String emoji,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: selected
            ? Matrix4.identity().scaledByDouble(1.03, 1.03, 1.0, 1.0)
            : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? accentColor : borderColor,
            width: 1.5,
          ),
          color: selected ? accentColor : surfaceColor,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? fgColor : mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
