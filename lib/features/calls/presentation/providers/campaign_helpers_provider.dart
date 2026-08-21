import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';

final campaignGroupsProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
  final dioClient = getIt<DioClient>();
  final secureStorage = getIt<SecureStorageService>();
  final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
  
  final path = '/api/contacts/client/$clientId/user/$userId/groups';
  final response = await dioClient.get(
    path,
    options: Options(headers: {'x-client-id': clientId, 'x-user-id': userId}),
  );
  
  List<String> groupsList = [];
  if (response.data is List) {
    final list = response.data as List<dynamic>;
    groupsList = list.map((e) {
      if (e is Map) {
        return (e['name'] ?? e['group'] ?? e['id'] ?? '').toString();
      }
      return e.toString();
    }).where((s) => s.isNotEmpty).toList();
  } else if (response.data is Map) {
    final dataMap = response.data as Map<String, dynamic>;
    final dynamic groupsData = dataMap['groups'] ?? dataMap['data'] ?? dataMap['results'] ?? [];
    if (groupsData is List) {
      groupsList = groupsData.map((e) {
        if (e is Map) {
          return (e['name'] ?? e['group'] ?? e['id'] ?? '').toString();
        }
        return e.toString();
      }).where((s) => s.isNotEmpty).toList();
    }
  }
  return groupsList;
});

final campaignFilesProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
  final dioClient = getIt<DioClient>();
  final secureStorage = getIt<SecureStorageService>();
  final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';

  final response = await dioClient.get(
    '/api/contacts/client/$clientId/user/$userId/files',
    options: Options(headers: {'x-client-id': clientId, 'x-user-id': userId}),
  );

  final files = response.data is Map
      ? (response.data as Map)['files'] ?? (response.data as Map)['data'] ?? []
      : response.data;
  if (files is! List) return const [];

  return files
      .map((file) {
        if (file is Map) {
          return (file['filename'] ?? file['file_name'] ?? file['name'] ?? file['id'] ?? '').toString();
        }
        return file.toString();
      })
      .where((file) => file.isNotEmpty)
      .toList();
});

final bulkCampaignProvider = StateNotifierProvider<BulkCampaignNotifier, AsyncValue<String>>(
  (ref) => BulkCampaignNotifier(
    dioClient: getIt<DioClient>(),
    secureStorage: getIt<SecureStorageService>(),
  ),
);

class BulkCampaignNotifier extends StateNotifier<AsyncValue<String>> {
  BulkCampaignNotifier({
    required this.dioClient,
    required this.secureStorage,
  }) : super(const AsyncValue.data(''));

  final DioClient dioClient;
  final SecureStorageService secureStorage;

  Future<void> launch({
    required String userId,
    required String name,
    required String assistantId,
    required String? phoneNumberId,
    required String defaultLine,
    required String targetType,
    required String? targetValue,
    required int batchSize,
    required DateTime? runAt,
    required bool callWindowEnabled,
  }) async {
    state = const AsyncValue.loading();
    try {
      final clientId = await secureStorage.getSelectedClientId();
      if (clientId == null || clientId.isEmpty) {
        throw StateError('Select a workspace before launching a campaign.');
      }

      final response = await dioClient.post<Map<String, dynamic>>(
        '/api/campaigns/client/$clientId/user/$userId/ai-bulk',
        data: {
          'name': name,
          'assistant_id': assistantId,
          'phone_number_id': phoneNumberId,
          'default_line': defaultLine,
          'target_type': targetType,
          'target_value': targetValue,
          'batch_size': batchSize,
          'run_at': runAt?.toUtc().toIso8601String(),
          'call_window_enabled': callWindowEnabled,
          'call_window_start': null,
          'call_window_end': null,
        },
        options: Options(headers: {'x-client-id': clientId, 'x-user-id': userId}),
      );
      final data = response.data;
      state = AsyncValue.data(
        (data?['message'] ?? data?['status'] ?? 'Campaign launched successfully.').toString(),
      );
    } catch (error, stackTrace) {
      if (error is ServerException && error.errorData != null) {
        state = AsyncValue.error(
          '${error.message}: ${_formatValidationError(error.errorData)}',
          stackTrace,
        );
      } else {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  String _formatValidationError(dynamic errorData) {
    if (errorData is Map && errorData['detail'] != null) {
      return errorData['detail'].toString();
    }
    return errorData.toString();
  }
}
