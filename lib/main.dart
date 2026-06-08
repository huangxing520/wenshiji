import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:wenshiji/common/http.dart';
import 'package:wenshiji/common/logger.dart';
import 'package:wenshiji/common/notification_service.dart';
import 'package:wenshiji/common/preferences.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/firebase_options.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/screens/about.dart';
import 'package:wenshiji/screens/achievement.dart' hide Event;
import 'package:wenshiji/screens/archive.dart';
import 'package:wenshiji/screens/backup.dart';
import 'package:wenshiji/screens/notification_setting.dart';
import 'package:wenshiji/screens/stats.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_event.dart';
import 'screens/profile.dart';
import 'screens/event_detail.dart';
import 'screens/main_shell.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
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
