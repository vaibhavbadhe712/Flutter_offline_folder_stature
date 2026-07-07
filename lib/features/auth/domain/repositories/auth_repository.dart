import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Contract defining authorization and session operations.
abstract class AuthRepository {
  /// Perform login using credentials.
  Future<Either<Failure, UserEntity>> login(String email, String password);

  /// Terminate the active session, clearing local caches.
  Future<Either<Failure, void>> logout();

  /// Retrieve the currently authenticated user from cache or remote server.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Silently refresh expired access credentials using cached tokens.
  Future<Either<Failure, String>> refreshToken();

  /// Request an OTP code for phone login.
  Future<Either<Failure, void>> sendOtp(String phoneNumber);

  /// Verify phone number and OTP code.
  Future<Either<Failure, UserEntity>> verifyOtp(String phoneNumber, String otp);

  /// Request a password reset code.
  Future<Either<Failure, void>> sendPasswordResetCode(String email);

  /// Reset the password with code.
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
