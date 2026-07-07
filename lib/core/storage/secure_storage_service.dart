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
  static const String _keyUserData = 'user_data';

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

  /// Save cached user data.
  Future<void> saveUserData(String userDataJson) async {
    await _secureStorage.write(key: _keyUserData, value: userDataJson);
  }

  /// Read cached user data.
  Future<String?> getUserData() async {
    return await _secureStorage.read(key: _keyUserData);
  }

  /// Delete cached user data.
  Future<void> deleteUserData() async {
    await _secureStorage.delete(key: _keyUserData);
  }

  static const String _keyClientId = 'selected_client_id';
  static const String _keyClientName = 'selected_client_name';

  /// Save selected client group.
  Future<void> saveSelectedClient(String clientId, String clientName) async {
    await _secureStorage.write(key: _keyClientId, value: clientId);
    await _secureStorage.write(key: _keyClientName, value: clientName);
  }

  /// Read selected client ID.
  Future<String?> getSelectedClientId() async {
    return await _secureStorage.read(key: _keyClientId);
  }

  /// Read selected client Name.
  Future<String?> getSelectedClientName() async {
    return await _secureStorage.read(key: _keyClientName);
  }

  /// Delete selected client.
  Future<void> deleteSelectedClient() async {
    await _secureStorage.delete(key: _keyClientId);
    await _secureStorage.delete(key: _keyClientName);
  }

  /// Delete all stored credentials.
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
