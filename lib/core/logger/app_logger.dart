import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// AppLogger provides structured logging across the application.
/// It automatically disables output in release builds.
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
    filter: ProductionFilter(),
  );

  /// Log message at debug level.
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log message at info level.
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log message at warning level.
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log message at error level.
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    // In production, you would report this to Sentry or Firebase Crashlytics here.
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    } else {
      // e.g., FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
    }
  }
}

/// Filter that allows logs in development and suppresses them in release.
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}
