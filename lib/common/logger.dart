// 1. 导入包
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// 2. 初始化日志实例（全局单例最佳实践）

class AppLogger {
  static final AppLogger instance = AppLogger._internal();
  late Logger _logger;

  factory AppLogger() => instance;
  AppLogger._internal() {
    _logger = Logger(
      level: kReleaseMode ? Level.off : Level.all,
      printer: PrettyPrinter(
        methodCount: 2, // 打印堆栈方法数量
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 打印时间
        colors: true, // 开启彩色日志
        printEmojis: true, // 开启表情图标
      ),
    );
    ;
  }
  void log(String message) {
    _logger.d(message);
  }
  void verbose(String message) {
    _logger.t(message);
  }
  void debug(String message) {
    _logger.d(message);
  }
  void info(String message) {
    _logger.i(message);
  }
  void warning(String message) {
    _logger.w(message);
  }
  void error(String message) {
    _logger.e(message);
  }
  void fatal(String message) {
    _logger.f(message);
  }
  void testLogger() {
    _logger.t("详细日志 - verbose");
    _logger.d("调试日志 - debug"); // 最常用
    _logger.i("信息日志 - info");
    _logger.w("警告日志 - warning");
    _logger.e("错误日志 - error");
    _logger.f("致命错误 - wtf");

    // 🔥 打印复杂数据（自动格式化Map/List/JSON）
    _logger.d({"name": "Flutter", "version": 3.22, "isCool": true});
  }
}
