import 'dart:async';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../storage/secure_storage_service.dart';
import '../auth_event_bus.dart';
import '../../logger/app_logger.dart';

/// Interceptor that handles 401 unauthorized errors, automatically triggers token refresh,
/// and queues concurrent requests to retry once a new token is obtained.
@lazySingleton
class RefreshTokenInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final AuthEventBus _authEventBus;
  final Dio _refreshDio;

  RefreshTokenInterceptor(this._secureStorage, this._authEventBus)
      : _refreshDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );

  bool _isRefreshing = false;
  final List<Completer<String?>> _requestsQueue = [];

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // If the response is a 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      // Prevent infinite refresh loop by checking if this is already a retry.
      if (requestOptions.headers['X-Retry'] == 'true') {
        AppLogger.w('Token refresh failed again on retry. Bypassing further retries.');
        handler.next(err);
        return;
      }

      final Completer<String?> completer = Completer<String?>();
      _requestsQueue.add(completer);

      if (!_isRefreshing) {
        _isRefreshing = true;
        AppLogger.i('Access token expired (401). Initiating refresh token flow...');

        _refreshTokenFlow().then((newToken) {
          _isRefreshing = false;
          AppLogger.i('Token refresh success. Releasing queued requests.');
          for (var c in _requestsQueue) {
            c.complete(newToken);
          }
          _requestsQueue.clear();
        }).catchError((error, stackTrace) {
          _isRefreshing = false;
          AppLogger.e('Token refresh execution failed: $error', error, stackTrace);
          for (var c in _requestsQueue) {
            c.complete(null);
          }
          _requestsQueue.clear();
        });
      }

      // Await token refresh resolution
      final newToken = await completer.future;

      if (newToken != null) {
        // Prepare retry options
        final options = Options(
          method: requestOptions.method,
          headers: Map<String, dynamic>.from(requestOptions.headers)
            ..['Authorization'] = 'Bearer $newToken'
            ..['X-Retry'] = 'true', // Flag to prevent infinite retry
          extra: requestOptions.extra,
          contentType: requestOptions.contentType,
          responseType: requestOptions.responseType,
          sendTimeout: requestOptions.sendTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
        );

        try {
          AppLogger.i('Retrying original request: ${requestOptions.path}');
          // Perform retry using a clean Dio instance
          final response = await Dio().request(
            requestOptions.path.startsWith('http')
                ? requestOptions.path
                : '${requestOptions.baseUrl}${requestOptions.path}',
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: options,
          );
          handler.resolve(response);
        } on DioException catch (retryErr) {
          handler.next(retryErr);
        }
      } else {
        // If refresh failed, reject original request
        handler.next(err);
      }
      return;
    }

    handler.next(err);
  }

  Future<String?> _refreshTokenFlow() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) {
      AppLogger.w('Refresh token not found in secure storage. Logging out.');
      await _logout();
      return null;
    }

    try {
      // Direct call to refresh endpoint
      // Base URL should ideally match your production/stage environment configs.
      final response = await _refreshDio.post(
        'https://api.example.com/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['access_token'] as String;
        final newRefreshToken = response.data['refresh_token'] as String;

        await _secureStorage.saveAccessToken(newAccessToken);
        await _secureStorage.saveRefreshToken(newRefreshToken);

        AppLogger.i('Tokens successfully updated in Secure Storage.');
        return newAccessToken;
      } else {
        AppLogger.e('Refresh token endpoint returned status: ${response.statusCode}');
        await _logout();
        return null;
      }
    } catch (e) {
      AppLogger.e('Failed to perform API request for token refresh: $e');
      await _logout();
      return null;
    }
  }

  Future<void> _logout() async {
    AppLogger.w('Clearing local session and broadcasting logout event.');
    await _secureStorage.clearAll();
    _authEventBus.fireLogout();
  }
}
