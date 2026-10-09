import 'package:go_router/go_router.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/router/route_names.dart';
import 'package:wenshiji/screens/about.dart';
import 'package:wenshiji/screens/achievement.dart';
import 'package:wenshiji/screens/add_event.dart';
import 'package:wenshiji/screens/archive.dart';
import 'package:wenshiji/screens/backup.dart';
import 'package:wenshiji/screens/event_detail.dart';
import 'package:wenshiji/screens/home_screen.dart';
import 'package:wenshiji/screens/init_error_screen.dart';
import 'package:wenshiji/screens/main_shell.dart';
import 'package:wenshiji/screens/notification_setting.dart';
import 'package:wenshiji/screens/profile.dart';
import 'package:wenshiji/screens/splash_screen.dart';
import 'package:wenshiji/screens/stats.dart';

/// 构建应用顶层 [GoRouter]。
///
/// 从 `main.dart` 的 `Application` 构造函数中抽离，使路由配置独立可测、
/// 不与启动逻辑耦合。
///
/// [isInit] 决定初始路由：已初始化进首页，否则进闪屏。
/// [version] 透传给需要展示版本号的页面（关于 / 我的）。
/// 所有路径引用 [route_names] 中的常量，避免字面量拼写错位。
GoRouter createRouter({
  required bool isInit,
  required String version,
}) {
  return GoRouter(
    navigatorKey: HyperSnackbar.navigatorKey,
    initialLocation: isInit ? kRouteHome : kRouteSplash,
    routes: [
      GoRoute(
        path: kRouteSplash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: kRouteAddEvent,
        builder: (context, state) {
          final extra = state.extra;
          final Event? event = extra is Event ? extra : null;
          return AddEventScreen(event: event);
        },
      ),
      GoRoute(
        path: kRouteAbout,
        builder: (context, state) => AboutScreen(version: version),
      ),
      GoRoute(
        path: kRouteNotificationSetting,
        builder: (context, state) => const NotificationSettingScreen(),
      ),
      GoRoute(
        path: kRouteBackup,
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: kRouteAchievement,
        builder: (context, state) => const AchievementScreen(),
      ),
      GoRoute(
        path: kRouteArchive,
        builder: (context, state) => const ArchiveScreen(),
      ),
      GoRoute(
        path: '$kRouteEventDetail/:id',
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
                path: kRouteHome,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kRouteStats,
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: kRouteProfile,
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
