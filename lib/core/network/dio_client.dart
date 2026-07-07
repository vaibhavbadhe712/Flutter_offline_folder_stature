import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart';
import '../network/network_info.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// App-wide Networking client with retry, logging, and token refresh capabilities.
@lazySingleton
class DioClient {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  DioClient(
    this._networkInfo,
    AppConfig appConfig,
    AuthInterceptor authInterceptor,
    RefreshTokenInterceptor refreshInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) : _dio = Dio(
          BaseOptions(
            baseUrl: appConfig.baseUrl,
            connectTimeout: appConfig.timeoutDuration,
            receiveTimeout: appConfig.timeoutDuration,
            sendTimeout: appConfig.timeoutDuration,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.addAll([
      authInterceptor,
      refreshInterceptor,
      loggingInterceptor,
    ]);
  }

  /// Exposed getter to allow custom extensions/SSL pinning configurations
  Dio get dio => _dio;

  /// Perform a GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _sendRequest<T>(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// Perform a POST request.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _sendRequest<T>(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// Perform a PUT request.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _sendRequest<T>(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// Perform a DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _sendRequest<T>(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// Wraps Dio operations with network validation and custom Exception handling.
  Future<Response<T>> _sendRequest<T>(Future<Response<T>> Function() requestFunc) async {
    // 1. Connectivity Check
    if (!await _networkInfo.isConnected) {
      throw const NetworkException('No internet connection. Please check your connectivity.');
    }

    try {
      return await requestFunc();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected network error: $e');
    }
  }

  Exception _handleDioException(DioException error) {
    String msg = 'An unexpected server error occurred';
    int? code = error.response?.statusCode;
    dynamic data = error.response?.data;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException(message: 'Connection timed out. Please try again.', statusCode: 408);
      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Security validation failed (SSL certificate mismatch).', statusCode: 495);
      case DioExceptionType.badResponse:
        if (code == 401) {
          return const AuthException(message: 'Session has expired or credentials invalid.');
        }
        if (data is Map && data.containsKey('message')) {
          msg = data['message'] as String;
        } else if (error.response?.statusMessage != null) {
          msg = error.response!.statusMessage!;
        }
        return ServerException(message: msg, statusCode: code, errorData: data);
      case DioExceptionType.cancel:
        return const ServerException(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return const NetworkException('Unable to resolve host. DNS configuration error or internet is down.');
        }
        return const NetworkException('Connection to the server failed. Check your network.');
      default:
        return ServerException(message: error.message ?? 'Unknown transmission error', statusCode: code);
    }
  }
}
