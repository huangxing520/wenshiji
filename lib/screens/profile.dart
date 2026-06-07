import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wenshiji/common/http.dart';
import 'package:wenshiji/common/logger.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:wenshiji/common/preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, required this.version});
  final String version;
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  final List<_ParticleData> _particles = [];
  final math.Random _random = math.Random();
  String _deviceId = '';
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _particleController.repeat();
    _spawnParticles();
  }

  Future<void> _loadDeviceId() async {
    final id = await preferences.getDeviceId();
    if (mounted) {
      setState(() {
        _deviceId = id;
      });
      _fetchAvatar(id);
    }
  }

  Future<void> _fetchAvatar(String seed) async {
    final url =
        'https://api.dicebear.com/10.x/notionists/png?size=256&borderRadius=50&backgroundColor=D4A75F&seed=$seed';
    try {
      final response = await HttpUtil().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          connectTimeout: const Duration(milliseconds: 500),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          },
        ),
      );
      if (mounted) {
        setState(() {
          _avatarBytes = Uint8List.fromList(response);
        });
      }
    } catch (e) {
      AppLogger().error('Avatar fetch error: $e, loading local avatar');
      try {
        final byteData = await rootBundle.load('assets/icon/avatar.png');
        if (mounted) {
          setState(() {
            _avatarBytes = byteData.buffer.asUint8List();
          });
        }
      } catch (localError) {
        AppLogger().error('Local avatar load error: $localError');
      }
    }
  }

  void _spawnParticles() {
    for (int i = 0; i < 10; i++) {
      _particles.add(
        _ParticleData(
          left: 8 + _random.nextDouble() * 84,
          size: 3 + _random.nextDouble() * 6,
          delay: _random.nextDouble() * 3,
        ),
      );
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1600),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          SafeArea(
            child: Column(
              children: [
                //_buildStatusBar(bgColor, fgColor, surfaceColor),
                _buildTopNav(
                  accentSoftColor,
                  accentDeepColor,
                  fgColor,
                  surfaceColor,
                  borderColor,
                ),
                Expanded(
                  child: _buildContentScroll(
                    surfaceColor,
                    accentSoftColor,
                    accentDeepColor,
                    accentColor,
                    borderColor,
                    fgColor,
                    mutedColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(Color bgColor, Color fgColor, Color surfaceColor) {
    return Container(
      height: 44,
      color: surfaceColor,
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
    Color surfaceColor,
    Color borderColor,
  ) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            '个人中心',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: fgColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentScroll(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color accentColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHero(
            accentColor,
            accentSoftColor,
            accentDeepColor,
            fgColor,
            mutedColor,
          ),
          _buildSectionLabel(Icons.settings, '设置与管理', accentDeepColor, fgColor),
          _buildSettingsMenu(
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          _buildSectionLabel(
            Icons.help_outline,
            '支持与关于',
            accentDeepColor,
            fgColor,
          ),
          _buildSupportMenu(
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          _buildVersionFooter(mutedColor),
        ],
      ),
    );
  }

  Widget _buildProfileHero(
    Color accentColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor,
            const Color(0xFFC99F4B),
            const Color(0xFFB88F47),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        // clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: _buildParticles()),
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileTop(accentSoftColor, accentDeepColor),
                const SizedBox(height: 16),
                _buildProfileStats(accentColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建粒子效果
  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: _particles.map((particle) {
            final adjustedProgress =
                (_particleController.value + particle.delay) % 1.0;
            final y = 80 * (1 - adjustedProgress * 0.8);
            final opacity = adjustedProgress < 0.1
                ? adjustedProgress * 10
                : adjustedProgress > 0.9
                ? (1 - adjustedProgress) * 10
                : 1.0;
            final scale = 1.0 - (adjustedProgress * 0.8);

            return Positioned(
              left: particle.left,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(0, -y),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity * 0.5,
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // 构建用户信息
  Widget _buildProfileTop(Color accentSoftColor, Color accentDeepColor) {
    AppLogger().info(
      'https://api.dicebear.com/10.x/notionists/png?size=256&borderRadius=50&backgroundColor=D4A75F&seed=$_deviceId',
    );
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF383428).withValues(alpha: 0.12),
                border: Border.all(
                  color: const Color(0xFF383428).withValues(alpha: 0.15),
                  width: 3,
                ),
              ),

              child: _avatarBytes != null
                  ? ClipOval(
                      child: Image.memory(
                        _avatarBytes!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.person_outline,
                        size: 36,
                        color: const Color(0xFF383428).withValues(alpha: 0.35),
                      ),
                    ),
            ),
            Positioned.fill(child: CustomPaint(painter: _DashedRingPainter())),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '时光罐',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2A2822),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '已记录 12 件重要时刻',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2A2822).withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF2A2822).withValues(alpha: 0.08),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem('6', '生日')),
          Container(
            width: 1,
            height: 36,
            color: const Color(0xFF2A2822).withValues(alpha: 0.1),
          ),
          Expanded(child: _buildStatItem('4', '事项')),
          Container(
            width: 1,
            height: 36,
            color: const Color(0xFF2A2822).withValues(alpha: 0.1),
          ),
          Expanded(child: _buildStatItem('2', '节日')),
          Container(
            width: 1,
            height: 36,
            color: const Color(0xFF2A2822).withValues(alpha: 0.1),
          ),
          Expanded(child: _buildStatItem('5', '已归档')),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2A2822),
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2A2822).withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(
    IconData icon,
    String label,
    Color accentDeepColor,
    Color fgColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, left: 20, right: 20, bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: accentDeepColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: fgColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.cloud_upload_outlined,
            '数据备份恢复',
            '云端同步，安全守护每一刻',
            'ic-backup',
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          _buildMenuItem(
            Icons.notifications_outlined,
            '通知设置',
            '聚合免打扰时段、每日聚合推送，系统通知设置',
            'ic-notification',
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          // _buildMenuItem(
          //   Icons.palette_outlined,
          //   '主题中心',
          //   '个性化色彩与字体',
          //   'ic-theme',
          //   surfaceColor,
          //   accentSoftColor,
          //   accentDeepColor,
          //   borderColor,
          //   fgColor,
          //   mutedColor,
          //   badge: 'NEW',
          // ),
          _buildMenuItem(
            Icons.emoji_events_outlined,
            '成就',
            '打卡勋章、完成里程碑、成果汇总',
            'ic-achievement',
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
          _buildMenuItem(
            Icons.inbox_outlined,
            '归档',
            '已归档的事件记录',
            'ic-archive',
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportMenu(
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.info_outline,
            '关于我们',
            '版本 ${widget.version} · 温时记团队',
            'ic-about',
            surfaceColor,
            accentSoftColor,
            accentDeepColor,
            borderColor,
            fgColor,
            mutedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    String type,
    Color surfaceColor,
    Color accentSoftColor,
    Color accentDeepColor,
    Color borderColor,
    Color fgColor,
    Color mutedColor, {
    String? badge,
  }) {
    Color iconBgColor;
    Color iconColor;

    switch (type) {
      case 'ic-backup':
        iconBgColor = const Color(0xFFE6F3F8);
        iconColor = const Color(0xFF4A80A4);
        break;
      case 'ic-notification':
        iconBgColor = const Color(0xFFE6F7F0);
        iconColor = const Color(0xFF3D9970);
        break;
      case 'ic-theme':
        iconBgColor = accentSoftColor;
        iconColor = accentDeepColor;
        break;
      case 'ic-achievement':
        iconBgColor = const Color(0xFFF9E6E6);
        iconColor = const Color(0xFFD9534F);
        break;

      case 'ic-about':
        iconBgColor = const Color(0xFFF0F0E8);
        iconColor = const Color(0xFF66665A);
        break;
      case 'ic-archive':
        iconBgColor = const Color(0xFFF8F5E6); // 更浅的米黄背景
        iconColor = const Color(0xFF5A5A4F); // 深一点的灰棕，对比度更高
        break;
      default:
        iconBgColor = accentSoftColor;
        iconColor = accentDeepColor;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          switch (type) {
            case 'ic-achievement':
              context.push('/archivement');
              break;
            case 'ic-notification':
              context.push('/notification_setting');
              break;
            case 'ic-about':
              context.push('/about');
              break;
            case 'ic-archive':
              context.push('/archive');
              break;
            case 'ic-backup':
              context.push('/backup');
              break;
            default:
              break;
          }
        },
        onHighlightChanged: (_) {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: iconBgColor,
                ),
                child: Icon(icon, size: 20, color: iconColor),
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
                        color: fgColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: mutedColor),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9534F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              Icon(Icons.chevron_right, size: 20, color: borderColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionFooter(Color mutedColor) {
    return Container(
      padding: const EdgeInsets.only(top: 28, left: 20, right: 20, bottom: 12),
      child: Center(
        child: Text(
          '温时记 V${widget.version}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B8066).withValues(alpha: 0.5),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2822).withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final radius = (math.min(size.width, size.height) / 2) + 5;
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startAngle = 0.0;

    while (startAngle < 2 * math.pi) {
      path.addArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
        startAngle,
        dashWidth / radius,
      );
      startAngle += (dashWidth + dashSpace) / radius;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ParticleData {
  final double left;
  final double size;
  final double delay;

  _ParticleData({required this.left, required this.size, required this.delay});
}
