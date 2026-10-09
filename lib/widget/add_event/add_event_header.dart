import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 新增/编辑事件页顶部导航（返回按钮 + 标题）。
///
/// 返回逻辑：能出栈则 pop（编辑场景来自详情页），否则回退首页。
class AddEventHeader extends StatelessWidget {
  const AddEventHeader({
    super.key,
    required this.isEditing,
    required this.accentSoftColor,
    required this.accentDeepColor,
    required this.fgColor,
  });

  final bool isEditing;
  final Color accentSoftColor;
  final Color accentDeepColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E0D2))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          GestureDetector(
            // 用 pop 返回上一页（编辑场景来自详情页），避免 go('/homepage') 丢弃整个导航栈。
            // 无栈可退（如深链直达）时回退到首页。
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/homepage');
              }
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentSoftColor,
              ),
              child: Icon(Icons.arrow_back, color: accentDeepColor, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isEditing ? '编辑事件' : '新增事件',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: fgColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// 顶部仿系统状态栏（时间 + 信号/电量图标）。
class EventStatusBar extends StatelessWidget {
  const EventStatusBar({super.key, required this.bgColor, required this.fgColor});

  final Color bgColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      height: 44,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, size: 16, color: fgColor),
              const SizedBox(width: 5),
              Icon(Icons.battery_full, size: 16, color: fgColor),
            ],
          ),
        ],
      ),
    );
  }
}
