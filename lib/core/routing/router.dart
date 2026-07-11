import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router_refresh_stream.dart';
import '../navigation/app_routes.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/group_selection_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/shell_scaffold.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/profile_details_page.dart';
import '../../features/profile/ai_agent_settings_screen.dart';
import '../../features/profile/number_marketplace_screen.dart';
import '../../features/profile/carrier_routing_screen.dart';
import '../../features/widgets/profile_widgets.dart';
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
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (BuildContext context, GoRouterState state) async {
      final authState = ref.read(authProvider);

      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.verifyOtp ||
          state.matchedLocation == AppRoutes.forgotPassword ||
          state.matchedLocation == AppRoutes.resetPassword;
      final isGroups = state.matchedLocation == AppRoutes.groups;

      return authState.when(
        initial: () => isSplash ? null : AppRoutes.splash,
        loading: () => null, // Keep the user on their current page during active loading states
        unauthenticated: () => isAuthRoute ? null : AppRoutes.login,
        authenticated: (_) async {
          final secureStorage = getIt<SecureStorageService>();
          final clientId = await secureStorage.getSelectedClientId();
          final hasGroup = clientId?.trim().isNotEmpty == true;

          if (isAuthRoute || isSplash) {
            return hasGroup ? AppRoutes.dashboard : AppRoutes.groups;
          }
          if (isGroups && hasGroup) {
            return AppRoutes.dashboard;
          }

          if (!isGroups && !hasGroup) {
            return AppRoutes.groups;
          }

          return null;
        },
        error: (_) => isAuthRoute ? null : AppRoutes.login,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationPage(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.groups,
        builder: (context, state) => const GroupSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
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
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.calls,
            builder: (context, state) => const CallsPage(),
          ),
          GoRoute(
            path: AppRoutes.dialer,
            builder: (context, state) => const DialerPage(),
          ),
          GoRoute(
            path: AppRoutes.wallet,
            builder: (context, state) => const WalletPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.profileDetails,
            builder: (context, state) {
              final authState = ref.read(authProvider);
              final userEntity = authState.maybeWhen(
                authenticated: (user) => user,
                orElse: () => null,
              );
              
              final profileUser = ProfileUser(
                fullName: userEntity?.name ?? '',
                email: userEntity?.email.contains('@') == true ? (userEntity?.email ?? '') : '',
                phone: userEntity?.email.contains('@') == false ? (userEntity?.email ?? '') : '',
                isPhoneVerified: true,
              );
              
              return ProfileDetailsPage(
                user: profileUser,
                onSave: (updatedUser) async {
                },
                onSendOtp: (newNumber) async {
                  await ref.read(authProvider.notifier).sendOtp(newNumber);
                },
              );
            },
          ),
          GoRoute(
            path: AppRoutes.aiAgentSettings,
            builder: (context, state) => const AiAgentSettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.numberMarketplace,
            builder: (context, state) => NumberMarketplaceScreen(
              onBuy: (listing) {
              },
            ),
          ),
          GoRoute(
            path: AppRoutes.carrierRouting,
            builder: (context, state) => const CarrierRoutingScreen(),
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
