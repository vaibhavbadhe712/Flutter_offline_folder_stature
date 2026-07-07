import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../storage/secure_storage_service.dart';

/// Interceptor to automatically attach the access token to outgoing requests.
@lazySingleton
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If authorization header is already manually set, we do not overwrite it.
    if (!options.headers.containsKey('Authorization')) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
