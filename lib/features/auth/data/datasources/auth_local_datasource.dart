import '../../../../core/database/app_database.dart';
import '../../../../core/storage/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

/// Protocol for storing and reading auth session data locally.
abstract class AuthLocalDataSource {
  /// Save access and refresh tokens.
  Future<void> saveTokens(String accessToken, String refreshToken);

  /// Cache the User model in SQLite.
  Future<void> saveUser(UserModel user);

  /// Retrieve the cached User profile.
  Future<UserModel?> getUser();

  /// Reset all stored session parameters (tokens and DB cache).
  Future<void> clearSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorage;
  final AppDatabase _database;

  AuthLocalDataSourceImpl(this._secureStorage, this._database);

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    // Keep local cache fresh by removing stale records
    await _database.delete(_database.users).go();
    await _database.into(_database.users).insert(
          UsersCompanion.insert(
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
          ),
        );
  }

  @override
  Future<UserModel?> getUser() async {
    final cached = await _database.select(_database.users).getSingleOrNull();
    if (cached == null) return null;
    return UserModel(
      id: cached.id,
      email: cached.email,
      name: cached.name,
      role: cached.role,
    );
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.clearAll();
    await _database.delete(_database.users).go();
  }
}
