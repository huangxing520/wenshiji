
import 'dart:math';
import 'package:flutter/material.dart';

const _kPrimaryDark = Color(0xFF5D4037);
const _kPrimary = Color(0xFF795548);
const _kSecondary = Color(0xFF8D6E63);
const _kTertiary = Color(0xFFA1887F);
const _kQuaternary = Color(0xFFBCAAA4);
const _kAmber = Color(0xFFFFC107);
const _kOrange = Color(0xFFFFA726);
const _kAmberDark = Color(0xFFFF8F00);
const _kAmberOrange = Color(0xFFFF9800);
const _kGreen = Color(0xFF81C784);
const _kBlue = Color(0xFF64B5F6);
const _kPurple = Color(0xFFBA68C8);
const _kRed = Color(0xFFFF5722);
const _kSuccess = Color(0xFF66BB6A);
const _kWarning = Color(0xFFFFB300);
const _kSplashBgTop = Color(0xFFFFF8E1);
const _kSplashBgMid = Color(0xFFFFF3E0);
const _kSplashBgBottom = Color(0xFFFFE0B2);
const _kDividerColor = Color(0x1FFFA000);

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _toastVisible = false;
  String _toastMessage = '';

  bool _showUpdateModal = false;
  bool _showIntroModal = false;
  bool _showOpenSrcModal = false;
  bool _showCloudModal = false;
  bool _showFeedbackModal = false;
  bool _showAgreementPage = false;
  String _agreementPageTitle = '';
  String _agreementPageBody = '';

  bool _isLatestVersion = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSplashBgTop,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_kSplashBgTop, _kSplashBgMid, _kSplashBgBottom],
                stops: [0, 0.4, 1],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopNav(),
                  Expanded(child: _buildScrollContent()),
                ],
              ),
            ),
          ),
          if (_toastVisible) _buildToast(),
          if (_showUpdateModal) _buildUpdateModal(),
          if (_showIntroModal) _buildIntroModal(),
          if (_showOpenSrcModal) _buildOpenSrcModal(),
          if (_showCloudModal) _buildCloudModal(),
          if (_showFeedbackModal) _buildFeedbackModal(),
          if (_showAgreementPage) _buildAgreementPage(),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _buildBackButton(),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '关于我们',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _kPrimaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _kAmber.withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios,
          color: _kPrimaryDark,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildScrollContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildBrandSection(),
        _buildSoftDivider(),
        _buildMenuSection(),
        _buildFooter(),
      ],
    );
  }

  Widget _buildBrandSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        children: [
          _buildBrandLogo(),
          const SizedBox(height: 20),
          const Text(
            '温时记',
            style: TextStyle(
              fontFamily: 'LXGW WenKai',
              fontSize: 32,
              color: _kPrimaryDark,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '记录每一段温柔时光',
            style: TextStyle(
              fontSize: 13,
              color: _kTertiary,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20),
          _buildVersionCheckButton(),
        ],
      ),
    );
  }

  Widget _buildBrandLogo() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 5),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final y = sin(value * 2 * pi) * 6;
        return Transform.translate(
          offset: Offset(0, y),
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_kAmber, _kOrange],
              ),
              boxShadow: [
                BoxShadow(
                  color: _kAmberDark.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text('🌙', style: TextStyle(fontSize: 40)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVersionCheckButton() {
    return InkWell(
      onTap: _checkUpdate,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: _kAmber.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '当前版本 V1.2.0',
              style: TextStyle(
                fontSize: 12,
                color: _kSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Row(
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 3),
                  tween: Tween(begin: 0, end: 1),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    double angle = 0;
                    if (value >= 0.8 && value <= 0.9) {
                      angle = ((value - 0.8) / 0.1 * 30 * pi / 180);
                      if (angle > 30 * pi / 180) {
                        angle = (0.9 - value) / 0.1 * 30 * pi / 180;
                      }
                    }
                    return Transform.rotate(
                      angle: angle,
                      child: const Icon(
                        Icons.refresh,
                        size: 12,
                        color: _kAmberDark,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 3),
                const Text(
                  '点击检测更新',
                  style: TextStyle(
                    fontSize: 12,
                    color: _kAmberDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoftDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 44),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.transparent, _kDividerColor, Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          _buildMenuItem(
            icon: '🔄',
            iconBg: _kAmber.withValues(alpha: 0.12),
            title: '版本检测更新',
            desc: '查看更新日志与新功能介绍',
            onTap: _checkUpdate,
          ),
          _buildMenuSeparator(),
          _buildMenuItem(
            icon: '✨',
            iconBg: _kAmberOrange.withValues(alpha: 0.1),
            title: '产品介绍',
            desc: '倒计时 · 生日记录 · 正计时打卡 · 时光热力复盘 · WebDAV备份',
            onTap: () => setState(() => _showIntroModal = true),
          ),
          _buildMenuSeparator(),
          _buildMenuItem(
            icon: '📖',
            iconBg: _kGreen.withValues(alpha: 0.15),
            title: '开源声明',
            desc: '本应用使用霞鹜文楷开源免费商用字体',
            onTap: () => setState(() => _showOpenSrcModal = true),
          ),
          _buildMenuSeparator(),
          _buildMenuItem(
            icon: '☁️',
            iconBg: _kBlue.withValues(alpha: 0.12),
            title: '云端服务说明',
            desc: 'WebDAV私有云备份，数据仅用户私有',
            onTap: () => setState(() => _showCloudModal = true),
          ),
          _buildMenuSeparator(),
          _buildMenuItem(
            icon: '📋',
            iconBg: _kTertiary.withValues(alpha: 0.1),
            title: '用户协议',
            desc: '查看完整用户服务协议',
            onTap: () => _openAgreementPage('agreement'),
          ),
          _buildMenuSeparator(),
          _buildMenuItem(
            icon: '🔒',
            iconBg: _kPurple.withValues(alpha: 0.1),
            title: '隐私政策',
            desc: '了解数据收集、存储与使用规则',
            onTap: () => _openAgreementPage('privacy'),
          ),
          _buildMenuSeparator(),
          _buildMenuItem(
            icon: '💌',
            iconBg: _kRed.withValues(alpha: 0.1),
            title: '反馈与求助',
            desc: '提交问题、建议或功能需求',
            onTap: () => setState(() => _showFeedbackModal = true),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required Color iconBg,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(icon)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _kPrimaryDark,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _kTertiary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: _kQuaternary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSeparator() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 54),
      color: _kAmber.withValues(alpha: 0.06),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
      child: Column(
        children: [
          const Text(
            '©2026 温时记 All Rights Reserved',
            style: TextStyle(
              fontSize: 11,
              color: _kQuaternary,
              height: 1.8,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '本应用仅作个人时光记录工具\n数据由用户自主保管',
            style: TextStyle(
              fontSize: 10,
              color: _kTertiary.withValues(alpha: 0.45),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildToast() {
    return Positioned(
      top: 56,
      left: 0,
      right: 0,
      child: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 350),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, -20 + value * 20),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: _kPrimaryDark.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    _toastMessage,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUpdateModal() {
    return _buildModalOverlay(
      child: _buildModalDialog(
        icon: _isLatestVersion ? '✅' : '🆕',
        iconBg: _isLatestVersion
            ? _kSuccess.withValues(alpha: 0.12)
            : _kWarning.withValues(alpha: 0.12),
        title: _isLatestVersion ? '已是最新版本' : '发现新版本',
        body: _isLatestVersion
            ? '当前版本 V1.2.0 已为最新，无需更新。'
            : '新版本 V1.3.0 已发布\n· 新增时光热力复盘功能\n· 优化小组件加载速度\n· 修复已知问题',
        isRichBody: !_isLatestVersion,
        primaryBtnText: _isLatestVersion ? '知道了' : '立即更新',
        secondaryBtnText: _isLatestVersion ? null : '稍后更新',
        onPrimaryTap: () {
          setState(() => _showUpdateModal = false);
          if (!_isLatestVersion) _showToast('正在下载更新…');
        },
        onSecondaryTap: _isLatestVersion
            ? null
            : () => setState(() => _showUpdateModal = false),
      ),
      onDismiss: () => setState(() => _showUpdateModal = false),
    );
  }

  Widget _buildIntroModal() {
    return _buildModalOverlay(
      child: _buildModalDialog(
        icon: '✨',
        iconBg: _kWarning.withValues(alpha: 0.12),
        title: '产品介绍',
        body: '''⏳ 倒计时　为每一个重要日子设置倒计时，时刻铭记即将到来的温暖时刻
🎂 生日记录　记录家人朋友的生日，自动提醒永不遗忘
📝 正计时打卡　从某个起点开始计算时光长度，见证每段旅程
🔥 时光热力复盘　以热力图回顾一年的记录分布，直观感受时光痕迹
☁️ WebDAV云端备份　私有云安全备份，数据仅你可见，隐私完全可控''',
        isRichBody: true,
        primaryBtnText: '了解了',
        onPrimaryTap: () => setState(() => _showIntroModal = false),
      ),
      onDismiss: () => setState(() => _showIntroModal = false),
    );
  }

  Widget _buildOpenSrcModal() {
    return _buildModalOverlay(
      child: _buildModalDialog(
        icon: '📖',
        iconBg: _kGreen.withValues(alpha: 0.15),
        title: '开源声明',
        body: '''本应用在界面渲染中使用以下开源字体：

霞鹜文楷
作者：落霞与孤鹜
开源协议：OFL (SIL Open Font License 1.1)
授权方式：免费商用，允许自由使用、修改和分发

该字体项目主页：
github.com/lxgw/LxgwWenKai

感谢开源社区的慷慨贡献，让我们能够使用如此优美的中文手写风格字体。本应用严格遵守其开源协议，未做任何违反授权条款的使用。''',
        isRichBody: true,
        primaryBtnText: '确认',
        onPrimaryTap: () => setState(() => _showOpenSrcModal = false),
      ),
      onDismiss: () => setState(() => _showOpenSrcModal = false),
    );
  }

  Widget _buildCloudModal() {
    return _buildModalOverlay(
      child: _buildModalDialog(
        icon: '☁️',
        iconBg: _kBlue.withValues(alpha: 0.12),
        title: '云端服务说明',
        body: '''备份方式：WebDAV 协议
温时记采用 WebDAV 国际标准协议实现云端数据同步，不依赖任何第三方云存储服务。

数据完全私有
所有备份数据存储在你个人拥有的 WebDAV 服务器上，应用开发者无法访问、也无法获取你的任何数据。

隐私完全可控
你可以随时在设置中开启或关闭自动备份，也可以手动导出或删除云端数据。本地数据始终以你设备上的版本为准。

支持的 WebDAV 服务
坚果云 · Nextcloud · 群晖 WebDAV · 其他兼容服务''',
        isRichBody: true,
        primaryBtnText: '明白了',
        onPrimaryTap: () => setState(() => _showCloudModal = false),
      ),
      onDismiss: () => setState(() => _showCloudModal = false),
    );
  }

  Widget _buildFeedbackModal() {
    return _buildModalOverlay(
      child: _buildModalDialog(
        icon: '💌',
        iconBg: _kRed.withValues(alpha: 0.1),
        title: '反馈与求助',
        body: '我们将跳转至个人中心的反馈入口，\n你可以在那里提交问题或建议。',
        primaryBtnText: '前往反馈',
        secondaryBtnText: '取消',
        onPrimaryTap: () {
          setState(() => _showFeedbackModal = false);
          _showToast('已跳转至反馈入口');
        },
        onSecondaryTap: () => setState(() => _showFeedbackModal = false),
      ),
      onDismiss: () => setState(() => _showFeedbackModal = false),
    );
  }

  Widget _buildModalOverlay({
    required Widget child,
    required VoidCallback onDismiss,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            child: Container(color: Colors.black.withValues(alpha: 0.25)),
          ),
        ),
        Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.85 + value * 0.15,
                child: Transform.translate(
                  offset: Offset(0, 10 - value * 10),
                  child: Opacity(opacity: value, child: child),
                ),
              );
            },
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildModalDialog({
    required String icon,
    required Color iconBg,
    required String title,
    required String body,
    bool isRichBody = false,
    String? primaryBtnText,
    String? secondaryBtnText,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSecondaryTap,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300, maxHeight: 500),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isRichBody ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(icon)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _kPrimaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            isRichBody
                ? _buildRichText(body)
                : Text(
                    body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _kSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (secondaryBtnText != null) ...[
                  Expanded(
                    child: _buildModalButton(
                      text: secondaryBtnText,
                      isPrimary: false,
                      onTap: onSecondaryTap,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                if (primaryBtnText != null)
                  Expanded(
                    child: _buildModalButton(
                      text: primaryBtnText,
                      isPrimary: true,
                      onTap: onPrimaryTap,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String content) {
    final lines = content.split('\n');
    final List<TextSpan> spans = [];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final isEmojiStart = line.startsWith('⏳') ||
          line.startsWith('🎂') ||
          line.startsWith('📝') ||
          line.startsWith('🔥') ||
          line.startsWith('☁️');
      final isTitleStart = line.startsWith('备份方式') ||
          line.startsWith('数据完全私有') ||
          line.startsWith('隐私完全可控') ||
          line.startsWith('支持的 WebDAV 服务') ||
          line.startsWith('霞鹜文楷') ||
          line.startsWith('作者') ||
          line.startsWith('开源协议') ||
          line.startsWith('授权方式') ||
          line.startsWith('该字体项目主页');

      if (isEmojiStart || isTitleStart) {
        if (isEmojiStart) {
          final parts = line.split('　');
          spans.add(TextSpan(
            text: '${parts[0]}　',
            style: const TextStyle(
              fontSize: 13,
              color: _kPrimaryDark,
              fontWeight: FontWeight.w700,
            ),
          ));
          if (parts.length > 1) {
            spans.add(TextSpan(
              text: parts.sublist(1).join('　'),
              style: const TextStyle(fontSize: 13, color: _kSecondary),
            ));
          }
        } else {
          spans.add(TextSpan(
            text: line,
            style: const TextStyle(
              fontSize: 13,
              color: _kPrimaryDark,
              fontWeight: FontWeight.w700,
            ),
          ));
        }
      } else {
        spans.add(TextSpan(
          text: line,
          style: const TextStyle(fontSize: 13, color: _kSecondary),
        ));
      }
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      style: const TextStyle(height: 2),
    );
  }

  Widget _buildModalButton({
    required String text,
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          gradient: isPrimary
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_kAmber, _kOrange],
                )
              : null,
          color: isPrimary ? null : _kAmber.withValues(alpha: 0.06),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: _kAmberDark.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : _kPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementPage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_kSplashBgTop, _kSplashBgBottom],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _buildBackButtonWithCallback(
                    onTap: () => setState(() => _showAgreementPage = false),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _agreementPageTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _kPrimaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: _buildAgreementBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButtonWithCallback({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _kAmber.withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios,
          color: _kPrimaryDark,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildAgreementBody() {
    final content = _agreementPageBody;
    final sections = content.split('##');
    final List<Widget> children = [];

    for (var section in sections) {
      if (section.trim().isEmpty) continue;
      final lines = section.trim().split('\n');
      if (lines.isNotEmpty) {
        final title = lines.first.trim();
        final body = lines.sublist(1).join('\n').trim();
        children.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (children.isNotEmpty) const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _kPrimaryDark,
                ),
              ),
              if (body.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _kPrimary,
                    height: 1.8,
                  ),
                ),
              ],
            ],
          ),
        );
      }
    }

    if (children.isNotEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              '生效日期：2026年1月1日',
              style: TextStyle(
                fontSize: 12,
                color: _kTertiary.withValues(alpha: 0.45),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  void _showToast(String message) {
    setState(() {
      _toastMessage = message;
      _toastVisible = true;
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  void _checkUpdate() {
    setState(() {
      _isLatestVersion = (DateTime.now().millisecond % 10) > 2;
      _showUpdateModal = true;
    });
  }

  void _openAgreementPage(String type) {
    if (type == 'agreement') {
      _agreementPageTitle = '用户协议';
      _agreementPageBody = '''##一、服务条款
欢迎使用「温时记」应用（以下简称"本应用"）。请在使用前仔细阅读以下条款。使用本应用即表示你同意遵守本协议。
本应用为个人时光记录工具，提供生日倒计时、日期记录、正计时打卡、时光热力复盘及 WebDAV 云端备份等功能。

##二、用户责任
你应对自行录入的所有数据内容负责。本应用不存储、不审查、不过滤用户录入的任何内容。
你应妥善保管自己的账户信息和设备安全，因个人原因导致的数据泄露或丢失，本应用不承担责任。

##三、知识产权
本应用的界面设计、代码实现、品牌标识等知识产权归开发者所有。未经授权，不得复制、修改、分发或反向工程本应用的任何部分。
本应用使用的「霞鹜文楷」字体遵循 SIL Open Font License 1.1 开源协议，详细信息请查阅「开源声明」。

##四、免责声明
本应用仅作个人时光记录辅助工具，不对因使用或无法使用本应用导致的任何直接或间接损失承担责任。
因不可抗力、系统故障、网络中断等原因导致的服务暂停或数据丢失，本应用不承担责任。建议你定期通过 WebDAV 或本地导出进行数据备份。

##五、服务变更与终止
开发者保留随时修改、暂停或终止部分或全部服务的权利。重大变更将提前在应用内通知用户。

##六、协议修改
本协议内容可能不时更新，更新后的协议将在应用内公示。继续使用本应用即视为同意修改后的协议。

##七、联系方式
如对本协议有任何疑问，请通过应用内「反馈与求助」入口与我们联系。''';
    } else {
      _agreementPageTitle = '隐私政策';
      _agreementPageBody = '''##一、概述
「温时记」高度重视用户隐私保护。本政策说明本应用对用户数据的收集、存储、使用与保护方式。

##二、数据收集
本应用不主动收集任何用户个人身份信息。
用户自行录入的数据（生日、纪念日、备注等）仅存储在用户本地设备中，开发者无法访问。
本应用不含任何第三方统计分析 SDK，不收集设备信息、位置信息或使用行为数据。

##三、数据存储
所有用户数据默认存储在用户本地设备的应用沙盒目录中。
用户可自主选择通过 WebDAV 协议将数据备份至个人拥有的云端空间。备份数据的存储安全和访问权限完全由用户自行掌控，开发者无能力也无权限访问。

##四、数据使用
用户数据仅用于本应用内的功能呈现（倒计时显示、提醒推送、热力图展示等），不会用于任何其他目的。
本应用不会将用户数据共享、出售或转让给任何第三方。

##五、数据删除
用户可随时在应用内删除单条记录或全部数据。
卸载本应用后，本地所有数据将被系统自动清除。若已启用 WebDAV 备份，云端备份数据需用户自行至云端服务管理界面删除。

##六、数据安全
本应用采用本地加密存储机制保护用户数据安全。WebDAV 传输过程采用 HTTPS 加密协议。
尽管我们尽力保护用户数据，但互联网传输并非绝对安全，建议你使用可靠的 WebDAV 服务提供商并定期检查备份完整性。

##七、儿童隐私
本应用不面向 14 周岁以下儿童提供服务，也不会 knowingly 收集儿童的个人信息。

##八、政策更新
本隐私政策可能不时修订，重大变更将在应用内推送通知。继续使用本应用即视为同意修订后的政策。

##九、联系我们
如对本隐私政策有任何疑问或建议，请通过应用内「反馈与求助」与我们取得联系。''';
    }
    setState(() => _showAgreementPage = true);
  }
}

