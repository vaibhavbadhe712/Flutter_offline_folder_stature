import 'dart:convert';
import '../../../../core/storage/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

/// Protocol for storing and reading auth session data locally.
abstract class AuthLocalDataSource {
  /// Save access and refresh tokens.
  Future<void> saveTokens(String accessToken, String refreshToken);

  /// Cache the User model securely.
  Future<void> saveUser(UserModel user);

  /// Retrieve the cached User profile.
  Future<UserModel?> getUser();

  /// Reset all stored session parameters (tokens and cached user data).
  Future<void> clearSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _secureStorage.saveUserData(userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await _secureStorage.getUserData();
    if (userJson == null) return null;
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.clearAll();
  }
}
