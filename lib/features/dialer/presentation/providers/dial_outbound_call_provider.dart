import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../calls/domain/repositories/calls_repository.dart';

final dialOutboundCallProvider =
    StateNotifierProvider<DialOutboundCallNotifier, bool>((ref) {
      return DialOutboundCallNotifier(
        repository: getIt<CallsRepository>(),
        secureStorage: getIt<SecureStorageService>(),
      );
    });

class DialOutboundCallNotifier extends StateNotifier<bool> {
  DialOutboundCallNotifier({
    required this.repository,
    required this.secureStorage,
  }) : super(false);

  final CallsRepository repository;
  final SecureStorageService secureStorage;

   Future<String?> dial({
    required String userId,
    required String toNumber,
  }) async {
    if (state) return null;

    state = true;
    try {
      final clientId = await secureStorage.getSelectedClientId();
      if (clientId == null || clientId.isEmpty) {
        return 'Select a workspace before placing a call.';
      }

      final result = await repository.dialOutbound(
        clientId: clientId,
        userId: userId,
        toNumber: toNumber,
        provider: 'vobiz',
      );
      return result.fold((failure) => failure.message, (_) => null);
    } finally {
      state = false;
    }
  }
}
