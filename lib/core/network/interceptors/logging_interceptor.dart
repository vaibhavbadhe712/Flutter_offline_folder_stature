import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../logger/app_logger.dart';

/// LoggingInterceptor logs API requests, responses, and errors.
@lazySingleton
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
    AppLogger.d('Headers: ${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      AppLogger.d('QueryParameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      AppLogger.d('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d('<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
    AppLogger.d('Response: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.w('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.path}');
    AppLogger.w('Message: ${err.message}');
    if (err.response?.data != null) {
      AppLogger.w('Error Response Body: ${err.response?.data}');
    }
    handler.next(err);
  }
}
