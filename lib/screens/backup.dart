import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/common/secure_storage.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/models/backup.dart';
import 'package:wenshiji/widget/backup/record_card.dart';
import 'package:wenshiji/widget/backup/confirm_sheet.dart';
import 'package:wenshiji/providers/app_config.dart';
import 'package:wenshiji/providers/backup.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/services/backup_service.dart';
import 'package:wenshiji/services/webdav_service.dart';

const _kBg = Color(0xFFFFFDF7);
const _kSurface = Color(0xFFFFFFFF);
const _kCard = Color(0xFFFFFFFF);
const _kFg = Color(0xFF4A3828);
const _kMuted = Color(0xFF9E8870);
const _kBorder = Color(0xFFEDE0D0);
const _kAccent = Color(0xFFF5B041);
const _kAccentSoft = Color(0xFFFFF0D3);
const _kAccentDeep = Color(0xFFC78A17);
const _kSuccess = Color(0xFF52B788);
const _kRadius = 16.0;
const _kRadiusSm = 10.0;

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen>
    with SingleTickerProviderStateMixin {
  bool _isConnected = false;
  bool _isPasswordVisible = false;

  bool _sheetVisible = false;
  String _sheetTitle = '';
  String _sheetDesc = '';
  String _sheetConfirmText = '';
  bool _sheetIsDanger = false;
  String? _pendingAction;
  String? _pendingRecordId;

  bool _isTestingConnection = false;
  bool _isBackingUp = false;

  /// 正在恢复的备份 id（防重入 + 按钮 loading 标记）。
  String? _restoringId;

  String _testButtonLabel = '测试连接';
  bool _testSuccess = false;
  late WebdavService _webdav;
  final TextEditingController _serverUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _directoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initTextFromFuture();
  }

  // 异步初始化方法：从 SecureStorage 读取凭据，从 AppConfig 读取目录。
  Future<void> _initTextFromFuture() async {
    final asyncValue = await ref.read(appConfigProvider.future);
    final credentials = await SecureStorage().getWebdavCredentials();

    if (mounted) {
      _serverUrlController.text = credentials?.serverUrl ?? '';
      _usernameController.text = credentials?.username ?? '';
      _passwordController.text = credentials?.password ?? '';
      _directoryController.text = asyncValue.backupDirectory;
    }
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _directoryController.dispose();
    super.dispose();
  }

  void _testConnection() async {
    // 凭据写入 SecureStorage（加密存储），目录写入 AppConfig。
    await SecureStorage().saveWebdavCredentials(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      serverUrl: _serverUrlController.text.trim(),
    );

    await ref
        .read(appConfigProvider.notifier)
        .setBackupDirectory(_directoryController.text);
    final url = _serverUrlController.text.trim();
    final user = _usernameController.text.trim();
    final pwd = _passwordController.text.trim();
    if (url.isEmpty) {
      Utils().showToast('请输入 WebDAV 配置', null);
      return;
    }

    setState(() {
    _isTestingConnection = true;
      _testButtonLabel = '连接中…';
      _testSuccess = false;
    });
    try {
      _webdav = WebdavService.fromCredentials(url: url, user: user, pwd: pwd);
      await _webdav.testConnection();

      if (mounted) {
        setState(() {
          _isConnected = true;
          _testButtonLabel = '连接成功 ✓';
          _testSuccess = true;
          _isTestingConnection = false;
        });
        Utils().showToast('WebDAV 连接成功', null);
        await Future.delayed(const Duration(milliseconds: 2500));
        if (mounted) {
          setState(() {
            _testButtonLabel = '测试连接';
            _testSuccess = false;
            _isTestingConnection = false;
          });
        }
      }
    } catch (e) {
      Utils().showToast('连接失败，请检查配置', null);
      if (mounted) {
        setState(() {
          _testButtonLabel = '测试连接';
          _testSuccess = false;
          _isTestingConnection = false;
        });
      }
    }
  }

  void _doBackup() async {
    setState(() {
      _isBackingUp = true;
    });
   
    final dir = await ref
        .read(appConfigProvider.future)
        .then((value) => value.backupDirectory);
    try {
      await _webdav.mkdirAll(dir);
    } catch (e) {
      Utils().showErrorToast('创建备份目录失败，请检查配置', null);
      AppLogger().error('创建备份目录失败', error: e);
    }
    final nowTime = DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
    final fileName = nowTime;
    try {
      // 从数据库（而非 provider state）取事件，避免把「库为空时的样本事件」写进备份。
      final appConfig = await ref.read(appConfigProvider.future);
      final events = await ref.read(eventRepositoryProvider).getAllEvents();
      final payload = BackupData(
        version: 2,
        exportedAt: DateTime.now(),
        events: events,
        appConfig: appConfig,
      );
      final fileContent = jsonEncode(payload.toJson());

      // 原子写入本地缓存文件，再上传。
      final localFile = await BackupService().writeLocalBackupAtomically(
        fileName: fileName,
        content: fileContent,
      );
      AppLogger().info('备份文件创建成功: ${localFile.path}');

      await BackupService().uploadBackupAndRefreshLocal(
        localFilePath: localFile.path,
        remoteDir: dir,
        webdav: _webdav,
      );
      AppLogger().info('备份文件上传成功');

      final records = await BackupService().getBackupRecords();

      await ref.read(backupProvider.notifier).setBackupRecords(records);
      Utils().showToast('备份成功 ✓', null);
    } catch (e) {
      AppLogger().error('备份失败', error: e);
      Utils().showErrorToast('备份失败，请检查配置', null);
    } finally {
      if (mounted) {
        setState(() {
          _isBackingUp = false;
        });
      }
    }
  }

  /// 真实恢复：下载指定备份 → 解析校验 → 事务内清空并批量写入事件 →
  /// 同步 AppConfig → 刷新事件 / 备份列表。任一步失败给出明确提示且不改动数据。
  Future<void> _restoreFromRecord(String id) async {
    if (!mounted) return;
    if (_restoringId != null) return; // 防重入

    setState(() {
      _restoringId = id;
    });

    try {
      final dir = await ref
          .read(appConfigProvider.future)
          .then((value) => value.backupDirectory);

      final localPath = await BackupService().downloadRemoteBackupToTemp(
        remoteDir: dir,
        fileName: id,
        webdav: _webdav,
      );
      final payload = await BackupService().readBackupFileAt(localPath);

      if (payload.version >= 2 && payload.events.isEmpty) {
        // 版本 2 但事件为空：可能是备份时库确实为空，仍允许恢复（清空为一致状态）。
        AppLogger().info('备份 v${payload.version} 事件为空，恢复后将清空事件列表');
      }

      // 事务内清空 + 批量写入：失败自动回滚，不会留下半截数据。
      await ref.read(eventRepositoryProvider).replaceAllEvents(payload.events);

      // 整体恢复配置（保留本机的 WorkManager 注册标记）。
      await ref
          .read(appConfigProvider.notifier)
          .restoreConfig(payload.appConfig);

      AppLogger().info('恢复成功：${payload.events.length} 条事件');

      if (!mounted) return;
      // 事件已被整体替换，重建 provider 让首页 / 统计重新加载。
      ref.invalidate(eventProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已恢复 ${payload.events.length} 条事件 ✓')));
    } catch (e, s) {
      AppLogger().error('恢复失败', error: e, stack: s);
      if (mounted) {
        Utils().showErrorToast('恢复失败：备份文件不可用', null);
      }
    } finally {
      if (mounted) {
        setState(() {
          _restoringId = null;
        });
      }
    }
  }

  void _deleteRecord(String id) {
    _pendingAction = 'delete';
    _pendingRecordId = id;
    _showSheet(
      title: '删除云端备份',
      desc: '此操作将永久删除该云端备份文件，删除后无法恢复。',
      confirmText: '确认删除',
      isDanger: true,
    );
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
                Expanded(child: _buildScrollContent()),
              ],
            ),
          ),
          if (_sheetVisible) _buildSheetOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: _kSurface,
        border: Border(bottom: BorderSide(color: _kBorder, width: 1)),
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
        decoration: BoxDecoration(color: _kAccentSoft, shape: BoxShape.circle),
        child: Center(
          child: Icon(Icons.arrow_back_ios_new, size: 22, color: _kAccentDeep),
        ),
      ),
    );
  }

  Widget _buildScrollContent() {
    final records = ref.watch(backupProvider);
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _buildConfigCard(),
        //const SizedBox(height: 16),
        _buildActionSection(),
        const SizedBox(height: 16),
        records.when(
          data: (data) =>
              data.isEmpty ? _buildEmptyState() : _buildRecordsSection(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text(error.toString()),
        ),
      ],
    );
  }

  Widget _buildConfigCard() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            style: TextStyle(fontSize: 12, color: _kMuted, height: 1.5),
          ),
          const SizedBox(height: 16),
          buildField(
            '服务器地址',
            Icons.language_outlined,
            _serverUrlController,
            '请输入服务器地址',
          ),
          const SizedBox(height: 14),
          buildField(
            '账户用户名',
            Icons.person_outlined,
            _usernameController,
            '请输入用户名',
          ),
          const SizedBox(height: 14),
          _buildPasswordField(),
          const SizedBox(height: 14),
          buildField(
            '子文件夹',
            Icons.folder_outlined,
            _directoryController,
            '请输入子文件夹',
          ),

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

  Widget buildField(
    String label,
    IconData icon,
    TextEditingController controller,
    String hintText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: _kMuted),
            const SizedBox(width: 4),
            Text(
              label,
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
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: _kMuted.withValues(alpha: 0.7)),
            filled: true,
            fillColor: _kBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_kRadiusSm),
              borderSide: BorderSide(color: _kAccent, width: 1.5),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: _kFg),
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
            Icon(Icons.lock_outline, size: 14, color: _kMuted),
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
            hintStyle: TextStyle(color: _kMuted.withValues(alpha: 0.7)),
            filled: true,
            fillColor: _kBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
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
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: _kMuted,
                ),
              ),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: _kFg),
        ),
      ],
    );
  }

  Widget _buildTestButton() {
    return InkWell(
      onTap: !_isTestingConnection ? _testConnection : null,
      borderRadius: BorderRadius.circular(_kRadiusSm),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kRadiusSm),
          border: Border.all(
            color: _testSuccess ? _kSuccess : _kAccent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isTestingConnection)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(_kMuted),
                ),
              ),
            if (_isTestingConnection) const SizedBox(width: 8),
            Text(
              _testButtonLabel,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _testSuccess ? const Color(0xFF2D6A4F) : _kAccentDeep,
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
          //const SizedBox(height: 10),
          //_buildRestoreButton(),
        ],
      ),
    );
  }

  Widget _buildBackupButton() {
    return InkWell(
      onTap: _isConnected && !_isBackingUp ? _doBackup : null,
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 22,
                  color: _isConnected ? _kFg : _kMuted,
                ),
                const SizedBox(width: 10),
                Text(
                  _isBackingUp ? '备份中…' : '云端备份',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _isConnected ? _kFg : _kMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsSection() {
    final records = ref.watch(backupProvider);

    return records.when(
      data: (data) => Container(
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
                  '${data.length} 条记录',
                  style: TextStyle(
                    fontSize: 12,
                    color: _kMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...data.map((record) => _buildRecordCard(record)),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }

  Widget _buildRecordCard(BackupRecord record) {
    return BackupRecordCard(
      record: record,
      restoringId: _restoringId,
      onRestore: () => _restoreFromRecord(record.id),
      onDelete: () => _deleteRecord(record.id),
    );
  }
  Widget _buildEmptyState() {
    return const BackupEmptyState();
  }
  Widget _buildSheetOverlay() {
    return ConfirmSheet(
      title: _sheetTitle,
      desc: _sheetDesc,
      confirmText: _sheetConfirmText,
      isDanger: _sheetIsDanger,
      onConfirm: _confirmSheet,
      onCancel: _closeSheet,
    );
  }
  void _showSheet({
    required String title,
    required String desc,
    required String confirmText,
    required bool isDanger,
  }) {
    setState(() {
      _sheetTitle = title;
      _sheetDesc = desc;
      _sheetConfirmText = confirmText;
      _sheetIsDanger = isDanger;
      _sheetVisible = true;
    });
  }

  void _closeSheet() {
    setState(() => _sheetVisible = false);
  }

  void _confirmSheet() async {
    if (_pendingAction == 'delete' && _pendingRecordId != null) {
      try {
        final dir = await ref
            .read(appConfigProvider.future)
            .then((value) => value.backupDirectory);
        final filePath = path.join(dir, _pendingRecordId!);
        AppLogger().debug('删除远程备份: $filePath');
        await BackupService().deleteRemoteBackupAndRefreshLocal(
          remoteDir: dir,
          fileName: _pendingRecordId!,
          webdav: _webdav,
        );
        if (!mounted) return;
        Utils().showToast('删除成功 ✓', null);

        final records = await BackupService().getBackupRecords();

        if (!mounted) return;
        await ref.read(backupProvider.notifier).setBackupRecords(records);
      } catch (e) {
        if (!mounted) return;
        Utils().showToast('删除失败', null);
      } finally {
        if (mounted) {
          _closeSheet();
        }
      }

      _pendingAction = null;
      _pendingRecordId = null;
    }
    _closeSheet();
  }
}
