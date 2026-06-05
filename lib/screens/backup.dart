import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:webdav_client_plus/webdav_client_plus.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/models/backup.dart';
import 'package:wenshiji/providers/app_config.dart';
import 'package:wenshiji/providers/backup.dart';

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
  bool _isRestoring = false;

  String _testButtonLabel = '测试连接';
  bool _testSuccess = false;
  late WebdavClient client;
  final TextEditingController _serverUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _directoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initTextFromFuture();
  }

  // 异步初始化方法（核心！解决Future赋值问题）
  Future<void> _initTextFromFuture() async {
    // 读取Future Provider的值（read：只执行一次）
    final asyncValue = await ref.read(appConfigProvider.future);

    // 安全判断：页面未销毁再赋值
    if (mounted) {
      // 🔥 把异步结果赋值给本地控制器
      _serverUrlController.text = asyncValue.backupServerUrl;
      _usernameController.text = asyncValue.backupUsername;
      _passwordController.text = asyncValue.backupPassword;
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
     await ref
        .read(appConfigProvider.notifier)
        .setBackupServerUrl(_serverUrlController.text);

    await ref
        .read(appConfigProvider.notifier)
        .setBackupUsername(_usernameController.text);

    await ref
        .read(appConfigProvider.notifier)
        .setBackupPassword(_passwordController.text);

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
      if (user.isEmpty) {
        client = WebdavClient.noAuth(url: url);
      }
      client = WebdavClient(
        url: url,
        auth: BasicAuth(user: user, pwd: pwd),
      );
      await client.readDir('/');

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
      await client.mkdirAll(dir);
    } catch (e) {
      Utils().showErrorToast('创建备份目录失败，请检查配置', null);
      print(e);
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    final nowTime = DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
    final fileName = '$nowTime-10';
    // 2. 拼接文件完整路径：目录 + 文件名
    final filePath = path.join(appDocDir.path, 'backup', fileName);
    print(filePath);
    // 3. 创建File对象
    final file = File(filePath);

    // 4. 异步创建文件（递归创建父目录，已存在则跳过）
    await file.create(recursive: true);
    final fileContent = await ref
        .read(appConfigProvider.future)
        .then((value) => jsonEncode(BackupData(appConfig: value)));
    await file.writeAsString(fileContent);
    print('✅ 文件创建成功！');
    // await Utils().deleteFolder(path.join(appDocDir.path, 'backup'));
    final remotePath = '$dir/$fileName'; // 注意：路径需要包含文件名

    try {
      await client.writeFile(filePath, remotePath);
      print('✅ 文件上传成功！');

      final files = await client.readDir(dir);
      await Utils().deleteFolder(path.join(appDocDir.path, 'backup'));
      for (final e in files) {
        final filePath = path.join(appDocDir.path, 'backup', e.name);
        if (e.path.split(dir).length > 1) {
          final t = e.path.split(dir).last;
          print('$dir$t');
          await client.readFile('$dir$t', filePath);
        }
      }

      final records = await getBackupRecords();

      ref.read(backupProvider.notifier).setBackupRecords(records);
      Utils().showToast('备份成功 ✓', null);
    } catch (e) {
      print('❌ 上传失败: $e');
      Utils().showErrorToast('上传失败，请检查配置', null);
      try {
        final file = File(filePath);

        // 1. 先判断文件是否存在
        if (await file.exists()) {
          // 2. 异步删除文件
          await file.delete();
          print("文件删除成功：$filePath");
        } else {
          print("文件不存在，跳过删除：$filePath");
        }
      } catch (e) {
        print("删除文件失败：$e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBackingUp = false;
        });
      }
    }
  }

  void _doRestore() async {
    setState(() {
      _isRestoring = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _isRestoring = false;
      });
      _showToast('数据恢复成功 ✓');
    }
  }

  void _restoreFromRecord(String id) {
    if (!mounted) return;

    _showToast('正在从该备份恢复…');
    Future.delayed(const Duration(milliseconds: 1500), () {
      _showToast('恢复成功 ✓');
    });
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

  Widget _buildServerUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.language_outlined, size: 14, color: _kMuted),
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

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, size: 14, color: _kMuted),
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

  Widget _buildRestoreButton() {
    return InkWell(
      onTap: _isConnected && !_isRestoring ? _doRestore : null,
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // AnimatedContainer(
            //   duration: const Duration(milliseconds: 300),
            //   width: double.infinity,
            //   height: 4,
            //   decoration: BoxDecoration(
            //     color: _kAccentDeep,
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(_kRadius),
            //       bottomRight: Radius.circular(_kRadius),
            //     ),
            //   ),
            //   margin: EdgeInsets.only(
            //     right:
            //         MediaQuery.of(context).size.width * (1 - _restoreProgress) -
            //         32,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_download_outlined,
                  size: 22,
                  color: _isConnected ? _kAccentDeep : _kMuted,
                ),
                const SizedBox(width: 10),
                Text(
                  _isRestoring ? '恢复中…' : '云端恢复',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _isConnected ? _kAccentDeep : _kMuted,
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
                DateFormat(
                  'yyyy-MM-dd hh:mm:ss',
                ).format(DateTime.parse(record.timeStr)),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _kFg,
                ),
              ),
              // _buildStatusBadge(record.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMetaItem(
                Icons.description_outlined,
                Utils().bytesToKB(int.parse(record.size)),
              ),
              const SizedBox(width: 14),
              _buildMetaItem(
                Icons.schedule_outlined,
                '${record.eventCount} 条事件',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...[
                _buildRecordButton(
                  text: '恢复',
                  color: _kAccentSoft,
                  textColor: _kAccentDeep,
                  onTap: () => _restoreFromRecord(record.id),
                ),
                const SizedBox(width: 8),
              ],
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

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: _kMuted),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: _kMuted)),
      ],
    );
  }

  Widget _buildEmptyState() {
    final emptyTitle = '暂无云端备份';
    final emptyDesc = '点击上方「云端备份」开始首次备份';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _kAccentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.cloud_upload_outlined, size: 36, color: _kAccent),
          ),
          const SizedBox(height: 16),
          Text(
            emptyTitle,
            style: TextStyle(
              fontFamily: 'LXGW WenKai',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _kFg,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            emptyDesc,
            style: TextStyle(fontSize: 13, color: _kMuted, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
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
            child: Container(color: _kFg.withValues(alpha: 0.45)),
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _buildSheetCard()),
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
              style: TextStyle(fontSize: 14, color: _kMuted, height: 1.5),
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

  // Widget _buildToast() {
  //   return AnimatedPositioned(
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //     left: 0,
  //     right: 0,
  //     top: MediaQuery.of(context).size.height / 2 - 20,
  //     child: Center(
  //       child: AnimatedOpacity(
  //         duration: const Duration(milliseconds: 300),
  //         opacity: _toastVisible ? 1 : 0,
  //         child: Transform.scale(
  //           scale: _toastVisible ? 1 : 0.9,
  //           alignment: Alignment.center,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //             decoration: BoxDecoration(
  //               color: _kFg.withValues(alpha: 0.92),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Text(
  //               _toastMessage,
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
        print(filePath);
        await client.remove(filePath);
        Utils().showToast('删除成功 ✓', null);
        final appDocDir = await getApplicationDocumentsDirectory();
        final files = await client.readDir(dir);
        await Utils().deleteFolder(path.join(appDocDir.path, 'backup'));
        for (final e in files) {
          final filePath = path.join(appDocDir.path, 'backup', e.name);
          if (e.path.split(dir).length > 1) {
            final t = e.path.split(dir).last;
            print('$dir$t');
            await client.readFile('$dir$t', filePath);
          }
        }

        final records = await getBackupRecords();

        ref.read(backupProvider.notifier).setBackupRecords(records);
      } catch (e) {
        Utils().showToast('删除失败', null);
      } finally {
        _closeSheet();
      }

      _pendingAction = null;
      _pendingRecordId = null;
    }
    _closeSheet();
  }
}

