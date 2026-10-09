import 'package:flutter/material.dart';
import 'package:wenshiji/theme/app_colors.dart';

/// 底部保存按钮。
///
/// [enabled] 为 false 时置灰且不可点击（保存中或表单未填完整）。
class SaveBar extends StatelessWidget {
  const SaveBar({
    super.key,
    required this.enabled,
    required this.saving,
    required this.isEditing,
    required this.onSave,
    required this.accentColor,
  });

  final bool enabled;
  final bool saving;
  final bool isEditing;
  final VoidCallback onSave;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E0D2))),
      ),
      child: GestureDetector(
        // 保存中禁用点击，避免重入产生重复事件。
        onTap: (enabled && !saving) ? onSave : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: enabled ? accentColor : const Color(0xFFE8E3D3),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              saving ? '保存中…' : (isEditing ? '保存修改' : '保存事件'),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: enabled
                    ? const Color(0xFF2A2822)
                    : const Color(0xFF8B8066),
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 保存成功后的全屏提示弹层。
class SuccessOverlay extends StatelessWidget {
  const SuccessOverlay({
    super.key,
    required this.isEditing,
    required this.onClose,
    required this.surfaceColor,
    required this.accentSoftColor,
    required this.accentDeepColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final bool isEditing;
  final VoidCallback onClose;
  final Color surfaceColor;
  final Color accentSoftColor;
  final Color accentDeepColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000000).withValues(alpha: 0.5),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          width: 280,
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentSoftColor,
                ),
                child: Icon(Icons.check, color: accentDeepColor, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                isEditing ? '修改已保存' : '保存成功',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: fgColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isEditing ? '事件修改已生效' : '事件已添加到你的提醒列表',
                style: TextStyle(fontSize: 14, color: mutedColor, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primary,
                  ),
                  child: const Text(
                    '好的',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A2822),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
