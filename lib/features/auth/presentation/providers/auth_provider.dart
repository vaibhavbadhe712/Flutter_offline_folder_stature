import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/auth_event_bus.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../state/auth_state.dart';

/// StateNotifier that coordinates authentication actions (login, logout, checks) and updates screen state.
class AuthNotifier extends StateNotifier<AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthEventBus authEventBus;
  StreamSubscription<AuthEvent>? eventSubscription;

  AuthNotifier({
    required this.getCurrentUserUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.authEventBus,
  })  : super(const AuthState.initial()) {
    // Listen to global network-triggered logouts (e.g., failed refresh token)
    eventSubscription = authEventBus.events.listen((event) {
      if (event == AuthEvent.logout) {
        _handleForceLogout();
      }
    });
  }

  /// Check if a user is already authenticated on app launch.
  Future<void> checkAuth() async {
    state = const AuthState.loading();
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  /// Perform authentication with email and password.
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Log out of the active user session.
  Future<void> logout() async {
    state = const AuthState.loading();
    final result = await logoutUseCase(const NoParams());
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  void _handleForceLogout() {
    state = const AuthState.unauthenticated();
  }

  @override
  void dispose() {
    eventSubscription?.cancel();
    super.dispose();
  }
}

/// Global provider for the Authentication Notifier.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    loginUseCase: getIt<LoginUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    authEventBus: getIt<AuthEventBus>(),
  );
});
