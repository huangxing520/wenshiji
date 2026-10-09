import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 初始化失败 / 路由错误的统一兜底页面。
///
/// 用于三处：
/// - 启动 bootstrap 失败时的兜底（传 [onRetry]，提供「重新初始化」出口）；
/// - `GoRouter.errorBuilder` 未知路由兜底；
/// - 事件详情 `id` 为空时的兜底。
///
/// 抽离为独立文件，避免 `main.dart` 与 `app_router.dart` 之间因共用此类
/// 而产生循环依赖。
class InitErrorScreen extends StatelessWidget {
  const InitErrorScreen({super.key, required this.error, this.onRetry});

  final dynamic error;

  /// 非空时显示「重新初始化」按钮。启动失败场景传入；路由级兜底不传。
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: Color(0xFFD65A31),
                ),
                const SizedBox(height: 18),
                const Text(
                  '启动失败',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF383428),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '应用初始化时遇到问题，请重试。\n若持续失败，可尝试重启设备或更新到最新版本。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B8066),
                    height: 1.6,
                  ),
                ),
                // 原始异常仅在 debug 展示，release 不暴露内部路径 / 细节。
                if (kDebugMode) ...[
                  const SizedBox(height: 14),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB8A48A),
                      height: 1.4,
                    ),
                  ),
                ],
                if (onRetry != null) ...[
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onRetry,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF5B041),
                        foregroundColor: const Color(0xFF2A2822),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        '重新初始化',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
