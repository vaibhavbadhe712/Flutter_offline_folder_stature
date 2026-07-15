import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/usecases/start_test_call_usecase.dart';
import '../state/start_call_state.dart';

final startCallProvider = StateNotifierProvider<StartCallNotifier, StartCallState>((ref) {
  return StartCallNotifier(
    startTestCallUseCase: getIt<StartTestCallUseCase>(),
    secureStorage: getIt<SecureStorageService>(),
  );
});

class StartCallNotifier extends StateNotifier<StartCallState> {
  final StartTestCallUseCase startTestCallUseCase;
  final SecureStorageService secureStorage;

  StartCallNotifier({
    required this.startTestCallUseCase,
    required this.secureStorage,
  }) : super(const StartCallState.initial());

  Future<void> startTestCall({
    required int assistantId,
    required String toNumber,
    required int phoneNumberId,
    required int contactId,
    String? userId,
  }) async {
    state = const StartCallState.loading();

    final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
    final finalUserId = userId ?? '1';

    final result = await startTestCallUseCase(
      StartTestCallParams(
        clientId: clientId,
        userId: finalUserId,
        assistantId: assistantId,
        toNumber: toNumber,
        phoneNumberId: phoneNumberId,
        contactId: contactId,
      ),
    );

    result.fold(
      (failure) => state = StartCallState.error(failure.message),
      (message) => state = StartCallState.success(message),
    );
  }

  void reset() {
    state = const StartCallState.initial();
  }
}
