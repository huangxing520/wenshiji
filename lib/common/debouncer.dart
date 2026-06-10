import 'dart:async';

/// 防抖延迟执行工具类
/// 多次调用会重置延迟时间，只执行最后一次
class Debouncer {
  final Duration delay; // 延迟时间
  Timer? _timer; // 内部计时器

  Debouncer({required this.delay});

  /// 调用此方法会重置延迟，并在延迟后执行 action
  void run(FutureOr<void> Function() action) {
    // 如果已有计时器，先取消（重置）
    if (_timer != null) {
      _timer!.cancel();
    }
    // 创建新计时器
    _timer = Timer(delay, action);
  }

  /// 手动取消延迟任务
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// 立即执行并取消计时器
  void flush() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}