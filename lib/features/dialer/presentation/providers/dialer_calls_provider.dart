import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final dialerCallsProvider =
    StateNotifierProvider<DialerCallsNotifier, AsyncValue<List<DialerCall>>>(
  (ref) {
    final notifier = DialerCallsNotifier(
      dioClient: getIt<DioClient>(),
      secureStorage: getIt<SecureStorageService>(),
    );
    ref.watch(authProvider).maybeWhen(
          authenticated: (user) => notifier.fetchCalls(userId: user.id),
          orElse: () {},
        );
    return notifier;
  },
);

class DialerCallsNotifier extends StateNotifier<AsyncValue<List<DialerCall>>> {
  DialerCallsNotifier({
    required this.dioClient,
    required this.secureStorage,
  }) : super(const AsyncValue.loading());

  final DioClient dioClient;
  final SecureStorageService secureStorage;

  Future<void> fetchCalls({required String userId}) async {
    state = const AsyncValue.loading();
    try {
      final clientId = await secureStorage.getSelectedClientId();
      if (clientId == null || clientId.isEmpty) {
        throw StateError('Select a workspace before viewing calls.');
      }

      final response = await dioClient.get<Map<String, dynamic>>(
        '/api/dialer/client/$clientId/user/$userId/calls',
        queryParameters: const {'skip': 0, 'limit': 10},
        options: Options(headers: {
          'x-client-id': clientId,
          'x-user-id': userId,
        }),
      );
      final payload = response.data ?? const <String, dynamic>{};
      final items = (payload['data'] as List<dynamic>? ?? const [])
          .map((item) => DialerCall.fromJson(item as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class DialerCall {
  const DialerCall({
    required this.id,
    required this.direction,
    required this.toNumber,
    required this.status,
    required this.durationSeconds,
    required this.startedAt,
  });

  final String id;
  final String direction;
  final String toNumber;
  final String status;
  final int durationSeconds;
  final String startedAt;

  factory DialerCall.fromJson(Map<String, dynamic> json) {
    return DialerCall(
      id: json['id'] as String? ?? '',
      direction: json['direction'] as String? ?? 'outbound',
      toNumber: json['to_number'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      durationSeconds: (json['duration_seconds'] as num?)?.toInt() ?? 0,
      startedAt: json['started_at'] as String? ?? '',
    );
  }
}
