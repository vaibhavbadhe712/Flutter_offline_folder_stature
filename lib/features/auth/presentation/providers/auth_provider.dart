import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/auth_event_bus.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/send_reset_code_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../state/auth_state.dart';

/// StateNotifier that coordinates authentication actions (login, logout, checks) and updates screen state.
class AuthNotifier extends StateNotifier<AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SendResetCodeUseCase sendResetCodeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final AuthEventBus authEventBus;
  StreamSubscription<AuthEvent>? eventSubscription;

  AuthNotifier({
    required this.getCurrentUserUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.sendResetCodeUseCase,
    required this.resetPasswordUseCase,
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

  /// Request an OTP to the given phone number.
  Future<bool> sendOtp(String phoneNumber) async {
    state = const AuthState.loading();
    final result = await sendOtpUseCase(phoneNumber);
    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.unauthenticated();
        return true;
      },
    );
  }

  /// Verify OTP and log in.
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = const AuthState.loading();
    final result = await verifyOtpUseCase(VerifyOtpParams(phoneNumber: phoneNumber, otp: otp));
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Send password reset code to email.
  Future<bool> sendPasswordResetCode(String email) async {
    state = const AuthState.loading();
    final result = await sendResetCodeUseCase(email);
    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.unauthenticated();
        return true;
      },
    );
  }

  /// Submit the new password using reset code.
  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = const AuthState.loading();
    final result = await resetPasswordUseCase(
      ResetPasswordParams(email: email, code: code, newPassword: newPassword),
    );
    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.unauthenticated();
        return true;
      },
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
    sendOtpUseCase: getIt<SendOtpUseCase>(),
    verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
    sendResetCodeUseCase: getIt<SendResetCodeUseCase>(),
    resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    authEventBus: getIt<AuthEventBus>(),
  );
});
