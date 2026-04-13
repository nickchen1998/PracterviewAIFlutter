import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/interview/setup_screen.dart';
import '../screens/interview/session_screen.dart';
import '../screens/interview/result_screen.dart';
import '../screens/history/history_list_screen.dart';
import '../screens/history/history_detail_screen.dart';
import '../widgets/app_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

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
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/interview/setup',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SetupScreen(),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryListScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/interview/session',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SessionScreen(),
      ),
      GoRoute(
        path: '/interview/result',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: '/history/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => HistoryDetailScreen(
          resultId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
