import 'dart:async';
import 'package:injectable/injectable.dart';

/// Event type for global authentication changes.
enum AuthEvent { logout }

/// Event bus to broadcast authentication events (like forced logout) across the application.
@lazySingleton
class AuthEventBus {
  final _controller = StreamController<AuthEvent>.broadcast();

  /// Stream of authentication events.
  Stream<AuthEvent> get events => _controller.stream;

  /// Fire a logout event to force redirection.
  void fireLogout() {
    _controller.add(AuthEvent.logout);
  }
}
