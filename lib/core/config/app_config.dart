import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

/// Configuration service wrapping flutter_dotenv to read typed environment parameters.
@lazySingleton
class AppConfig {
  /// Name of the current active environment (e.g. DEVELOPMENT, QA, PRODUCTION).
  String get environmentName => dotenv.get('ENV_NAME', fallback: 'DEVELOPMENT');

  /// Base API Endpoint url.
  String get baseUrl => dotenv.get('API_BASE_URL', fallback: 'https://api.example.com/v1');

  /// Timeout configuration duration for network connections.
  Duration get timeoutDuration {
    final seconds = int.tryParse(dotenv.get('API_TIMEOUT_SECONDS')) ?? 15;
    return Duration(seconds: seconds);
  }

  /// Helper flag to check if the current builds are in production.
  bool get isProduction => environmentName == 'PRODUCTION';
}
