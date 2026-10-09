import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenshiji/common/app_logger.dart';
import 'package:wenshiji/common/http.dart';
import 'package:wenshiji/common/notification_service.dart';
import 'package:wenshiji/common/preferences.dart';
import 'package:wenshiji/common/secure_storage.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/database/migration.dart';
import 'package:wenshiji/database/wenshiji_database.dart';
import 'package:wenshiji/firebase_options.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/router/app_router.dart';
import 'package:wenshiji/screens/init_error_screen.dart';
import 'package:wenshiji/theme/app_theme.dart';
import 'package:workmanager/workmanager.dart';

// 必须在全局定义，添加 @pragma 注解防止代码混淆时出现问题
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 注意：executeTask 是异步的，需要使用 await
    WidgetsFlutterBinding.ensureInitialized(); // 初始化Flutter引擎
    final today = DateTime.now();
    try {
      AppLogger().info('执行后台任务: $task');

      final notificationService = NotificationService();

      try {
        await notificationService.initForBackground();
      } catch (e) {
        AppLogger().error('初始化后台通知服务失败: $e');
        return true;
      }

      final outsideTime = await Utils().getOutsideTime();
      if (outsideTime == null) {
        AppLogger().error('outsideTime is null');
        return true;
      }
      AppLogger().info('outsideTime: $outsideTime');
      final tomorrowContent = await Utils().getDailyNotificationContent();
      // 只记录长度，不打印通知正文（正文含用户事件名称）。
      AppLogger().info('tomorrowContent length: ${tomorrowContent.length}');
      // 使用稳定的 key（而非按天变化的 id）：关闭聚合推送时才能精确取消到它。
      const digestKey = NotificationService.dailyDigestKey;

      final isScheduled = await notificationService.isNotificationScheduled(
        digestKey,
      );
      if (isScheduled) {
        AppLogger().info('通知已存在');
        return true;
      }

      // 3. 发送通知
      await notificationService.scheduleEventNotification(
        key: digestKey,
        title: '每日聚合推送',
        body: tomorrowContent,
        scheduledDate: DateTime(
          today.year,
          today.month,
          today.day + 1,
          outsideTime,
        ),
      );
      return true;
    } catch (e) {
      AppLogger().error('后台任务执行失败: $e');
      return true;
    }
  });
}

/// 一次性迁移：从旧 SharedPreferences 中的 AppConfig JSON 读取明文 WebDAV 凭据，
/// 迁入 flutter_secure_storage。幂等：SecureStorage 已有凭据则跳过。
/// 旧 app_config_data 中的 credential key 在下次 AppConfig 保存时自动丢弃。
Future<void> _migrateWebdavCredentials() async {
  try {
    await SecureStorage().migrateFromLegacy(
      readLegacyCredentials: () async {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString('app_config_data');
        if (raw == null) return null;
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final username = decoded['backupUsername'] as String? ?? '';
        final password = decoded['backupPassword'] as String? ?? '';
        final serverUrl = decoded['backupServerUrl'] as String? ?? '';
        if (username.isEmpty && password.isEmpty && serverUrl.isEmpty) {
          return null;
        }
        return (username: username, password: password, serverUrl: serverUrl);
      },
      // 旧凭据嵌在 app_config_data JSON 中，无法单独清除 key；
      // AppConfig 下次保存时不再序列化这些字段，故此处 no-op。
      clearLegacyCredentials: () async {},
    );
  } catch (e, s) {
    AppLogger().error('WebDAV 凭据迁移失败', error: e, stack: s);
  }
}

/// 安装全局异常捕获。**紧随 ensureInitialized 调用**，
/// 这样 Workmanager / Firebase 自身的初始化失败也能被上报。
void _installErrorHandlers() {
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    // 保留默认的控制台红屏输出，便于开发排查。
    previousOnError?.call(details);
    _reportFatal(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    _reportFatal(error, stack);
    return true;
  };
}

