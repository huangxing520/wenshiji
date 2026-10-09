import 'package:flutter/material.dart';

/// 统计概览的四宫格卡片。
///
/// 纯展示：各项数值由 [stats] 传入（键：total / starCount / pending /
/// soon / done / monthDone / birthdays / bdayLeft），颜色由外部传入。
class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.stats,
    required this.accentSoft,
    required this.cardColor,
    required this.borderColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final Map<String, dynamic> stats;
  final Color accentSoft;
  final Color cardColor;
  final Color borderColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.0,
      children: [
        _StatCard(
          icon: '📊',
          number: stats['total'] as int? ?? 0,
          label: '全部事件',
          subLabel: '含标星事件 ${stats['starCount']} 项',
          bgColor: accentSoft,
          cardColor: cardColor,
          borderColor: borderColor,
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        _StatCard(
          icon: '⏳',
          number: stats['pending'] as int? ?? 0,
          label: '待完成事件',
          subLabel: '近7天到期 ${stats['soon']} 项',
          bgColor: const Color(0xFFE8F5E8),
          cardColor: cardColor,
          borderColor: borderColor,
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        _StatCard(
          icon: '✅',
          number: stats['done'] as int? ?? 0,
          label: '已完成/归档',
          subLabel: '本月归档 ${stats['monthDone']} 项',
          bgColor: const Color(0xFFE3F2FD),
          cardColor: cardColor,
          borderColor: borderColor,
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        _StatCard(
          icon: '🎂',
          number: stats['birthdays'] as int? ?? 0,
          label: '生日数',
          subLabel: '本年度还有 ${stats['bdayLeft']} 人待过生日',
          bgColor: const Color(0xFFFFEBEE),
          cardColor: cardColor,
          borderColor: borderColor,
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.number,
    required this.label,
    required this.subLabel,
    required this.bgColor,
    required this.cardColor,
    required this.borderColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final String icon;
  final int number;
  final String label;
  final String subLabel;
  final Color bgColor;
  final Color cardColor;
  final Color borderColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: const Cubic(0.34, 1.56, 0.64, 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value.clamp(0, 1), child: child),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: number),
                    duration: const Duration(milliseconds: 600),
                    curve: const Cubic(0.34, 1.56, 0.64, 1.0),
                    builder: (context, value, child) {
                      return Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: fgColor,
                          height: 1,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: fgColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subLabel,
                    style: TextStyle(fontSize: 11, color: mutedColor),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
