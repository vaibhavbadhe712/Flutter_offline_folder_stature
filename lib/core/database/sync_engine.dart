import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../network/network_info.dart';
import '../network/dio_client.dart';
import '../logger/app_logger.dart';
import 'app_database.dart';

/// SyncEngine orchestrates caching and automatic/background uploads of offline mutations.
@lazySingleton
class SyncEngine {
  final AppDatabase _database;
  final NetworkInfo _networkInfo;
  final DioClient _dioClient;
  bool _isProcessing = false;

  SyncEngine(this._database, this._networkInfo, this._dioClient) {
    // Automatically trigger queue processing on connection recovery.
    _networkInfo.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        AppLogger.i('Network connection restored. Triggering offline sync...');
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
    final payloadString = jsonEncode(payload);
    AppLogger.i('Offline: Enqueuing mutation [$method] $endpoint');

    await _database.into(_database.syncQueue).insert(
          SyncQueueCompanion.insert(
            endpoint: endpoint,
            method: method,
            payload: payloadString,
          ),
        );
  }

  /// Process all pending items in the sync queue.
  Future<void> processQueue() async {
    if (_isProcessing) return;

    if (!await _networkInfo.isConnected) {
      AppLogger.w('Sync aborted: device is offline.');
      return;
    }

    _isProcessing = true;
    AppLogger.i('Starting offline sync queue processing...');

    try {
      final queueItems = await (_database.select(_database.syncQueue)
            ..orderBy([
              (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
            ]))
          .get();

      AppLogger.i('Found ${queueItems.length} pending mutations in queue.');

      for (final item in queueItems) {
        final success = await _syncItem(item);
        if (!success) {
          // If we encountered a connectivity error during sync, halt the rest of the queue
          if (!await _networkInfo.isConnected) {
            AppLogger.w('Connectivity lost during sync processing. Halting.');
            break;
          }
        }
      }
    } catch (e, s) {
      AppLogger.e('Error processing sync queue: $e', e, s);
    } finally {
      _isProcessing = false;
      AppLogger.i('Offline sync queue processing complete.');
    }
  }

  Future<bool> _syncItem(SyncQueueData item) async {
    AppLogger.d('Syncing item #${item.id}: [${item.method}] ${item.endpoint}');
    final payload = jsonDecode(item.payload);

    try {
      // Execute the request via Dio
      switch (item.method.toUpperCase()) {
        case 'POST':
          await _dioClient.post(item.endpoint, data: payload);
        case 'PUT':
          await _dioClient.put(item.endpoint, data: payload);
        case 'DELETE':
          await _dioClient.delete(item.endpoint, data: payload);
        default:
          throw UnsupportedError('HTTP method ${item.method} not supported in sync engine');
      }

      // If successful, delete from queue
      await (_database.delete(_database.syncQueue)..where((t) => t.id.equals(item.id))).go();
      AppLogger.i('Sync item #${item.id} processed and removed.');
      return true;
    } catch (e) {
      final updatedAttempts = item.attempts + 1;
      AppLogger.w('Failed syncing item #${item.id} (Attempt $updatedAttempts): $e');

      if (updatedAttempts >= 5) {
        // Discard or move to DLQ (Dead Letter Queue) after 5 retries to prevent blocking the queue
        await (_database.delete(_database.syncQueue)..where((t) => t.id.equals(item.id))).go();
        AppLogger.e('Sync item #${item.id} exceeded maximum retries. Discarded (Dead Letter).');
      } else {
        // Update retry attempt and log error
        await (_database.update(_database.syncQueue)..where((t) => t.id.equals(item.id))).write(
          SyncQueueCompanion(
            attempts: Value(updatedAttempts),
            lastError: Value(e.toString()),
          ),
        );
      }
      return false;
    }
  }
}
