import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router_refresh_stream.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/group_selection_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/shell_scaffold.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/calls/presentation/pages/calls_page.dart';
import '../../features/dialer/presentation/pages/dialer_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../storage/secure_storage_service.dart';
import '../di/injection.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Global router provider using Riverpod.
final routerProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authProvider.notifier).stream;

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (BuildContext context, GoRouterState state) async {
      final authState = ref.read(authProvider);

      final isSplash = state.matchedLocation == '/splash';
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/verify-otp' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/reset-password';
      final isGroups = state.matchedLocation == '/groups';

      return authState.when(
        initial: () => isSplash ? null : '/splash',
        loading: () => null, // Keep the user on their current page during active loading states
        unauthenticated: () => isAuthRoute ? null : '/login',
        authenticated: (_) async {
          final secureStorage = getIt<SecureStorageService>();
          final clientId = await secureStorage.getSelectedClientId();
          final hasGroup = clientId?.trim().isNotEmpty == true;

          if (isAuthRoute || isSplash) {
            return hasGroup ? '/dashboard' : '/groups';
          }
          if (isGroups && hasGroup) {
            return '/dashboard';
          }

          if (!isGroups && !hasGroup) {
            return '/groups';
          }

          return null;
        },
        error: (_) => isAuthRoute ? null : '/login',
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationPage(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: '/groups',
        builder: (context, state) => const GroupSelectionPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return ResetPasswordPage(email: email);
        },
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/calls',
            builder: (context, state) => const CallsPage(),
          ),
          GoRoute(
            path: '/dialer',
            builder: (context, state) => const DialerPage(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Route Error: ${state.error}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
});
