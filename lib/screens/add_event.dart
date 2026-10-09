import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunar/lunar.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/models/event.dart';
import 'package:uuid/uuid.dart';
import 'package:wenshiji/widget/add_event/mode_tabs.dart';
import 'package:wenshiji/widget/add_event/calendar_picker.dart';
import 'package:wenshiji/widget/add_event/priority_field.dart';
import 'package:wenshiji/widget/add_event/tag_field.dart';
import 'package:wenshiji/widget/add_event/notes_section.dart';
import 'package:wenshiji/widget/add_event/save_bar.dart';
import 'package:wenshiji/widget/add_event/timer_field.dart';
import 'package:wenshiji/widget/add_event/add_event_header.dart';
import 'package:wenshiji/theme/app_colors.dart';

enum AddEventMode { birthday, task, holiday }

typedef CategoryTagType = ({String label, String value});

class AddEventScreen extends ConsumerStatefulWidget {
  const AddEventScreen({super.key, this.event});
  final Event? event;

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen>
    with SingleTickerProviderStateMixin {
  late String _uuid;
  final _nameController = TextEditingController();
  final _birthdayNameController = TextEditingController();
  final _notesController = TextEditingController();
  List<String> tags = [
   '💝 纪念日',
   '💼 工作',
  '🏠 生活',
  '📚 学习',
  '🎮 游戏',  
  '🗓️ 会议',
  '🔔 提醒',
  '👨‍👩‍👧 家庭事务',
  '🤝 社交往来',
  // 模式默认标签：_switchMode 会自动勾选，必须在此列出，
  // 否则保存出的标签在表单里既不可见也不可取消。
  '生日',
  '节日',
  ];

  AddEventMode _currentMode = AddEventMode.birthday;
  EventPriority _currentPriority = EventPriority.high;

  /// 是否是倒计时模式
  bool _isCountdown = true;
  DateTime _selectedDate = DateTime.now();
  /// 用户是否已显式选择过日期。
  /// 默认未选，避免「不碰日期就默默把今天当生日保存」（叠加重复规则后事件会沉底）。
  bool _dateSelected = false;
  //TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _repeatRule = 'yearly';
  /// 日期是否为农历。为 true 时 [_selectedDate] 仍是农历对应的公历日。
  bool _isLunar = false;
  /// 农历选择的年 / 月（负数 = 闰月）/ 日。
  int _lunarYear = DateTime.now().year;
  int _lunarMonth = 1;
  int _lunarDay = 1;
  TextEditingController _tagController = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _isAdvancedExpanded = true;
  bool _showSuccess = false;

  /// 保存重入锁：防止快速双击产生两条内容相同、id 不同的事件。
  bool _saving = false;

  /// 编辑态：非 null 表示在编辑既有事件（复用其 id，未编辑字段沿用原值）。
  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    _uuid = widget.event?.id ?? const Uuid().v4();
    _backfillFromEvent();
    _nameController.addListener(_updateButtonState);
    _birthdayNameController.addListener(_updateButtonState);
  }

