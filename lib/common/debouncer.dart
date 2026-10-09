import 'dart:async';

/// 防抖延迟执行工具类
/// 多次调用会重置延迟时间，只执行最后一次
class Debouncer {
  final Duration delay; // 延迟时间
  Timer? _timer; // 内部计时器
  FutureOr<void> Function()? _action; // 待执行的 action

  Debouncer({required this.delay});

  /// 调用此方法会重置延迟，并在延迟后执行 action
  void run(FutureOr<void> Function() action) {
    // 如果已有计时器，先取消（重置）
    _timer?.cancel();
    _action = action;
    // 创建新计时器
    _timer = Timer(delay, () {
      _timer = null;
      _action?.call();
      _action = null;
    });
  }

  /// 手动取消延迟任务
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _action = null;
  }

  /// 立即执行挂起的 action 并取消计时器
  void flush() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    final action = _action;
    _action = null;
    action?.call();
  }
}