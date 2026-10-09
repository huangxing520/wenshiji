import 'package:flutter/material.dart';
import 'package:wenshiji/screens/add_event.dart';

/// 新增/编辑事件页的「生日 / 事项 / 节日」模式切换条。
///
/// 纯展示组件：当前模式由 [currentMode] 传入，切换通过 [onModeChanged] 回调，
/// 自身不保存状态，便于从原页面解耦与复用。
class ModeTabs extends StatelessWidget {
  const ModeTabs({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
    required this.accentSoftColor,
    required this.accentColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final AddEventMode currentMode;
  final ValueChanged<AddEventMode> onModeChanged;
  final Color accentSoftColor;
  final Color accentColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: accentSoftColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            alignment: switch (currentMode) {
              AddEventMode.birthday => Alignment.centerLeft,
              AddEventMode.task => Alignment.center,
              AddEventMode.holiday => Alignment.centerRight,
            },
            child: FractionallySizedBox(
              widthFactor: 1.0 / 3,
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _tab(
                emoji: '🎂',
                label: '生日模式',
                mode: AddEventMode.birthday,
              ),
              _tab(
                emoji: '📌',
                label: '普通事项',
                mode: AddEventMode.task,
              ),
              _tab(
                emoji: '🎉',
                label: '节日模式',
                mode: AddEventMode.holiday,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String emoji,
    required String label,
    required AddEventMode mode,
  }) {
    final isActive = currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChanged(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Text(
              '$emoji $label',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color: isActive ? fgColor : mutedColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
