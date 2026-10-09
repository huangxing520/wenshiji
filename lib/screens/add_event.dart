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
import 'package:wenshiji/widget/card.dart';
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
    final leapMonth = lunarYear.getLeapMonth();
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
    final colorScheme = Theme.of(context).colorScheme;
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
    Color accentSoftColor,
    Color accentDeepColor,
    Color fgColor,
  ) {
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
            _isEditing ? '编辑事件' : '新增事件',
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
            alignment: switch (_currentMode) {
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
              ),
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
    return Row(
      children: [
        _buildCalendarTypeChip(
          label: '公历',
          selected: !_isLunar,
          onTap: () => _toggleCalendarType(false),
          accentColor: accentColor,
          borderColor: borderColor,
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        const SizedBox(width: 8),
        _buildCalendarTypeChip(
          label: '农历',
          selected: _isLunar,
          onTap: () => _toggleCalendarType(true),
          accentColor: accentColor,
          borderColor: borderColor,
          fgColor: fgColor,
          mutedColor: mutedColor,
        ),
        const SizedBox(width: 10),
        if (_isLunar)
          Expanded(
            child: Text(
              '农历 ${Utils.lunarLabel(_selectedDate)}',
              style: TextStyle(fontSize: 12, color: mutedColor),
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarTypeChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color accentColor,
    required Color borderColor,
    required Color fgColor,
    required Color mutedColor,
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
          color: selected
              ? accentColor.withValues(alpha: 0.12)
              : Colors.transparent,
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

  /// 农历 年 / 月 / 日 三个下拉选择器。
  Widget _buildLunarPickerRow(
    Color surfaceColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    final monthOptions = _lunarMonthOptions();
    final dayCount = _lunarDayCount();
    // 年份范围：1901..2100（lunar 包支持的区间内取常见范围）。
    final yearNow = DateTime.now().year;
    final years = [
      for (int y = yearNow - 100; y <= yearNow + 20; y++) y,
    ];

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildLunarDropdown<int>(
            value: _lunarYear,
            items: years.map((y) => (value: y, label: '$y年')).toList(),
            onChanged: _selectLunarYear,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            fgColor: fgColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: _buildLunarDropdown<int>(
            value: _lunarMonth,
            items: monthOptions
                .map((o) => (value: o.value, label: o.label))
                .toList(),
            onChanged: _selectLunarMonth,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            fgColor: fgColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: _buildLunarDropdown<int>(
            value: _lunarDay,
            items: [
              for (int d = 1; d <= dayCount; d++)
                (value: d, label: LunarUtil.DAY[d]),
            ],
            onChanged: _selectLunarDay,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            fgColor: fgColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLunarDropdown<T>({
    required T value,
    required List<({T value, String label})> items,
    required ValueChanged<T> onChanged,
    required Color surfaceColor,
    required Color borderColor,
    required Color fgColor,
  }) {
    // 防御：value 不在候选中时（如换月后日期越界）回落到第一项，避免 Dropdown 断言失败。
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
                ),
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
      (EventPriority.mid, '普通', AppColors.primary),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
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
                        ? Matrix4.identity().scaledByDouble(
                            1.03,
                            1.03,
                            1.0,
                            1.0,
                          )
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
                        ? Matrix4.identity().scaledByDouble(
                            1.03,
                            1.03,
                            1.0,
                            1.0,
                          )
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
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => _toggleTag(tag),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : borderColor,
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
              }),
              // GestureDetector(
              //   onTap: _addCustomTag,
              //   child: Container(
              //     width: 36,
              //     height: 36,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       border: Border.all(color: borderColor, width: 2),
              //     ),
              //     child: Center(
              //       child: Text(
              //         '+',
              //         style: TextStyle(
              //           fontSize: 18,
              //           color: mutedColor,
              //           fontWeight: FontWeight.w400,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
    final cardItemsAsync = ref.watch(getCardItemsProvider(_uuid));
    return Container(
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          cardItemsAsync.when(
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
            data: (imagePaths) => Wrap(
              runSpacing: 12, // 行与行之间的垂直间距
              spacing: 12, // 图片之间的水平间距（代替手动SizedBox）
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.end,
              children: [
                ...imagePaths.expand((e) {
                  return [
                    ImageCardWidget(
                      key: Key(e.imagePath),
                      card: e,
                      onDelete: () async {
                        await ref
                            .read(imageServiceProvider)
                            .deleteImageAtIndexForId(
                              _uuid,
                              imagePaths.indexOf(e),
                            );
                        if (!mounted) return;
                        ref.invalidate(savedImagePathsForIdProvider(_uuid));
                      },
                    ),
                  ];
                }).toList(),
                _buildAddImageThumb(
                  borderColor,
                  accentSoftColor,
                  accentDeepColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumb(
    Color accentSoftColor,
    Color accentDeepColor,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('图片选择开发中'))),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFFE5E0D2),
            width: 1.5,
            style: BorderStyle.solid,
          ),
          color: accentSoftColor,
        ),
        child: Icon(Icons.image_outlined, color: accentDeepColor, size: 24),
      ),
    );
  }

  Widget _buildAddImageThumb(
    Color borderColor,
    Color accentSoftColor,
    Color accentDeepColor,
  ) {
    return GestureDetector(
      onTap: () async {
        final paths = await ref
            .read(imageServiceProvider)
            .pickAndSaveMultipleImagesForId(_uuid);
        if (paths.isNotEmpty) {
          ref.invalidate(savedImagePathsForIdProvider(_uuid));
          ref.invalidate(savedImageFilesForIdProvider(_uuid));
        }
      },

      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: borderColor,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Icon(Icons.add, color: accentDeepColor, size: 24),
      ),
    );
  }

  Widget _buildBottomBar(
    Color accentColor,
    Color fgColor,
    Color accentSoftColor,
    Color mutedColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E0D2))),
      ),
      child: GestureDetector(
        // 保存中禁用点击，避免重入产生重复事件。
        onTap: (_isFormValid && !_saving) ? _saveEvent : null,
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
              _saving ? '保存中…' : (_isEditing ? '保存修改' : '保存事件'),
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
                _isEditing ? '修改已保存' : '保存成功',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: fgColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isEditing ? '事件修改已生效' : '事件已添加到你的提醒列表',
                style: TextStyle(fontSize: 14, color: mutedColor, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _closeSuccess,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primary,
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
