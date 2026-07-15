import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/usecases/get_assistants_usecase.dart';
import '../state/assistants_state.dart';

final assistantsProvider = StateNotifierProvider<AssistantsNotifier, AssistantsState>((ref) {
  final authState = ref.watch(authProvider);
  final notifier = AssistantsNotifier(
    getAssistantsUseCase: getIt<GetAssistantsUseCase>(),
    secureStorage: getIt<SecureStorageService>(),
  );

  // Watch auth state to load active user's assistants
  authState.maybeWhen(
    authenticated: (user) {
      notifier.fetchAssistants(userId: user.id);
    },
    orElse: () {
      notifier.fetchAssistants();
    },
  );

  return notifier;
});

class AssistantsNotifier extends StateNotifier<AssistantsState> {
  final GetAssistantsUseCase getAssistantsUseCase;
  final SecureStorageService secureStorage;

  AssistantsNotifier({
    required this.getAssistantsUseCase,
    required this.secureStorage,
  }) : super(const AssistantsState.initial());

  Future<void> fetchAssistants({String? userId}) async {
    state = const AssistantsState.loading();

    // Fetch dynamic client credentials
    final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
    final finalUserId = userId ?? '1';

    final result = await getAssistantsUseCase(
      GetAssistantsParams(
        clientId: clientId,
        userId: finalUserId,
      ),
    );

    result.fold(
      (failure) => state = AssistantsState.error(failure.message),
      (assistants) => state = AssistantsState.loaded(assistants),
    );
  }
}