  /// 编辑态回填：把既有事件写入各 controller / 状态字段。
  void _backfillFromEvent() {
    final event = widget.event;
    if (event == null) return;

    _currentMode = switch (event.type) {
      EventType.birthday => AddEventMode.birthday,
      EventType.holiday => AddEventMode.holiday,
      EventType.task || EventType.dailySignIn => AddEventMode.task,
    };
    _isCountdown = event.type != EventType.dailySignIn;
    _currentPriority = event.priority;
    _selectedDate = event.date;
    _repeatRule = event.repeatRule.name;
    _isLunar = event.isLunar;
    if (_isLunar) {
      // 回填农历选择的年 / 月 / 日（月为负数表示闰月）。
      final lunar = Lunar.fromDate(event.date);
      _lunarYear = lunar.getYear();
      _lunarMonth = lunar.getMonth();
      _lunarDay = lunar.getDay();
    }
    _selectedTags
      ..clear()
      ..addAll(event.tags);

    if (event.type == EventType.birthday) {
      _birthdayNameController.text = event.name;
    } else {
      _nameController.text = event.name;
    }
    _notesController.text = event.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayNameController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  /// 表单有效性：名称必填 + 日期必选（编辑态沿用已选日期，视为已选）。
  bool get _isFormValid {
    if (!_dateSelected && !_isEditing) return false;
    return switch (_currentMode) {
      AddEventMode.birthday => _birthdayNameController.text.trim().isNotEmpty,
      AddEventMode.task => _nameController.text.trim().isNotEmpty,
      AddEventMode.holiday => _nameController.text.trim().isNotEmpty,
    };
  }

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
        _selectedTags.add('💼 工作');
      }
    });
  }

  void _selectPriority(EventPriority pri) {
    setState(() {
      _currentPriority = pri;
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

  // void _addCustomTag() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('输入自定义标签名称'),
  //       content: TextField(
  //         autofocus: true,
  //         controller: _tagController,
        
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => _tagController.text.isNotEmpty
  //               ? () {
  //                   setState(() {
  //                     _selectedTags.add(_tagController.text.trim());
  //                   });
  //                   Navigator.of(context).pop();
  //                   ScaffoldMessenger.of(
  //                     context,
  //                   ).showSnackBar(const SnackBar(content: Text('标签已添加')));
  //                 }
  //               :  Navigator.of(context).pop(),
  //           child: const Text('确定'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _selectDate(DateTime initialDate) async {
    final date = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        AppLogger().debug('confirm $date');
      },
      currentTime: initialDate,
      locale: LocaleType.zh,
    );

   
    if (date != null) {
      if (!mounted) return;
      setState(() {
        _selectedDate = date;
        _dateSelected = true;
        // 切回公历选择时同步农历展示字段，避免两套值不一致。
        if (_isLunar) {
          final lunar = Lunar.fromDate(date);
          _lunarYear = lunar.getYear();
          _lunarMonth = lunar.getMonth();
          _lunarDay = lunar.getDay();
        }
      });
    }
  }

  /// 切换公历 / 农历。切到农历时用当前公历日反查农历初始化选择。
  void _toggleCalendarType(bool isLunar) {
    setState(() {
      _isLunar = isLunar;
      if (isLunar) {
        final lunar = Lunar.fromDate(_selectedDate);
        _lunarYear = lunar.getYear();
        _lunarMonth = lunar.getMonth();
        _lunarDay = lunar.getDay();
      }
    });
  }

  /// 可选农历月份：该年 1..12 月，含闰月时在对应月份后紧跟一个负数闰月。
  /// 返回 (值, 显示名, 该月天数)。
  List<({int value, String label, int dayCount})> _lunarMonthOptions() {
    final lunarYear = LunarYear.fromYear(_lunarYear);
    final months = lunarYear
        .getMonths()
        .where((m) => m.getYear() == _lunarYear)
        .toList();
    return months.map((m) {
      final value = m.getMonth();
      final isLeap = value < 0;
      final label = '${isLeap ? '闰' : ''}${LunarUtil.MONTH[value.abs()]}月';
      return (value: value, label: label, dayCount: m.getDayCount());
    }).toList();
  }

  /// 当前所选农历月的天数（用于限定「日」的上限）。
  int _lunarDayCount() {
    final option = _lunarMonthOptions().where(
      (o) => o.value == _lunarMonth,
    );
    return option.isNotEmpty ? option.first.dayCount : 30;
  }

  void _selectLunarYear(int year) {
    setState(() {
      _lunarYear = year;
      // 换年后闰月是否存在可能变化，若当前选的是闰月且新一年没有该闰月，回落到非闰月。
      final leap = LunarYear.fromYear(_lunarYear).getLeapMonth();
      if (_lunarMonth < 0 && leap != -_lunarMonth) {
        _lunarMonth = -_lunarMonth;
      }
      final maxDay = _lunarDayCount();
      if (_lunarDay > maxDay) _lunarDay = maxDay;
      _syncLunarToSolar();
    });
  }

  void _selectLunarMonth(int month) {
    setState(() {
      _lunarMonth = month;
      final maxDay = _lunarDayCount();
      if (_lunarDay > maxDay) _lunarDay = maxDay;
      _syncLunarToSolar();
    });
  }

  void _selectLunarDay(int day) {
    setState(() {
      _lunarDay = day;
      _syncLunarToSolar();
    });
  }

  /// 把当前农历选择换算为公历 [_selectedDate]（保存时用它作为 date）。
  void _syncLunarToSolar() {
    try {
      _selectedDate = Utils.lunarToSolar(
        year: _lunarYear,
        month: _lunarMonth,
        day: _lunarDay,
      );
      // 选定农历月/日即视为完成日期选择。
      _dateSelected = true;
    } catch (e) {
      AppLogger().error('农历换算公历失败', error: e);
    }
  }


  void _saveEvent() async {
    if (!_isFormValid || _saving) return;
    setState(() => _saving = true);

    try {
      List<String> imagePaths;
      try {
        imagePaths = await ref.read(savedImagePathsForIdProvider(_uuid).future);
      } catch (e) {
        // 读取失败时给一个空列表，或者提示用户
        imagePaths = [];
      }
      // 编辑态下若图片读取为空（历史数据图片键与事件 id 不一致），保留原事件图片，
      // 不要把已有照片清空。
      final existingPictures = widget.event?.picturePaths ?? const <String>[];
      final resolvedPictures =
          imagePaths.isEmpty && existingPictures.isNotEmpty
          ? existingPictures
          : imagePaths;

      final name = _currentMode == AddEventMode.birthday
          ? _birthdayNameController.text.trim()
          : _nameController.text.trim();
      final date = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      final type = switch (_currentMode) {
        AddEventMode.birthday => EventType.birthday,
        AddEventMode.task =>
          _isCountdown ? EventType.task : EventType.dailySignIn,
        AddEventMode.holiday => EventType.holiday,
      };

      // 编辑态：复用原 id 与未编辑字段（置顶 / 收藏 / 连签 / 归档等），只覆盖表单字段；
      // 新增态：以表单值构造新事件。此前保存恒用新 UUID，导致「编辑」实际是新增一条。
      final repeatRule = RepeatRule.fromName(_repeatRule);
      final base = _isEditing
          ? widget.event!.copyWith(
              name: name,
              date: date,
              type: type,
              priority: _currentPriority,
              repeatRule: repeatRule,
              isLunar: _isLunar,
              tags: _selectedTags.toList(),
              description: _notesController.text.trim(),
              picturePaths: resolvedPictures,
            )
          : Event(
              id: _uuid,
              name: name,
              date: date,
              nextEffectiveTime: date,
              type: type,
              priority: _currentPriority,
              repeatRule: repeatRule,
              isLunar: _isLunar,
              tags: _selectedTags.toList(),
              description: _notesController.text.trim(),
              picturePaths: resolvedPictures,
            );
      // 按重复规则推进到「今天或之后」，避免过完当天即从首页消失。
      final event = base.copyWith(
        nextEffectiveTime: Utils.nextEffectiveOf(base, DateTime.now()),
      );

      // 只记录 id / 类型，不打印整个 Event（含姓名、备注等个人内容）。
      AppLogger().info(
        '${_isEditing ? '更新' : '添加'}事件: id=$_uuid type=${type.name}',
      );
      if (_isEditing) {
        await ref.read(eventProvider.notifier).updateEvent(_uuid, event);
      } else {
        await ref.read(eventProvider.notifier).addEvent(event);
      }
    } catch (e, s) {
      AppLogger().error('保存事件失败', error: e, stack: s);
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_isEditing ? '更新事件失败' : '添加事件失败')));
      }
      return;
    }

    if (!mounted) return;
    setState(() {
      _showSuccess = true;
      _saving = false;
    });
  }

  void _closeSuccess() {
    setState(() {
      _showSuccess = false;
    });
    _nameController.clear();
    _birthdayNameController.clear();
    _notesController.clear();
    // 无栈可退时（深链直达）回退首页，避免 pop 抛错。
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/homepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFFAF7F0);
    final surfaceColor = Colors.white;
    final accentColor = AppColors.primary;
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
              _buildModeTabs(
                accentSoftColor,
                accentColor,
                accentDeepColor,
                fgColor,
                mutedColor,
              ),
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
                accentColor,
                fgColor,
                accentSoftColor,
                mutedColor,
              ),
            ],
          ),
          if (_showSuccess)
            _buildSuccessOverlay(
              surfaceColor,
              accentSoftColor,
              accentDeepColor,
              fgColor,
              mutedColor,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(Color bgColor, Color fgColor) {
    return EventStatusBar(bgColor: bgColor, fgColor: fgColor);
  }

  Widget _buildTopNav(
    Color accentSoftColor,
    Color accentDeepColor,
    Color fgColor,
  ) {
    return AddEventHeader(
      isEditing: _isEditing,
      accentSoftColor: accentSoftColor,
      accentDeepColor: accentDeepColor,
      fgColor: fgColor,
    );
  }
  Widget _buildModeTabs(
    Color accentSoftColor,
    Color accentColor,
    Color accentDeepColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return ModeTabs(
      currentMode: _currentMode,
      onModeChanged: _switchMode,
      accentSoftColor: accentSoftColor,
      accentColor: accentColor,
      fgColor: const Color(0xFF2A2822),
      mutedColor: mutedColor,
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
            surfaceColor,
            accentColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          _buildAdvancedSection(
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            accentColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          _buildNotesSection(
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
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
              // 与 _isFormValid 保持一致：姓名为空则不允许保存，故标记为必填。
              true,
              surfaceColor,
              borderColor,
              fgColor,
              mutedColor,
            ),
          _buildDateField(
            surfaceColor,
            accentColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
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
                  onTap: () => _selectDate(_selectedDate),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
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
              // const SizedBox(width: 10),
              // Expanded(
              //   child: GestureDetector(
              //     onTap: _selectTime,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 16,
              //         vertical: 13,
              //       ),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(color: borderColor, width: 1.5),
              //         color: surfaceColor,
              //       ),
              //       child: Text(
              //         '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
              //         style: TextStyle(fontSize: 15, color: fgColor),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCalendarTypeToggle(
            accentColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          if (_isLunar) ...[
            const SizedBox(height: 10),
            _buildLunarPickerRow(
              surfaceColor,
              borderColor,
              fgColor,
              mutedColor,
            ),
          ],
        ],
      ),
    );
  }

  /// 公历 / 农历切换。
  Widget _buildCalendarTypeToggle(
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return CalendarTypeToggle(
      isLunar: _isLunar,
      onChanged: _toggleCalendarType,
      selectedDate: _selectedDate,
      accentColor: accentColor,
      borderColor: borderColor,
      fgColor: const Color(0xFF2A2822),
      mutedColor: mutedColor,
    );
  }
  /// 农历 年 / 月 / 日 三个下拉选择器。
  Widget _buildLunarPickerRow(
    Color surfaceColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return LunarPickerRow(
      year: _lunarYear,
      month: _lunarMonth,
      day: _lunarDay,
      monthOptions: _lunarMonthOptions(),
      dayCount: _lunarDayCount(),
      onYearChanged: _selectLunarYear,
      onMonthChanged: _selectLunarMonth,
      onDayChanged: _selectLunarDay,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      fgColor: fgColor,
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
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: accentDeepColor,
                      size: 16,
                    ),
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
                      // if (_currentMode == AddEventMode.task)
                      //   _buildRepeatField(
                      //     surfaceColor,
                      //     borderColor,
                      //     fgColor,
                      //     mutedColor,
                      //   ),
                      _buildPriorityField(
                        surfaceColor,
                        accentColor,
                        borderColor,
                        fgColor,
                        mutedColor,
                      ),
                      if (_currentMode == AddEventMode.task)
                        _buildTimerField(
                          surfaceColor,
                          accentSoftColor,
                          accentColor,
                          borderColor,
                          fgColor,
                          mutedColor,
                        ),

                      // (!_isCountdown && _currentMode == AddEventMode.task)
                      //     ? const SizedBox.shrink()
                      //     : _buildReminderField(
                      //         surfaceColor,
                      //         accentSoftColor,
                      //         accentDeepColor,
                      //         borderColor,
                      //         fgColor,
                      //         mutedColor,
                      //       ),
                      _buildTagField(
                        surfaceColor,
                        accentSoftColor,
                        accentDeepColor,
                        borderColor,
                        fgColor,
                        mutedColor,
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
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
    return PriorityField(
      current: _currentPriority,
      onChanged: _selectPriority,
      surfaceColor: surfaceColor,
      borderColor: borderColor,
      fgColor: fgColor,
      mutedColor: mutedColor,
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
    return TimerField(
      isCountdown: _isCountdown,
      onChanged: (v) => setState(() => _isCountdown = v),
      surfaceColor: surfaceColor,
      accentColor: accentColor,
      borderColor: borderColor,
      fgColor: const Color(0xFF2A2822),
      mutedColor: mutedColor,
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
    return TagField(
      tags: tags,
      selectedTags: _selectedTags,
      onToggle: _toggleTag,
      surfaceColor: surfaceColor,
      accentSoftColor: accentSoftColor,
      accentDeepColor: accentDeepColor,
      borderColor: borderColor,
      fgColor: fgColor,
      mutedColor: mutedColor,
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
    return NotesSection(
      eventId: _uuid,
      notesController: _notesController,
      onDeleteImage: (index) async {
        await ref
            .read(imageServiceProvider)
            .deleteImageAtIndexForId(_uuid, index);
        if (!mounted) return;
        ref.invalidate(savedImagePathsForIdProvider(_uuid));
      },
      onPickImages: () async {
        final paths = await ref
            .read(imageServiceProvider)
            .pickAndSaveMultipleImagesForId(_uuid);
        if (paths.isNotEmpty) {
          ref.invalidate(savedImagePathsForIdProvider(_uuid));
          ref.invalidate(savedImageFilesForIdProvider(_uuid));
        }
      },
      surfaceColor: surfaceColor,
      accentSoftColor: accentSoftColor,
      accentDeepColor: accentDeepColor,
      borderColor: borderColor,
      fgColor: fgColor,
      mutedColor: mutedColor,
    );
  }
  Widget _buildBottomBar(
    Color accentColor,
    Color fgColor,
    Color accentSoftColor,
    Color mutedColor,
  ) {
    return SaveBar(
      enabled: _isFormValid,
      saving: _saving,
      isEditing: _isEditing,
      onSave: _saveEvent,
      accentColor: accentColor,
    );
  }
  Widget _buildSuccessOverlay(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return SuccessOverlay(
      isEditing: _isEditing,
      onClose: _closeSuccess,
      surfaceColor: surfaceColor,
      accentSoftColor: accentSoftColor,
      accentDeepColor: accentDeepColor,
      fgColor: fgColor,
      mutedColor: mutedColor,
    );
  }

}
