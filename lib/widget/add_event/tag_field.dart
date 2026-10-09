import 'package:flutter/material.dart';
import 'package:wenshiji/theme/app_colors.dart';

/// 分类标签多选区。
///
/// 纯展示：候选标签由 [tags] 传入、已选集合由 [selectedTags] 传入，
/// 增删通过 [onToggle] 回调。
class TagField extends StatelessWidget {
  const TagField({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onToggle,
    required this.surfaceColor,
    required this.accentSoftColor,
    required this.accentDeepColor,
    required this.borderColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final List<String> tags;
  final Set<String> selectedTags;
  final ValueChanged<String> onToggle;
  final Color surfaceColor;
  final Color accentSoftColor;
  final Color accentDeepColor;
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
            '分类标签',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: tags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return GestureDetector(
                onTap: () => onToggle(tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : borderColor,
                      width: 1.5,
                    ),
                    color: isSelected ? accentSoftColor : surfaceColor,
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? accentDeepColor : mutedColor,
                    ),
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
