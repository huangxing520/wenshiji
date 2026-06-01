import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:wenshiji/common/preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart' hide AddEventScreen;
import 'screens/add_event.dart';
import 'screens/profile.dart';
import 'screens/event_detail.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final isInitBool = await preferences.getInitState();

    runApp(ProviderScope(
      child: Application(isInit: isInitBool),
    ));
  } catch (e, s) {
    return runApp(
      MaterialApp(
        home: InitErrorScreen(error: e),
      ),
    );
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
          children: [
            Text('Error: $error'),
          ],
        ),
      ),
    );
  }
}

class Application extends StatelessWidget {
  // 之后 ✅ — 构造函数体中 this 已可用
  late final GoRouter _router;
  final bool isInit;

  Application({super.key, required this.isInit}) {
    _router = GoRouter(
      navigatorKey: HyperSnackbar.navigatorKey, 
      initialLocation:
          isInit ? '/homepage' : '/splash', // Start at the home page
      routes: [
        GoRoute(
          path: '/homepage',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/add-event',
          builder: (context, state) => const AddEventScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/event-detail',
          builder: (context, state) => const EventDetailScreen(),
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
