import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';
import 'package:wenshiji/common/utils.dart';

/// 公历 / 农历切换条。
///
/// 纯展示：[isLunar] 传入当前选择，[onChanged] 回调切换结果；
/// 农历模式下额外显示当前日期对应的农历中文描述。
class CalendarTypeToggle extends StatelessWidget {
  const CalendarTypeToggle({
    super.key,
    required this.isLunar,
    required this.onChanged,
    required this.selectedDate,
    required this.accentColor,
    required this.borderColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final bool isLunar;
  final ValueChanged<bool> onChanged;
  final DateTime selectedDate;
  final Color accentColor;
  final Color borderColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(
          label: '公历',
          selected: !isLunar,
          onTap: () => onChanged(false),
        ),
        const SizedBox(width: 8),
        _chip(
          label: '农历',
          selected: isLunar,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 10),
        if (isLunar)
          Expanded(
            child: Text(
              '农历 ${Utils.lunarLabel(selectedDate)}',
              style: TextStyle(fontSize: 12, color: mutedColor),
            ),
          ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? accentColor : borderColor,
            width: 1.5,
          ),
          color:
              selected ? accentColor.withValues(alpha: 0.12) : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? accentColor : mutedColor,
          ),
        ),
      ),
    );
  }
}

/// 农历 年 / 月 / 日 三个下拉选择器。
///
/// 月份候选项由 [monthOptions] 传入（含闰月，值为负数），
/// 日的上限由 [dayCount] 限定。
class LunarPickerRow extends StatelessWidget {
  const LunarPickerRow({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.monthOptions,
    required this.dayCount,
    required this.onYearChanged,
    required this.onMonthChanged,
    required this.onDayChanged,
    required this.surfaceColor,
    required this.borderColor,
    required this.fgColor,
  });

  final int year;
  final int month;
  final int day;
  final List<({int value, String label, int dayCount})> monthOptions;
  final int dayCount;
  final ValueChanged<int> onYearChanged;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onDayChanged;
  final Color surfaceColor;
  final Color borderColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    final yearNow = DateTime.now().year;
    final years = [for (int y = yearNow - 100; y <= yearNow + 20; y++) y];

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _LunarDropdown<int>(
            value: year,
            items: years.map((y) => (value: y, label: '$y年')).toList(),
            onChanged: onYearChanged,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            fgColor: fgColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: _LunarDropdown<int>(
            value: month,
            items: monthOptions
                .map((o) => (value: o.value, label: o.label))
                .toList(),
            onChanged: onMonthChanged,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            fgColor: fgColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: _LunarDropdown<int>(
            value: day,
            items: [
              for (int d = 1; d <= dayCount; d++)
                (value: d, label: LunarUtil.DAY[d]),
            ],
            onChanged: onDayChanged,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            fgColor: fgColor,
          ),
        ),
      ],
    );
  }
}

class _LunarDropdown<T> extends StatelessWidget {
  const _LunarDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.surfaceColor,
    required this.borderColor,
    required this.fgColor,
  });

  final T value;
  final List<({T value, String label})> items;
  final ValueChanged<T> onChanged;
  final Color surfaceColor;
  final Color borderColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    // 防御：value 不在候选中时（如换月后日期越界）回落到第一项，
    // 避免 DropdownButton 断言失败。
    final hasValue = items.any((it) => it.value == value);
    final safeValue = hasValue ? value : items.first.value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
        color: surfaceColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: safeValue,
          isExpanded: true,
          items: items
              .map(
                (it) => DropdownMenuItem<T>(
                  value: it.value,
                  child: Text(
                    it.label,
                    style: TextStyle(fontSize: 14, color: fgColor),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
