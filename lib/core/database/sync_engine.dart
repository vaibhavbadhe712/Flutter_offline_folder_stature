import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import '../network/network_info.dart';
import '../logger/app_logger.dart';

/// SyncEngine stubbed out to remove offline database requirements.
@lazySingleton
class SyncEngine {
  final NetworkInfo _networkInfo;
  bool _isProcessing = false;

  SyncEngine(this._networkInfo) {
    // Automatically trigger queue processing on connection recovery.
    _networkInfo.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        AppLogger.i('Network connection restored. Triggering offline sync (Stubbbed)...');
        processQueue();
      }
    });
  }

  /// Add a failed mutation to the offline sync queue.
  Future<void> enqueueMutation({
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
  }) async {
    AppLogger.i('Offline: Enqueuing mutation [$method] $endpoint (Offline Database Disabled)');
  }

  /// Process all pending items in the sync queue.
  Future<void> processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;
    AppLogger.i('Offline sync queue processing initiated (Offline Database Disabled).');
    _isProcessing = false;
  }
}
