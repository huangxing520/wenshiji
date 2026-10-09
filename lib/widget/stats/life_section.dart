import 'package:flutter/material.dart';
import 'package:wenshiji/theme/app_colors.dart';

/// 人生进度区块主体：百分比、进度条、四宫格统计。
///
/// 数值由 [lifeStats] 传入（键：pct / livedDays / remainDays /
/// yearLeft / age）。[config] 为出生日期等配置区，由调用方传入以保持
/// 其与页面状态的绑定。
class LifeBody extends StatelessWidget {
  const LifeBody({
    super.key,
    required this.lifeStats,
    required this.config,
    required this.accentColor,
    required this.accentDeepColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final Map<String, dynamic> lifeStats;
  final Widget config;
  final Color accentColor;
  final Color accentDeepColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final pct = lifeStats['pct'] as double? ?? 0.0;
    return Column(
      children: [
        const SizedBox(height: 16),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: pct),
          duration: const Duration(milliseconds: 700),
          curve: const Cubic(0.34, 1.56, 0.64, 1.0),
          builder: (context, value, child) {
            return Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: accentDeepColor,
                height: 1,
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          '今日人生进度',
          style: TextStyle(
            fontSize: 14,
            color: mutedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        LifeBar(
          pct: pct,
          accentColor: accentColor,
        ),
        const SizedBox(height: 18),
        LifeStatsGrid(
          lifeStats: lifeStats,
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        const SizedBox(height: 14),
        config,
      ],
    );
  }
}

/// 人生进度条。
class LifeBar extends StatelessWidget {
  const LifeBar({super.key, required this.pct, required this.accentColor});

  final double pct;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E4DC),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: pct / 100),
        duration: const Duration(milliseconds: 1200),
        curve: const Cubic(0.34, 1.56, 0.64, 1.0),
        builder: (context, value, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, AppColors.primary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 人生统计四宫格：已度过天数 / 剩余天数 / 本年剩余天 / 当前年龄。
class LifeStatsGrid extends StatelessWidget {
  const LifeStatsGrid({
    super.key,
    required this.lifeStats,
    required this.fgColor,
    required this.mutedColor,
  });

  final Map<String, dynamic> lifeStats;
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
      childAspectRatio: 1.0 / 0.65,
      children: [
        _LifeStat(
          value: lifeStats['livedDays'],
          label: '已度过天数',
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        _LifeStat(
          value: lifeStats['remainDays'],
          label: '剩余天数',
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        _LifeStat(
          value: lifeStats['yearLeft'],
          label: '本年剩余天',
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        _LifeStat(
          value: lifeStats['age'],
          label: '当前年龄',
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
      ],
    );
  }
}

class _LifeStat extends StatelessWidget {
  const _LifeStat({
    required this.value,
    required this.label,
    required this.fgColor,
    required this.mutedColor,
  });

  final dynamic value;
  final String label;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value is int
                  ? value.toString()
                  : (value as num).toStringAsFixed(0),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: fgColor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: mutedColor)),
        ],
      ),
    );
  }
}
