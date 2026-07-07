import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);

      final userModel = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;

      // Persist locally
      await _localDataSource.saveTokens(accessToken, refreshToken);
      await _localDataSource.saveUser(userModel);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during login: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Remote session termination (best-effort)
      try {
        await _remoteDataSource.logout();
      } catch (_) {
        // Swallow remote errors to allow user to logout offline
      }
      
      // Clear local session storage
      await _localDataSource.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear session during logout: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final cachedUser = await _localDataSource.getUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error loading cached user: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    // This is managed by the network interceptor (RefreshTokenInterceptor) dynamically.
    // However, if we need to call it manually from a repository or sync engine, we expose it:
    try {
      // Here, we would make a remote call to refresh and return new access token.
      // For simplicity, we just stub the implementation:
      return const Right('new_simulated_token');
    } catch (e) {
      return Left(AuthFailure('Failed to manually refresh token: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String phoneNumber) async {
    try {
      await _remoteDataSource.sendOtp(phoneNumber);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during sending OTP: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await _remoteDataSource.verifyOtp(phoneNumber, otp);

      final userModel = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;

      // Persist locally
      await _localDataSource.saveTokens(accessToken, refreshToken);
      await _localDataSource.saveUser(userModel);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during OTP verification: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetCode(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetCode(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred while requesting password reset code: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(email: email, code: code, newPassword: newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during password reset: $e'));
    }
  }
}
