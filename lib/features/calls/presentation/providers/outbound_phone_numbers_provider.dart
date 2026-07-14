import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/usecases/get_outbound_phone_numbers_usecase.dart';
import '../state/outbound_phone_numbers_state.dart';

final outboundPhoneNumbersProvider = StateNotifierProvider<OutboundPhoneNumbersNotifier, OutboundPhoneNumbersState>((ref) {
  final authState = ref.watch(authProvider);
  final notifier = OutboundPhoneNumbersNotifier(
    getOutboundPhoneNumbersUseCase: getIt<GetOutboundPhoneNumbersUseCase>(),
    secureStorage: getIt<SecureStorageService>(),
  );

  // Watch auth state to load active user's dialing numbers
  authState.maybeWhen(
    authenticated: (user) {
      notifier.fetchOutboundNumbers(userId: user.id);
    },
    orElse: () {
      notifier.fetchOutboundNumbers();
    },
  );

  return notifier;
});

class OutboundPhoneNumbersNotifier extends StateNotifier<OutboundPhoneNumbersState> {
  final GetOutboundPhoneNumbersUseCase getOutboundPhoneNumbersUseCase;
  final SecureStorageService secureStorage;

  OutboundPhoneNumbersNotifier({
    required this.getOutboundPhoneNumbersUseCase,
    required this.secureStorage,
  }) : super(const OutboundPhoneNumbersState.initial());

  Future<void> fetchOutboundNumbers({String? userId}) async {
    state = const OutboundPhoneNumbersState.loading();

    // Fetch dynamic client credentials
    final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
    final finalUserId = userId ?? '1';

    final result = await getOutboundPhoneNumbersUseCase(
      GetOutboundPhoneNumbersParams(
        clientId: clientId,
        userId: finalUserId,
      ),
    );

    result.fold(
      (failure) => state = OutboundPhoneNumbersState.error(failure.message),
      (phoneNumbers) => state = OutboundPhoneNumbersState.loaded(phoneNumbers),
    );
  }
}
