/// Base class for all operational failures in the application.
abstract class Failure {
  final String message;
  final dynamic error;

  const Failure(this.message, [this.error]);

  @override
  String toString() => '$runtimeType: $message';
}

/// Represents failures related to network requests or backend API errors.
class ServerFailure extends Failure {
  final int? statusCode;
  final dynamic errorData;

  const ServerFailure({
    required String message,
    this.statusCode,
    this.errorData,
    dynamic error,
  }) : super(message, error);
}

/// Represents cache-related errors, e.g., local database queries or file reading issues.
class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.error]);
}

/// Represents failures due to a lack of network connection.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']);
}

/// Represents authentication or authorization failures (e.g., expired session, access denied).
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.error]);
}

/// Represents input validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// A catch-all failure class for unforeseen local system errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, [super.error]);
}
