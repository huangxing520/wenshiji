import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _kBg = Color(0xFFFFFDF7);
const _kSurface = Color(0xFFFFFFFF);
const _kCard = Color(0xFFFFFFFF);
const _kFg = Color(0xFF4A3828);
const _kMuted = Color(0xFF9E8870);
const _kBorder = Color(0xFFEDE0D0);
const _kAccent = Color(0xFFF5B041);
const _kAccentSoft = Color(0xFFFFF0D3);
const _kAccentDeep = Color(0xFFC78A17);
const _kDanger = Color(0xFFD65A31);
const _kSuccess = Color(0xFF52B788);
const _kRadius = 16.0;
const _kRadiusSm = 10.0;

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> with SingleTickerProviderStateMixin {
  bool _isConnected = false;
  bool _isPasswordVisible = false;
  bool _toastVisible = false;
  String _toastMessage = '';
  bool _sheetVisible = false;
  String _sheetTitle = '';
  String _sheetDesc = '';
  String _sheetConfirmText = '';
  bool _sheetIsDanger = false;
  VoidCallback? _sheetConfirmAction;

  final TextEditingController _serverUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<BackupRecord> _records = [
    BackupRecord(
      id: 1,
      time: '2025-07-14 08:30',
      size: '12.6 KB',
      events: 12,
      status: BackupStatus.success,
    ),
    BackupRecord(
      id: 2,
      time: '2025-07-10 22:15',
      size: '11.8 KB',
      events: 11,
      status: BackupStatus.success,
    ),
    BackupRecord(
      id: 3,
      time: '2025-07-07 09:00',
      size: '10.2 KB',
      events: 10,
      status: BackupStatus.success,
    ),
  ];

  @override
  void dispose() {
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopNav(),
                Expanded(
                  child: _buildScrollContent(),
                ),
              ],
            ),
          ),
          if (_sheetVisible) _buildSheetOverlay(),
          if (_toastVisible) _buildToast(),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: _kSurface,
        border: Border(
          bottom: BorderSide(color: _kBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _buildBackButton(),
          const SizedBox(width: 10),
          Text(
            '云端备份与恢复',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: _kFg,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => context.pop(),
      borderRadius: BorderRadius.circular(21),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: _kAccentSoft,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 22,
            color: _kAccentDeep,
          ),
        ),
      ),
    );
  }

  Widget _buildScrollContent() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _buildConfigCard(),
        const SizedBox(height: 16),
        _buildActionSection(),
        const SizedBox(height: 16),
        _buildRecordsSection(),
      ],
    );
  }

  Widget _buildConfigCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConnectionBadge(),
          const SizedBox(height: 8),
          const Text(
            'WebDAV 云端配置',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _kFg,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '连接你的专属云端存储，安全备份所有重要时刻',
            style: TextStyle(
              fontSize: 12,
              color: _kMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildServerUrlField(),
          const SizedBox(height: 14),
          _buildUsernameField(),
          const SizedBox(height: 14),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildTestButton(),
        ],
      ),
    );
  }

  Widget _buildConnectionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _isConnected ? const Color(0xFFD8F3DC) : const Color(0xFFF0E8DC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: _isConnected ? _kSuccess : _kMuted,
              shape: BoxShape.circle,
              boxShadow: _isConnected
                  ? [
                      BoxShadow(
                        color: _kSuccess.withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _isConnected ? '已连接' : '未连接',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _isConnected ? const Color(0xFF2D6A4F) : _kMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.language_outlined,
              size: 14,
              color: _kMuted,
            ),
            const SizedBox(width: 4),
            Text(
              '服务器地址',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kFg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _serverUrlController,
          decoration: InputDecoration(
            hintText: '请填写云端域名/地址',
            hintStyle: TextStyle(
              color: _kMuted.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: _kBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kAccent, width: 1.5),
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: _kFg,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 14,
              color: _kMuted,
            ),
            const SizedBox(width: 4),
            Text(
              '账户用户名',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kFg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: '请输入用户名',
            hintStyle: TextStyle(
              color: _kMuted.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: _kBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kAccent, width: 1.5),
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: _kFg,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lock_outline,
              size: 14,
              color: _kMuted,
            ),
            const SizedBox(width: 4),
            Text(
              '账户密码',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kFg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: '请输入密码',
            hintStyle: TextStyle(
              color: _kMuted.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: _kBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kAccent, width: 1.5),
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
              borderRadius: BorderRadius.circular(19),
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                child: Icon(
                  _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 18,
                  color: _kMuted,
                ),
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: _kFg,
          ),
        ),
      ],
    );
  }

  Widget _buildTestButton() {
    return InkWell(
      onTap: _testConnection,
      borderRadius: BorderRadius.circular(_kRadiusSm),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kRadiusSm),
          border: Border.all(color: _kAccent, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '测试连接',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _kAccentDeep,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildBackupButton(),
          const SizedBox(height: 10),
          _buildRestoreButton(),
        ],
      ),
    );
  }

  Widget _buildBackupButton() {
    return InkWell(
      onTap: _isConnected ? _doBackup : null,
      borderRadius: BorderRadius.circular(_kRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kRadius),
          color: _isConnected ? _kAccent : const Color(0xFFF0E8DC),
          boxShadow: _isConnected
              ? [
                  BoxShadow(
                    color: _kAccent.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 22,
              color: _isConnected ? _kFg : _kMuted,
            ),
            const SizedBox(width: 10),
            Text(
              '云端备份',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _isConnected ? _kFg : _kMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreButton() {
    return InkWell(
      onTap: _isConnected ? _doRestore : null,
      borderRadius: BorderRadius.circular(_kRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kRadius),
          color: _kCard,
          border: Border.all(
            color: _isConnected ? _kAccent : _kBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_download_outlined,
              size: 22,
              color: _isConnected ? _kAccentDeep : _kMuted,
            ),
            const SizedBox(width: 10),
            Text(
              '云端恢复',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _isConnected ? _kAccentDeep : _kMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: _kAccentDeep,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '备份记录',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _kFg,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Text(
                '${_records.length} 条记录',
                style: TextStyle(
                  fontSize: 12,
                  color: _kMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._records.map((record) => _buildRecordCard(record)),
        ],
      ),
    );
  }

  Widget _buildRecordCard(BackupRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _kFg,
                ),
              ),
              _buildStatusBadge(record.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetaItem(Icons.storage_outlined, record.size),
              const SizedBox(width: 14),
              _buildMetaItem(Icons.event_outlined, '${record.events} 个事件'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRecordButton(
                text: '恢复',
                color: _kAccentSoft,
                textColor: _kAccentDeep,
                onTap: () => _restoreFromRecord(record.id),
              ),
              const SizedBox(width: 8),
              _buildRecordButton(
                text: '删除',
                color: const Color(0xFFF5F0E8),
                textColor: _kMuted,
                onTap: () => _deleteRecord(record.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BackupStatus status) {
    final isSuccess = status == BackupStatus.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0xFFD8F3DC) : const Color(0xFFFFE5E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isSuccess ? '成功' : '失败',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isSuccess ? const Color(0xFF2D6A4F) : _kDanger,
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: _kMuted,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: _kMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSheetOverlay() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _closeSheet,
            child: Container(
              color: _kFg.withValues(alpha: 0.45),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildSheetCard(),
        ),
      ],
    );
  }

  Widget _buildSheetCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _sheetTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _kFg,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _sheetDesc,
              style: TextStyle(
                fontSize: 14,
                color: _kMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSheetButton(
                    text: '取消',
                    onTap: _closeSheet,
                    isPrimary: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSheetButton(
                    text: _sheetConfirmText,
                    onTap: _confirmSheet,
                    isPrimary: true,
                    isDanger: _sheetIsDanger,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_kRadiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kRadiusSm),
          color: isPrimary ? (isDanger ? _kDanger : _kAccent) : _kCard,
          border: isPrimary ? null : Border.all(color: _kBorder, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
            color: isPrimary ? Colors.white : _kFg,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildToast() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height / 2 - 20,
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _toastVisible ? 1 : 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            transform: Matrix4.identity()..scale(_toastVisible ? 1 : 0.9),
            transformAlignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: _kFg.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _toastMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _testConnection() {
    _showToast('连接测试中...');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isConnected = true);
      _showToast('连接成功！');
    });
  }

  void _doBackup() {
    _showToast('开始备份...');
  }

  void _doRestore() {
    _showSheet(
      title: '确认恢复',
      desc: '此操作将覆盖当前本地数据，请确保已备份最新数据。',
      confirmText: '恢复',
      isDanger: false,
      confirmAction: () {
        _showToast('开始恢复...');
      },
    );
  }

  void _restoreFromRecord(int id) {
    _showSheet(
      title: '确认恢复',
      desc: '此操作将覆盖当前本地数据，确定要恢复此备份吗？',
      confirmText: '恢复',
      isDanger: false,
      confirmAction: () {
        _showToast('开始恢复备份...');
      },
    );
  }

  void _deleteRecord(int id) {
    _showSheet(
      title: '确认删除',
      desc: '此操作将永久删除云端备份文件，无法恢复。',
      confirmText: '删除',
      isDanger: true,
      confirmAction: () {
        setState(() {
          _records.removeWhere((r) => r.id == id);
        });
        _showToast('删除成功');
      },
    );
  }

  void _showSheet({
    required String title,
    required String desc,
    required String confirmText,
    required bool isDanger,
    required VoidCallback confirmAction,
  }) {
    setState(() {
      _sheetTitle = title;
      _sheetDesc = desc;
      _sheetConfirmText = confirmText;
      _sheetIsDanger = isDanger;
      _sheetConfirmAction = confirmAction;
      _sheetVisible = true;
    });
  }

  void _closeSheet() {
    setState(() => _sheetVisible = false);
  }

  void _confirmSheet() {
    _closeSheet();
    if (_sheetConfirmAction != null) {
      _sheetConfirmAction!();
    }
  }

  void _showToast(String message) {
    setState(() {
      _toastMessage = message;
      _toastVisible = true;
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() => _toastVisible = false);
      }
    });
  }
}

enum BackupStatus { success, failed }

class BackupRecord {
  final int id;
  final String time;
  final String size;
  final int events;
  final BackupStatus status;

  BackupRecord({
    required this.id,
    required this.time,
    required this.size,
    required this.events,
    required this.status,
  });
}
