import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class commonNavigationBar extends StatelessWidget {
  const commonNavigationBar({
    super.key,
    required this.title,
    required this.surfaceColor,
    required this.borderColor,
    required this.fgColor,
    required this.icon,
  });

  final String title;
  final Color surfaceColor;
  final Color borderColor;
  final Color fgColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 0.5)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 图标在最左边
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(icon, color: fgColor, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          // 文本在整个容器中居中，但左右留有相同空间防止重叠
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32), // 数值≥图标宽度
            child: Text(
              title,
              style: TextStyle(
                color: fgColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
