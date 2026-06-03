import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LogWriter {
  // 日志文件路径
  static late File _logFile;
  // 单例模式
  static final LogWriter _instance = LogWriter._internal();
  factory LogWriter() => _instance;
  LogWriter._internal();

  // 初始化日志文件
  Future<void> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String logPath = '${appDocDir.path}/network_logs.txt';
    _logFile = File(logPath);
    // 确保文件存在
    if (!await _logFile.exists()) {
      await _logFile.create();
    }
  }

  // 写入日志（追加模式）
  Future<void> write(String log) async {
    // 添加时间戳
    String time = DateTime.now().toString().split('.').first;
    String logWithTime = "[$time] $log\n";
    
    // 追加写入
    await _logFile.writeAsString(logWithTime, mode: FileMode.append);
    
    // 同时输出到控制台（可选）
    print(logWithTime);
  }
}