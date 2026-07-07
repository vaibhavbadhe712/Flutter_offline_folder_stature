/// Exception thrown during remote API communications.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const ServerException({
    required this.message,
    this.statusCode,
    this.errorData,
  });

  @override
  String toString() => 'ServerException: [$statusCode] $message';
}

/// Exception thrown during database or cache read/write operations.
class CacheException implements Exception {
  final String message;
  final dynamic originalError;

  const CacheException({required this.message, this.originalError});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when a network request is attempted but no connection is available.
class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network connectivity issues']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when authentication checks fail or refresh tokens expire.
class AuthException implements Exception {
  final String message;

  const AuthException({required this.message});

  @override
  String toString() => 'AuthException: $message';
}