void _reportFatal(Object error, StackTrace? stack) {
  try {
    // AppLogger.fatal 内部已包含 Crashlytics 上报，且自身 try/catch 兜底，
    // 因此 Firebase 未就绪时也不会二次崩溃。
    AppLogger().fatal('未捕获异常', error: error, stack: stack);
  } catch (_) {
    // 忽略：错误上报失败不应再抛异常。
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 先安装错误捕获，再渲染首帧：任何后续初始化异常都能被记录。
  _installErrorHandlers();
  // 立即渲染首帧（加载态），异步初始化在 Bootstrap 内进行。
  // 任一 await 挂起只会停留在加载页，不会白屏；失败则进入可重试的错误页。
  runApp(const BootstrapApp());
}

/// 启动引导：负责全部异步初始化，并根据结果渲染加载态 / 错误页 / 主应用。
class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  // 三态：引导中（都为 null）/ 完成（_result） / 失败（_error）。
  _BootResult? _result;
  Object? _error;
  // 引导完成后构造一次的就绪组件树。缓存它是为了只创建一次 GoRouter：
  // 若在每次 build 里新建 Application，任何重建都会重建路由并丢失导航栈。
  Widget? _readyApp;

  @override
  void initState() {
    super.initState();
    _startBootstrap();
  }

  void _startBootstrap() {
    // 用 async 闭包 + try/catch，而不是 Future.catchError：
    // 后者要求回调返回 T，返回 void 会在运行时抛 TypeError。
    () async {
      try {
        final result = await _bootstrap();
        if (!mounted) return;
        setState(() => _result = result);
      } catch (e) {
        if (!mounted) return;
        setState(() => _error = e);
      }
    }();
  }

  void _retry() {
    setState(() {
      _error = null;
      _result = null;
      _readyApp = null;
    });
    _startBootstrap();
  }

  /// 关键路径失败时抛出（交给错误页）；非关键路径失败仅记录日志、继续启动。
  Future<_BootResult> _bootstrap() async {
    AppDatabase? database;
    try {
      // 非关键：后台任务初始化失败不应阻断 App 使用。
      try {
        await Workmanager().initialize(callbackDispatcher);
      } catch (e, s) {
        AppLogger().error('Workmanager 初始化失败', error: e, stack: s);
      }

      // 非关键：崩溃上报不可用不应阻断 App。`Firebase.initializeApp` 非幂等，
      // 热重启重复调用会抛 "Duplicate app registration"，故先判空。
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        }
      } catch (e, s) {
        AppLogger().error('Firebase 初始化失败', error: e, stack: s);
      }

      // ---- 关键路径：配置读取 + 数据库 ----
      final isInitBool = await preferences.getInitState();
      final deviceId = await preferences.getDeviceId();
      final appConfig = await preferences.getConfig();
      await _migrateWebdavCredentials();

      database = AppDatabase();
      await migrateEventsFromPrefs(database);

      // 非关键：按配置同步后台聚合推送任务。
      //  - 开启时幂等注册（keep 策略，不重置 24h 计时），成功才把标记置 true；
      //  - 关闭时精确取消并回写标记，避免「已关闭仍每 24h 唤醒」以及
      //    历史遗留的「标记为 true 但任务从未注册」无法自愈。
      try {
        if (appConfig != null) {
          if (appConfig.notificationDigestOn) {
            final ok = await Utils().registerDailyReminderTask();
            if (ok != appConfig.isSettingWorkManager) {
              await preferences.setIsSettingWorkManager(ok);
            }
          } else if (appConfig.isSettingWorkManager) {
            await Utils().cancelDailyReminderTask();
            await preferences.setIsSettingWorkManager(false);
          }
        }
      } catch (e, s) {
        AppLogger().error('同步后台推送任务失败', error: e, stack: s);
      }

      // 非关键：版本号 / 网络 / 通知。首帧已渲染，这些不再造成白屏。
      String version = '';
      try {
        version = await Utils().getVersion() ?? '';
      } catch (e, s) {
        AppLogger().error('获取版本号失败', error: e, stack: s);
      }
      try {
        await httpUtil.ensureInitialized();
      } catch (e, s) {
        AppLogger().error('网络层初始化失败', error: e, stack: s);
      }
      try {
        await NotificationService().init();
      } catch (e, s) {
        AppLogger().error('通知服务初始化失败', error: e, stack: s);
      }

      return _BootResult(
        database: database,
        isInit: isInitBool,
        deviceId: deviceId,
        version: version,
      );
    } catch (e, s) {
      AppLogger().error('应用初始化失败', error: e, stack: s);
      // 已创建的数据库实例需关闭，避免泄漏连接。
      try {
        await database?.close();
      } catch (_) {}
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: InitErrorScreen(error: _error, onRetry: _retry),
      );
    }
    final result = _result;
    if (result == null) {
      return MaterialApp(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: const _BootLoadingScreen(),
      );
    }
    // 只在首次拿到结果时构造，之后复用同一棵树（GoRouter 只建一次）。
    return _readyApp ??= ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(result.database)],
      child: Application(
        isInit: result.isInit,
        deviceId: result.deviceId,
        version: result.version,
      ),
    );
  }
}

/// 启动引导结果：主应用运行所需的已解析数据。
class _BootResult {
  _BootResult({
    required this.database,
    required this.isInit,
    required this.deviceId,
    required this.version,
  });

  final AppDatabase database;
  final bool isInit;
  final String deviceId;
  final String version;
}

/// 初始化期间的极简加载页（与主色调一致，替代此前的白屏）。
class _BootLoadingScreen extends StatelessWidget {
  const _BootLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAF7F0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '温时记',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF383428),
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 22),
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Color(0xFFF5B041),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Application extends StatelessWidget {
  late final GoRouter _router;
  final bool isInit;
  final String deviceId;
  final String version;

  Application({
    super.key,
    required this.isInit,
    required this.deviceId,
    required this.version,
  }) {
    _router = createRouter(isInit: isInit, version: version);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: '温时记',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
    );
  }
}
