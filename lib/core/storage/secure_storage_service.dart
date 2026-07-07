import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// SecureStorageService provides APIs for reading/writing sensitive key-value data.
/// It uses iOS Keychain and Android Keystore via flutter_secure_storage.
@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService()
      : _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  /// Save access token.
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  /// Read access token.
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _keyAccessToken);
  }

  /// Delete access token.
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _keyAccessToken);
  }

  /// Save refresh token.
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  /// Read refresh token.
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  /// Delete refresh token.
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _keyRefreshToken);
  }

  /// Delete all stored credentials.
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
