import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/login/login_screen.dart';
import '../widgets/app_scaffold.dart';

// Deferred imports — loaded on demand to reduce initial bundle size
import '../screens/register/register_screen.dart' deferred as register;
import '../screens/onboarding/onboarding_screen.dart' deferred as onboarding;
import '../screens/home/home_screen.dart' deferred as home;
import '../screens/profile/profile_screen.dart' deferred as profile;
import '../screens/interview/setup_screen.dart' deferred as setup;
import '../screens/interview/session_screen.dart' deferred as session;
import '../screens/interview/result_screen.dart' deferred as result;
import '../screens/history/history_list_screen.dart' deferred as historyList;
import '../screens/history/history_detail_screen.dart' deferred as historyDetail;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Stable deferred-loading wrapper that caches the Future.
class _DeferredLoader extends StatefulWidget {
  final Future<void> Function() loader;
  final Widget Function() builder;

  const _DeferredLoader({required this.loader, required this.builder});

  @override
  State<_DeferredLoader> createState() => _DeferredLoaderState();
}

class _DeferredLoaderState extends State<_DeferredLoader> {
  late final Future<void> _future = widget.loader();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('載入失敗: ${snapshot.error}')),
            );
          }
          return widget.builder();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = auth.isLoggedIn;
      final isOnAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isOnAuthPage) return '/login';
      if (isLoggedIn && isOnAuthPage) {
        if (!auth.hasCompletedOnboarding) return '/onboarding';
        return '/home';
      }
      if (isLoggedIn && !auth.hasCompletedOnboarding && !isOnboarding) {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      // Login is eagerly loaded (first screen users see)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => _DeferredLoader(
          loader: register.loadLibrary,
          builder: () => register.RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => _DeferredLoader(
          loader: onboarding.loadLibrary,
          builder: () => onboarding.OnboardingScreen(),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredLoader(
                loader: home.loadLibrary,
                builder: () => home.HomeScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/interview/setup',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredLoader(
                loader: setup.loadLibrary,
                builder: () => setup.SetupScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredLoader(
                loader: historyList.loadLibrary,
                builder: () => historyList.HistoryListScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _DeferredLoader(
                loader: profile.loadLibrary,
                builder: () => profile.ProfileScreen(),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/interview/session',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => _DeferredLoader(
          loader: session.loadLibrary,
          builder: () => session.SessionScreen(),
        ),
      ),
      GoRoute(
        path: '/interview/result',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => _DeferredLoader(
          loader: result.loadLibrary,
          builder: () => result.ResultScreen(),
        ),
      ),
      GoRoute(
        path: '/history/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return _DeferredLoader(
            loader: historyDetail.loadLibrary,
            builder: () => historyDetail.HistoryDetailScreen(resultId: id),
          );
        },
      ),
    ],
  );
});
