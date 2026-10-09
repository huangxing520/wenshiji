// 统一日志单例：多 sink（控制台 + 文件 + Crashlytics）
// 合并自旧 common/logger.dart（控制台）与 common/log.dart（文件）
import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  static final AppLogger instance = AppLogger._internal();
  factory AppLogger() => instance;

  late Logger _logger;
  File? _logFile;
  bool _fileInitialized = false;

  AppLogger._internal() {
    _logger = Logger(
      // release 模式关闭控制台输出，仅文件 + Crashlytics
      level: kReleaseMode ? Level.off : Level.all,
      printer: PrettyPrinter(
        methodCount: 2,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        colors: true,
        printEmojis: true,
      ),
    );
  }

  /// 是否启用本地文件日志 sink。
  /// **仅 debug / profile 启用**：release 不再把日志（可能含事件名称等用户内容）
  /// 明文写入应用目录，避免隐私数据落盘。
  static const bool _fileSinkEnabled = !kReleaseMode;

  /// 初始化文件 sink。幂等，可重复调用。
  /// 在 main() 与 HttpUtil.ensureInitialized() 中调用。
  Future<void> init() async {
    if (!_fileSinkEnabled) return;
    if (_fileInitialized) return;
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      _logFile = File('${appDocDir.path}/network_logs.txt');
      if (!_logFile!.existsSync()) {
        await _logFile!.create();
      }
      _fileInitialized = true;
    } catch (_) {
      // 文件 sink 初始化失败不应阻断业务
      _fileInitialized = false;
    }
  }

  /// 写入文件 sink（供 PrettyDioLogger 的 logPrint 回调使用）。
  Future<void> write(String log) async {
    if (!_fileSinkEnabled) return;
    if (!_fileInitialized) await init();
    final sink = _logFile;
    if (sink == null) return;
    // 单文件上限 1MB：超出后截断重写，避免无限增长。
    try {
      const maxBytes = 1024 * 1024;
      if (await sink.length() > maxBytes) {
        await sink.writeAsString('', mode: FileMode.write);
      }
      final time = DateTime.now().toString().split('.').first;
      await sink.writeAsString('[$time] $log\n', mode: FileMode.append);
    } catch (_) {
      // 忽略文件写入失败
    }
  }

  // ====================== 控制台 + 文件 + Crashlytics 多 sink ======================

  void log(String message) => debug(message);

  void verbose(String message) {
    _console(message, Level.trace);
  }

  void debug(String message) {
    _console(message, Level.debug);
    unawaited(write('[DEBUG] $message'));
  }

  void info(String message) {
    _console(message, Level.info);
    unawaited(write('[INFO] $message'));
  }

  void warning(String message) {
    _console(message, Level.warning);
    unawaited(write('[WARN] $message'));
  }

  void error(String message, {Object? error, StackTrace? stack}) {
    _console(message, Level.error, error, stack);
    unawaited(write('[ERROR] $message'));
    _recordCrashlytics(message, error: error, stack: stack, fatal: false);
  }

  void fatal(String message, {Object? error, StackTrace? stack}) {
    _console(message, Level.fatal, error, stack);
    unawaited(write('[FATAL] $message'));
    _recordCrashlytics(message, error: error, stack: stack, fatal: true);
  }

  void _console(
    String message,
    Level level, [
    Object? err,
    StackTrace? stack,
  ]) {
    if (kReleaseMode) return;
    _logger.log(level, message, error: err, stackTrace: stack);
  }

  /// 上报到 Firebase Crashlytics。后台 isolate 中 Firebase 可能未初始化，
  /// 用 try/catch 兜底避免二次崩溃。
  void _recordCrashlytics(
    String message, {
    Object? error,
    StackTrace? stack,
    bool fatal = false,
  }) {
    try {
      FirebaseCrashlytics.instance.log('$message${fatal ? ' [FATAL]' : ''}');
      if (error != null) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
      }
    } catch (_) {
      // 忽略上报失败（例如后台 isolate 中 Firebase 未初始化）
    }
  }

  void testLogger() {
    verbose('详细日志 - verbose');
    debug('调试日志 - debug');
    info('信息日志 - info');
    warning('警告日志 - warning');
    error('错误日志 - error');
    fatal('致命错误 - fatal');
    _logger.d({'name': 'Flutter', 'version': 3.22, 'isCool': true});
  }
}
