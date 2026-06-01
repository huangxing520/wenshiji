import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/models/event.dart';
import 'package:uuid/uuid.dart';

enum AddEventMode { birthday, task, holiday }

enum CalendarType { solar, lunar }

typedef CategoryTagType = ({
  String label,
  String value,
});
class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _birthdayNameController = TextEditingController();
  final _notesController = TextEditingController();
  List<CategoryTagType> tags = [
      (label: '💝 纪念日', value: '纪念日'),
      (label: '💼 工作', value: '工作'),
      (label: '🏠 生活', value: '生活'),
    ];

  AddEventMode _currentMode = AddEventMode.birthday;
  EventPriority _currentPriority = EventPriority.high;
  /// 是否是倒计时模式
  bool _isCountdown = true;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _repeatRule = 'yearly';

  //todo
  final Set<EventReminder> _selectedReminders = {EventReminder.none};
  final Set<String> _selectedTags = {};
  bool _isAdvancedExpanded = true;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _birthdayNameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isFormValid => switch(_currentMode) {
    AddEventMode.birthday => _birthdayNameController.text.trim().isNotEmpty,
    AddEventMode.task => _nameController.text.trim().isNotEmpty,
    AddEventMode.holiday => _nameController.text.trim().isNotEmpty,
  };



  void _updateButtonState() {
    setState(() {});
  }

  void _switchMode(AddEventMode mode) {
    setState(() {
      _currentMode = mode;
      _repeatRule = mode == AddEventMode.task ? 'none' : 'yearly';
      _selectedTags.clear();
      if (mode == AddEventMode.holiday) {
        _selectedTags.add('节日');
      } else if (mode == AddEventMode.birthday) {
        _selectedTags.add('生日');
      } else if (mode == AddEventMode.task) {
        _selectedTags.add('工作');
      }
    });
  }

  void _selectPriority(EventPriority pri) {
    setState(() {
      _currentPriority = pri;
    });
  }

  void _toggleReminder(EventReminder rem) {
    setState(() {
      if (_selectedReminders.contains(rem)) {
        _selectedReminders.remove(rem);
        if (!_selectedReminders.isNotEmpty) {
        _selectedReminders.add(EventReminder.none);
      }
      } else {
        _selectedReminders.add(rem);
        if (_selectedReminders.contains(EventReminder.none)) {
          _selectedReminders.remove(EventReminder.none);
        }
      } 
      
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _addCustomTag() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('输入自定义标签名称'),
        content: TextField(
          autofocus: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              setState(() {
                _selectedTags.add(value.trim());
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('标签已添加')),
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveEvent() {
    if (!_isFormValid) return;

    final event = Event(
      id: const Uuid().v4(),
      name: _currentMode == AddEventMode.birthday
          ? _birthdayNameController.text.trim()
          : _nameController.text.trim(),
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      type: switch (_currentMode) {
         AddEventMode.birthday=>
           EventType.birthday,
         AddEventMode.task=>
          _isCountdown ? EventType.task : EventType.dailySignIn,
         AddEventMode.holiday=>
           EventType.holiday,
        },
      priority: _currentPriority ,
      tags: _selectedTags.toList(),
      reminder: _selectedReminders.toList(),
      description: _notesController.text.trim(),
    );

    ref.read(eventProvider.notifier).addEvent(event);

    setState(() {
      _showSuccess = true;
    });
  }

  void _closeSuccess() {
    setState(() {
      _showSuccess = false;
    });
    _nameController.clear();
    _birthdayNameController.clear();
    _notesController.clear();
   // context.go('/homepage');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = const Color(0xFFFAF7F0);
    final surfaceColor = Colors.white;
    final accentColor = const Color(0xFFD4A853);
    final accentDeepColor = const Color(0xFF8B6F3A);
    final accentSoftColor = const Color(0xFFF3E6C1);
    final borderColor = const Color(0xFFE5E0D2);
    final fgColor = const Color(0xFF383428);
    final mutedColor = const Color(0xFF8B8066);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              _buildStatusBar(bgColor, fgColor),
              _buildTopNav(accentSoftColor, accentDeepColor, fgColor),
              _buildModeTabs(accentSoftColor, accentColor, accentDeepColor,
                  fgColor, mutedColor),
              Expanded(
                child: _buildFormScroll(
                  surfaceColor,
                  accentSoftColor,
                  accentDeepColor,
                  accentColor,
                  borderColor,
                  fgColor,
                  mutedColor,
                ),
              ),
              _buildBottomBar(
                  accentColor, fgColor, accentSoftColor, mutedColor),
            ],
          ),
          if (_showSuccess)
            _buildSuccessOverlay(surfaceColor, accentSoftColor, accentDeepColor,
                fgColor, mutedColor),
        ],
      ),
    );
  }

  Widget _buildStatusBar(Color bgColor, Color fgColor) {
    return Container(
      height: 44,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
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

  Widget _buildTopNav(
      Color accentSoftColor, Color accentDeepColor, Color fgColor) {
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
            onTap: () => context.go('/homepage'),
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
            '新增事件',
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

  Widget _buildModeTabs(
    Color accentSoftColor,
    Color accentColor,
    Color accentDeepColor,
    Color fgColor,
    Color mutedColor,
  ) {
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
            alignment: 
            switch (_currentMode) {
               AddEventMode.birthday=> Alignment.centerLeft,
               AddEventMode.task=> Alignment.center,
               AddEventMode.holiday=> Alignment.centerRight,
            },
            child: FractionallySizedBox(
              widthFactor:1.0 / 3,
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
              Expanded(
                child: GestureDetector(
                  onTap: () => _switchMode(AddEventMode.birthday),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        '🎂 生日模式',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _currentMode == AddEventMode.birthday
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: _currentMode == AddEventMode.birthday
                              ? const Color(0xFF2A2822)
                              : mutedColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _switchMode(AddEventMode.task),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        '📌 普通事项',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _currentMode == AddEventMode.task
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: _currentMode == AddEventMode.task
                              ? const Color(0xFF2A2822)
                              : mutedColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _switchMode(AddEventMode.holiday),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        '🎉 节日模式',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _currentMode == AddEventMode.holiday
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: _currentMode == AddEventMode.holiday
                              ? const Color(0xFF2A2822)
                              : mutedColor,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormScroll(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildBasicSection(
              surfaceColor, accentColor, borderColor, fgColor, mutedColor),
          _buildAdvancedSection(surfaceColor, accentSoftColor, accentDeepColor,
              accentColor, borderColor, fgColor, mutedColor),
          _buildNotesSection(surfaceColor, accentSoftColor, accentDeepColor,
              borderColor, fgColor, mutedColor),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildBasicSection(
    Color surfaceColor,
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '基础信息',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: mutedColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (_currentMode == AddEventMode.task)
            _buildTextField(
              '事件名称',
              _nameController,
              '请输入事件名称',
              true,
              surfaceColor,
              borderColor,
              fgColor,
              mutedColor,
            ),
         if (_currentMode == AddEventMode.holiday)
            _buildTextField(
              '节日名称',
              _nameController,
              '请输入节日名称',
              true,
              surfaceColor,
              borderColor,
              fgColor,
              mutedColor,
            ),
          if (_currentMode == AddEventMode.birthday)
            _buildTextField(
              '姓名',
              _birthdayNameController,
              '例如：妈妈',
              false,
              surfaceColor,
              borderColor,
              fgColor,
              mutedColor,
            ),
          _buildDateField(
              surfaceColor, accentColor, borderColor, fgColor, mutedColor),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String placeholder,
    bool required,
    Color surfaceColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: fgColor,
                  ),
                ),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFFFF6B6B),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1.5),
              color: surfaceColor,
            ),
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 15, color: fgColor),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: mutedColor),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    Color surfaceColor,
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '日期选择',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: fgColor,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 1.5),
                      color: surfaceColor,
                    ),
                    child: Text(
                      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 15, color: fgColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 1.5),
                      color: surfaceColor,
                    ),
                    child: Text(
                      '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 15, color: fgColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '高级设置',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: mutedColor,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _isAdvancedExpanded = !_isAdvancedExpanded;
                }),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentSoftColor,
                  ),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _isAdvancedExpanded ? 0 : -0.25,
                    child: Icon(Icons.keyboard_arrow_down,
                        color: accentDeepColor, size: 16),
                  ),
                ),
              ),
            ],
          ),
         
            _isAdvancedExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_currentMode == AddEventMode.task)
                          _buildRepeatField(
                            surfaceColor, borderColor, fgColor, mutedColor),
                        _buildPriorityField(surfaceColor, accentColor,
                            borderColor, fgColor, mutedColor), 
                            if (_currentMode == AddEventMode.task)
                            _buildTimerField(surfaceColor, accentSoftColor,
                            accentColor, borderColor, fgColor, mutedColor),
                         (!_isCountdown&&_currentMode==AddEventMode.task)?const SizedBox.shrink():
                        _buildReminderField(surfaceColor, accentSoftColor,
                            accentDeepColor, borderColor, fgColor, mutedColor),
                       
                        _buildTagField(surfaceColor, accentSoftColor,
                            accentDeepColor, borderColor, fgColor, mutedColor),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          
        ],
      ),
    );
  }

  Widget _buildRepeatField(
    Color surfaceColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '重复规则（以选择的日期所处的周、月为基准）',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fgColor,
            ),
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 1.5),
                    color: surfaceColor,
                  ),
                  child: DropdownMenu<String>(
                    expandedInsets: EdgeInsets.zero, // 👈 让宽度完全贴合父组件
                  
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'none', label: '不重复'),
                      DropdownMenuEntry(value: 'daily', label: '每日'),
                      DropdownMenuEntry(value: 'weekly', label: '每周'),
                      DropdownMenuEntry(value: 'monthly', label: '每月'),
                      DropdownMenuEntry(value: 'yearly', label: '每年'),
                    ],
       
                    initialSelection: _repeatRule,
                    inputDecorationTheme: InputDecorationTheme(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    textStyle: TextStyle(fontSize: 15, color: fgColor),
                    onSelected: (String? value) {
                      _repeatRule = value!;
                    },
                  )

                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityField(
    Color surfaceColor,
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    final priorities = [
      (EventPriority.special, '特级重要', const Color(0xFFE64C3C)),
      (EventPriority.high, '重要', const Color(0xFFE67E22)),
      (EventPriority.mid, '普通', const Color(0xFFD4A853)),
      (EventPriority.low, '次要', const Color(0xFF27AE60)),
    ];

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
            children: priorities.map((pri) {
              final isSelected = _currentPriority == pri.$1;
              return GestureDetector(
                onTap: () => _selectPriority(pri.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  curve: Curves.easeOutCubic,
                  transform: isSelected
                      ? Matrix4.identity().scaledByDouble(1.04, 1.04, 1.0, 1.0)
                      : Matrix4.identity(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
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

  Widget _buildReminderField(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    final reminders = [
      (EventReminder.oneHour, '1小时'),
      (EventReminder.daily, '1天'),
      (EventReminder.threeDays, '3天'),
      (EventReminder.sevenDays, '7天'),
      (EventReminder.fifteenDays, '15天'),
      (EventReminder.thirtyDays, '30天'),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '提前提醒',
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
            children: reminders.map((rem) {
              final isSelected = _selectedReminders.contains(rem.$1);
              return GestureDetector(
                onTap: () => _toggleReminder(rem.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  curve: Curves.easeOutCubic,
                  transform: isSelected
                      ? Matrix4.identity().scaledByDouble(1.04, 1.04, 1.0, 1.0)
                      : Matrix4.identity(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFD4A853) : borderColor,
                      width: 1.5,
                    ),
                    color: isSelected ? accentSoftColor : surfaceColor,
                  ),
                  child: Text(
                    rem.$2,
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

  Widget _buildTimerField(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
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
                child: GestureDetector(
                  onTap: () => setState(() => _isCountdown = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    transform: _isCountdown
                        ? Matrix4.identity()
                            .scaledByDouble(1.03, 1.03, 1.0, 1.0)
                        : Matrix4.identity(),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isCountdown ? accentColor : borderColor,
                        width: 1.5,
                      ),
                      color: _isCountdown ? accentColor : surfaceColor,
                      boxShadow: _isCountdown
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
                        const Text('⏳', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 2),
                        Text(
                          '倒计时',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isCountdown
                                ? const Color(0xFF2A2822)
                                : mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isCountdown = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    transform: !_isCountdown
                        ? Matrix4.identity()
                            .scaledByDouble(1.03, 1.03, 1.0, 1.0)
                        : Matrix4.identity(),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: !_isCountdown ? accentColor : borderColor,
                        width: 1.5,
                      ),
                      color: !_isCountdown ? accentColor : surfaceColor,
                      boxShadow: !_isCountdown
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
                        const Text('📈', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 2),
                        Text(
                          '连签计时',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: !_isCountdown
                                ? const Color(0xFF2A2822)
                                : mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagField(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
   

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
            children: [
              ...tags.map((tag) {
                final isSelected = _selectedTags.contains(tag.value);
                return GestureDetector(
                  onTap: () => _toggleTag(tag.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected ? const Color(0xFFD4A853) : borderColor,
                        width: 1.5,
                      ),
                      color: isSelected ? accentSoftColor : surfaceColor,
                    ),
                    child: Text(
                      tag.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? accentDeepColor : mutedColor,
                      ),
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: _addCustomTag,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                          fontSize: 18,
                          color: mutedColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '备注',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: mutedColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1.5),
              color: surfaceColor,
            ),
            child: TextField(
              controller: _notesController,
              maxLines: null,
              minLines: 4,
              style: TextStyle(fontSize: 15, color: fgColor, height: 1.6),
              decoration: InputDecoration(
                hintText: '记录一些想说的话…',
                hintStyle: TextStyle(color: mutedColor),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildImageThumb(accentSoftColor, accentDeepColor),
              const SizedBox(width: 8),
              _buildImageThumb(accentSoftColor, accentDeepColor),
              const SizedBox(width: 8),
              _buildAddImageThumb(
                  borderColor, accentSoftColor, accentDeepColor),
              const SizedBox(width: 8),
              Text(
                '2/9',
                style: TextStyle(fontSize: 11, color: mutedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumb(Color accentSoftColor, Color accentDeepColor) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('图片选择开发中')),
      ),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: const Color(0xFFE5E0D2),
              width: 1.5,
              style: BorderStyle.solid),
          color: accentSoftColor,
        ),
        child: Icon(Icons.image_outlined, color: accentDeepColor, size: 24),
      ),
    );
  }

  Widget _buildAddImageThumb(
      Color borderColor, Color accentSoftColor, Color accentDeepColor) {
    return GestureDetector(
      onTap: () => Utils.pickMultipleImages(),
      
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: borderColor, width: 1.5, style: BorderStyle.solid),
        ),
        child: Icon(Icons.add, color: accentDeepColor, size: 24),
      ),
    );
  }

  Widget _buildBottomBar(Color accentColor, Color fgColor,
      Color accentSoftColor, Color mutedColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E0D2))),
      ),
      child: GestureDetector(
        onTap: _isFormValid ? _saveEvent : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _isFormValid ? accentColor : const Color(0xFFE8E3D3),
            boxShadow: _isFormValid
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
              '保存事件',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _isFormValid ? const Color(0xFF2A2822) : mutedColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessOverlay(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color fgColor,
    Color mutedColor,
  ) {
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
                '保存成功',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: fgColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '事件已添加到你的提醒列表',
                style: TextStyle(
                  fontSize: 14,
                  color: mutedColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _closeSuccess,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFD4A853),
                  ),
                  child: Text(
                    '好的',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2A2822),
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
