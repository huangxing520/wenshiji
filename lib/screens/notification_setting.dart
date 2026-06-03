import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wenshiji/common/notification_service.dart';
import 'package:wenshiji/providers/app_config.dart';

const _kBg = Color(0xFFFFFDF7);
const _kSurface = Color(0xFFFFFFFF);
const _kFg = Color(0xFF3D2E1E);
const _kMuted = Color(0xFF9E8E7A);
const _kMutedLight = Color(0xFFC4B8A6);
const _kBorder = Color(0xFFE8DCC8);
const _kAccent = Color(0xFFF5A623);
const _kAccentLight = Color(0xFFFFF3DC);
const _kAccentDeep = Color(0xFFD48B0A);
const _kSuccess = Color(0xFF4CAF7D);

class NotificationSettingScreen extends ConsumerStatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  ConsumerState<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState
    extends ConsumerState<NotificationSettingScreen>
    with SingleTickerProviderStateMixin {
  bool _toastVisible = false;
  String _toastMessage = '';

  void _showToast(String message) {
    setState(() {
      _toastMessage = message;
      _toastVisible = true;
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _toastVisible = false;
        });
      }
    });
  }

  void _toggleDND(WidgetRef ref) {
    final appConfig = ref
        .read(appConfigProvider)
        .requireValue
        .notificationDndOn;
    ref.read(appConfigProvider.notifier).setNotificationDndOn(!appConfig);

    //_showToast(appConfig.notificationDndOn ? '免打扰时段已开启' : '免打扰时段已关闭');
  }

  void _adjustTime(String which, int dir, WidgetRef ref) {
    final startHour = ref
        .read(appConfigProvider)
        .requireValue
        .notificationStartHour;
    final endHour = ref
        .read(appConfigProvider)
        .requireValue
        .notificationEndHour;
    if (which == 'start') {
      ref
          .read(appConfigProvider.notifier)
          .setNotificationStartHour((startHour + dir + 24) % 24);
    } else {
      ref
          .read(appConfigProvider.notifier)
          .setNotificationEndHour((endHour + dir + 24) % 24);
    }
  }

  void _toggleDNDDay(int index, WidgetRef ref) {
    final dndDays = ref
        .read(appConfigProvider)
        .requireValue
        .notificationDndDays;
    final newDays = List<bool>.from(dndDays);
    newDays[index] = !newDays[index];
    ref.read(appConfigProvider.notifier).setNotificationDndDays(newDays);
  }

  void _toggleDigest(WidgetRef ref) {
    final _digestOn = ref
        .read(appConfigProvider)
        .requireValue
        .notificationDigestOn;
    ref.read(appConfigProvider.notifier).setNotificationDigestOn(!_digestOn);
    _showToast(!_digestOn ? '聚合推送已开启' : '聚合推送已关闭');
  }

  void _selectDigestTime(String time, WidgetRef ref) {
    ref.read(appConfigProvider.notifier).setNotificationDigestTime(time);
    final label = time == 'morning' ? '早晨' : '傍晚';
    _showToast('推送时间已设为$label');
  }

  Future<void> _openSystemSettings() async {
    await NotificationService().openNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(appConfigProvider);
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopNav(),
                Expanded(
                  child: configAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('加载失败: $e')),
                    data: (_) => _buildScrollContent(ref),
                  ),
                ),
              ],
            ),
          ),
          if (_toastVisible) _buildToast(),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 14),
      child: Row(
        children: [
          _buildBackButton(),
          const SizedBox(width: 12),
          Text(
            '通知设置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _kFg,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: _kAccentLight, shape: BoxShape.circle),
        child: Center(
          child: Icon(Icons.arrow_back_ios_new, size: 18, color: _kAccentDeep),
        ),
      ),
    );
  }

  Widget _buildScrollContent(WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        _buildSectionLabel('免打扰'),
        _buildDNDCard(ref),
        _buildSectionLabel('聚合推送'),
        _buildDigestCard(ref),
        //_buildSectionLabel('系统'),
        //_buildSystemCard(),
        const SizedBox(height: 16),
        _buildSystemBtn(),
        _buildSystemHint(),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _kMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDNDCard(WidgetRef ref) {
    final _dndOn = ref.watch(appConfigProvider).requireValue.notificationDndOn;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: [
          _buildDNDRow(ref),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: _dndOn ? 180 : 0,
            child: ClipRect(
              child: OverflowBox(
                minHeight: 0,
                maxHeight: _dndOn ? double.infinity : 0,
                alignment: Alignment.topCenter,
                child: AnimatedOpacity(
                  opacity: _dndOn ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: _buildDNDSchedule(ref),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDNDRow(WidgetRef ref) {
    final _dndOn = ref.watch(appConfigProvider).requireValue.notificationDndOn;
    final _startHour = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationStartHour;
    final _startMinute = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationStartMinute;
    final _endHour = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationEndHour;
    final _endMinute = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationEndMinute;
    final _dndDays = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationDndDays;

    return InkWell(
      onTap: () => _toggleDND(ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF0D2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('🌙', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '免打扰时段',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _kFg,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _dndOn
                        ? '${_formatTime(_startHour, _startMinute)} – ${_formatTime(_endHour, _endMinute)} 期间静音'
                        : '已关闭',
                    style: TextStyle(
                      fontSize: 12,
                      color: _dndOn ? _kAccentDeep : _kMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            _buildStatusDot(_dndOn),
            const SizedBox(width: 14),
            _buildToggle(_dndOn, () => _toggleDND(ref), ref),
          ],
        ),
      ),
    );
  }

  Widget _buildDNDSchedule(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
      child: Column(
        children: [
          _buildTimeRangePicker(ref),
          const SizedBox(height: 12),
          _buildDNDDays(ref),
        ],
      ),
    );
  }

  Widget _buildTimeRangePicker(WidgetRef ref) {
    final _startHour = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationStartHour;
    final _startMinute = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationStartMinute;
    final _endHour = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationEndHour;
    final _endMinute = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationEndMinute;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeColumn('start', _startHour, _startMinute, '开始', ref),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '→',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: _kMutedLight,
            ),
          ),
        ),
        _buildTimeColumn('end', _endHour, _endMinute, '结束', ref),
      ],
    );
  }

  Widget _buildTimeColumn(
    String which,
    int hour,
    int minute,
    String label,
    WidgetRef ref,
  ) {
    return Column(
      children: [
        _buildTimeAdjBtn(() => _adjustTime(which, 1, ref), '▲'),
        const SizedBox(height: 4),
        Text(
          _formatTime(hour, minute),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _kFg,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        _buildTimeAdjBtn(() => _adjustTime(which, -1, ref), '▼'),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _kMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeAdjBtn(VoidCallback onTap, String icon) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 24,
        decoration: BoxDecoration(
          color: _kBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _kBorder),
        ),
        child: Center(
          child: Text(icon, style: TextStyle(fontSize: 11, color: _kMuted)),
        ),
      ),
    );
  }

  Widget _buildDNDDays(WidgetRef ref) {
    final _dndDays = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationDndDays;
    const days = ['日', '一', '二', '三', '四', '五', '六'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index < 6 ? 6 : 0),
          child: _buildDNDDay(days[index], index, _dndDays[index], ref),
        );
      }),
    );
  }

  Widget _buildDNDDay(String label, int index, bool active, WidgetRef ref) {
    return InkWell(
      onTap: () => _toggleDNDDay(index, ref),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: active ? _kAccent : _kBg,
          shape: BoxShape.circle,
          border: Border.all(color: active ? _kAccent : _kBorder, width: 1.5),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _kAccent.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : _kMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDigestCard(WidgetRef ref) {
    final _digestOn = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationDigestOn;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: [
          _buildDigestRow(ref),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: _digestOn ? 280 : 0,
            child: ClipRect(
              child: OverflowBox(
                minHeight: 0,
                maxHeight: _digestOn ? double.infinity : 0,
                alignment: Alignment.topCenter,
                child: AnimatedOpacity(
                  opacity: _digestOn ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: _buildDigestPreview(ref),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigestRow(WidgetRef ref) {
    final _digestOn = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationDigestOn;
    final _digestTime = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationDigestTime;
    return InkWell(
      onTap: () => _toggleDigest(ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('📬', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '每日聚合推送',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _kFg,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _digestOn
                        ? '每日${_digestTime == 'morning' ? '早晨' : '傍晚'}推送一条聚合通知'
                        : '将当天多条提醒合并为一条推送',
                    style: TextStyle(
                      fontSize: 12,
                      color: _digestOn ? _kAccentDeep : _kMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            _buildStatusDot(_digestOn),
            const SizedBox(width: 14),
            _buildToggle(_digestOn, () => _toggleDigest(ref), ref),
          ],
        ),
      ),
    );
  }

  Widget _buildDigestPreview(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: _kAccentLight,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '聚合推送预览',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _kAccentDeep,
              ),
            ),
            const SizedBox(height: 8),
            _buildDigestBubble('🎂', '小明', '的生日后天到来', ' · 周三'),
            _buildDigestBubble('📌', '项目评审', '截止日明天', ' · 周二'),
            _buildDigestBubble('🎂', '小红', '的生日本周五', ' · 后天'),
            const SizedBox(height: 10),
            _buildDigestTimeButtons(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildDigestBubble(
    String emoji,
    String name,
    String desc,
    String when,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _kSurface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _kFg,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: desc,
                    style: TextStyle(fontSize: 12, color: _kFg, height: 1.5),
                  ),
                  TextSpan(
                    text: when,
                    style: TextStyle(
                      fontSize: 12,
                      color: _kMuted,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigestTimeButtons(WidgetRef ref) {
    final _digestTime = ref
        .watch(appConfigProvider)
        .requireValue
        .notificationDigestTime;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDigestTimeBtn('🕖 早晨', 'morning', _digestTime == 'morning', ref),
        const SizedBox(width: 10),
        _buildDigestTimeBtn('🌆 傍晚', 'evening', _digestTime == 'evening', ref),
      ],
    );
  }

  Widget _buildDigestTimeBtn(
    String label,
    String time,
    bool active,
    WidgetRef ref,
  ) {
    return InkWell(
      onTap: () => _selectDigestTime(time, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? _kAccent : _kSurface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? _kAccent : _kBorder, width: 1.5),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _kAccent.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? Colors.white : _kMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildSystemCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: [
          _buildSystemRow(
            '⚙️',
            const Color(0xFFE3F2FD),
            '打开系统通知设置',
            '管理通知权限、声音和提醒方式',
            _openSystemSettings,
          ),
          _buildDivider(),
          _buildSystemRow(
            '🔔',
            const Color(0xFFFFF3E0),
            '通知预览',
            '在应用内预览推送样式',
            () {
              _showToast('已打开应用内通知预览');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSystemRow(
    String emoji,
    Color bgColor,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _kFg,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: _kMuted, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Icon(Icons.chevron_right, size: 18, color: _kMutedLight),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 58, right: 18),
      color: _kBorder,
    );
  }

  Widget _buildStatusDot(bool active) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: active ? _kSuccess : _kMutedLight,
        shape: BoxShape.circle,
        boxShadow: active
            ? [
                BoxShadow(
                  color: _kSuccess.withValues(alpha: 0.5),
                  blurRadius: 6,
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildToggle(bool value, VoidCallback onTap, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          color: value ? _kAccent : _kBorder,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 450),
              curve: const Cubic(0.34, 1.56, 0.64, 1),
              left: value ? 25 : 3,
              top: 3,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: value
                          ? _kAccent.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.12),
                      blurRadius: value ? 8 : 4,
                      offset: Offset(0, value ? 2 : 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: _openSystemSettings,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '打开系统通知设置',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _kFg,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 16, color: _kFg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemHint() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
      child: Text(
        '需要系统权限才能发送推送通知\n点击上方按钮跳转至系统设置页',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: _kMutedLight, height: 1.5),
      ),
    );
  }

  Widget _buildToast() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: const Cubic(0.34, 1.56, 0.64, 1),
      bottom: _toastVisible ? 40 : -80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _kFg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            _toastMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
