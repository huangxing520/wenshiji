import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenshiji/common/debouncer.dart';
import 'package:wenshiji/common/http.dart';
import 'package:wenshiji/common/logger.dart';
import 'package:wenshiji/common/notification_service.dart';
import 'package:wenshiji/common/preferences.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/constants/config_constant.dart';
import 'package:wenshiji/firebase_options.dart';
import 'package:wenshiji/models/appconfig.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/screens/about.dart';
import 'package:wenshiji/screens/achievement.dart' hide Event;
import 'package:wenshiji/screens/archive.dart';
import 'package:wenshiji/screens/backup.dart';
import 'package:wenshiji/screens/notification_setting.dart';
import 'package:wenshiji/screens/stats.dart';
import 'package:workmanager/workmanager.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_event.dart';
import 'screens/profile.dart';
import 'screens/event_detail.dart';
import 'screens/main_shell.dart';

// 必须在全局定义，添加 @pragma 注解防止代码混淆时出现问题
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 注意：executeTask 是异步的，需要使用 await
    WidgetsFlutterBinding.ensureInitialized(); // 初始化Flutter引擎
    final today = DateTime.now();
    try {
      print('执行后台任务: $task');

      final notificationService = NotificationService();

      final baseDate = DateTime(2025, 1, 1);

      try {
        await notificationService.initForBackground();
      } catch (e) {
        print('初始化后台通知服务失败');
        return Future.value(true);
      }

      final outsideTime = await Utils().getOutsideTime();
      if (outsideTime == null) {
        AppLogger().error('outsideTime is null');
        return Future.value(true);
      }
      AppLogger().info('outsideTime: $outsideTime');
      final tomorrowContent = await Utils().getDailyNotificationContent();
      AppLogger().info('tomorrowContent: $tomorrowContent');
      final id = today.difference(baseDate).inDays;

      final isScheduled = await notificationService.isNotificationScheduled(id);
      if (isScheduled) {
        print('通知已存在');
        return Future.value(true);
      }

      // 3. 发送通知
      await notificationService.scheduleEventNotification(
        id: id,
        title: "每日聚合推送",
        body: tomorrowContent,
        scheduledDate: DateTime(
          today.year,
          today.month,
          today.day + 1,
          outsideTime,
        ),
      );
      // await notificationService.showInstantNotification(  title: "每日聚合推送",
      //   body: tomorrowContent,);
      return Future.value(true);
    } catch (e) {
      print('后台任务执行失败: $e');
      return Future.value(true);
    }
  });
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Workmanager().initialize(callbackDispatcher);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // 绑定全局崩溃捕获，自动上报日志到Firebase后台
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    final isInitBool = await preferences.getInitState();
    final deviceId = await preferences.getDeviceId();
    final appConfig = await preferences.getConfig();
    if (appConfig != null && !appConfig.isSettingWorkManager && appConfig.notificationDigestOn) {
      final debouncer = Debouncer(delay: const Duration(seconds: 1));
      Utils().registerPeriodicTask(debouncer);
      await preferences.setIsSettingWorkManager(true);
    }
    final version = await Utils().getVersion();
    await httpUtil.ensureInitialized();
    await NotificationService().init();

    runApp(
      ProviderScope(
        child: Application(
          isInit: isInitBool,
          deviceId: deviceId,
          version: version ?? '',
        ),
      ),
    );
  } catch (e, s) {
    return runApp(MaterialApp(home: InitErrorScreen(error: e)));
  }
}

class InitErrorScreen extends StatelessWidget {
  const InitErrorScreen({super.key, required this.error});

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Init Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Error: $error')],
        ),
      ),
    );
  }
}

class Application extends StatelessWidget {
  // 之后 ✅ — 构造函数体中 this 已可用
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
    _router = GoRouter(
      navigatorKey: HyperSnackbar.navigatorKey,
      initialLocation: isInit
          ? '/homepage'
          : '/splash', // Start at the home page
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/add-event',
          builder: (context, state) {
            final Event? event = state.extra as Event?;
            return AddEventScreen(event: event);
          },
        ),

        GoRoute(
          path: '/about',
          builder: (context, state) => AboutScreen(version: version),
        ),
        GoRoute(
          path: '/notification_setting',
          builder: (context, state) => NotificationSettingScreen(),
        ),
        GoRoute(
          path: '/backup',
          builder: (context, state) => const BackupScreen(),
        ),
        GoRoute(
          path: '/archivement',
          builder: (context, state) => const AchievementScreen(),
        ),
        GoRoute(
          path: '/archive',
          builder: (context, state) => const ArchiveScreen(),
        ),
        GoRoute(
          path: '/event-detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']; // 获取参数
            if (id == null || id.isEmpty) {
              return const InitErrorScreen(error: '跳转事件id为空');
            }
            return EventDetailScreen(eventId: id);
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/homepage',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/stats',
                  builder: (context, state) => const StatsScreen(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => ProfileScreen(version: version),
                ),
              ],
            ),
          ],
        ),
      ],
      // Optional: Handle 404-like errors
      errorBuilder: (context, state) => InitErrorScreen(error: state.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: '温时记',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4A853)),
        useMaterial3: true,
      ),
    );
  }
}