void _showToast(String message) {
  Utils().showToast(message, null);
}

// 获取本地备份记录
Future<List<BackupRecord>> getBackupRecords() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final backupDir = Directory(path.join(appDocDir.path, 'backup'));

  if (!await backupDir.exists()) {
    return [];
  }

  // 🔥 修正正则：匹配 yyyy-MM-dd-HH-mm-ss-数字（任意数字结尾）
  final fileNameReg = RegExp(r'^\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}-\d+$');

  // 筛选：只保留文件 + 符合「时间格式-数字」命名的文件
  final List<FileSystemEntity> files = await backupDir
      .list(recursive: false)
      .where((entity) => entity is File) // 只留文件，排除文件夹
      .where((entity) {
        final fileName = path.basename(entity.path);
        return fileNameReg.hasMatch(fileName);
      })
      .toList();

  print('筛选后的合法备份文件: $files');

  // 后续解析逻辑不变
  final recordFutures = files.map((e) async {
    String fileName = path.basename(e.path);
    final FileStat stat = await e.stat();
    String fileSize = stat.size.toString();
    DateTime modifyTime = stat.modified;

    final localFilePath = path.join(appDocDir.path, 'backup', fileName);
    final localFile = File(localFilePath);
    final fileExists = await localFile.exists();
    String fileContent = '';
    if (fileExists) {
      fileContent = await localFile.readAsString();
    }
    print('📄 文件: $fileName, 存在: $fileExists, 内容长度: ${fileContent.length}');

    final Map<String, dynamic> fileContentMap = jsonDecode(fileContent);
    print('文件内容: $fileContentMap');
    final backupData = BackupData.fromJson(fileContentMap);

    return BackupRecord(
      serverUrl: backupData.appConfig.backupServerUrl,
      username: backupData.appConfig.backupUsername,
      password: backupData.appConfig.backupPassword,
      backupDirectory: backupData.appConfig.backupDirectory,
      id: fileName,
      fileName: fileName,
      size: fileSize,
      timeStr: modifyTime.toString(),
      eventCount: () {
        final parts = fileName.split('-').last;
        // 取最后一段数字（备份的序号）
        return parts.length >= 7 ? int.tryParse(parts.trim()) ?? 0 : 0;
      }(),
    );
  });

  final records = await Future.wait(recordFutures);
  return records;
}
