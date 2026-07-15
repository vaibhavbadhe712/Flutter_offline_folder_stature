import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/usecases/get_contacts_usecase.dart';
import '../state/contacts_state.dart';

final contactsProvider = StateNotifierProvider<ContactsNotifier, ContactsState>((ref) {
  final authState = ref.watch(authProvider);
  final notifier = ContactsNotifier(
    getContactsUseCase: getIt<GetContactsUseCase>(),
    secureStorage: getIt<SecureStorageService>(),
  );

  // Watch auth state to load active user's contacts
  authState.maybeWhen(
    authenticated: (user) {
      notifier.fetchContacts(userId: user.id);
    },
    orElse: () {
      notifier.fetchContacts();
    },
  );

  return notifier;
});

class ContactsNotifier extends StateNotifier<ContactsState> {
  final GetContactsUseCase getContactsUseCase;
  final SecureStorageService secureStorage;

  ContactsNotifier({
    required this.getContactsUseCase,
    required this.secureStorage,
  }) : super(const ContactsState.initial());

  Future<void> fetchContacts({String? userId}) async {
    state = const ContactsState.loading();

    // Fetch dynamic client credentials
    final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
    final finalUserId = userId ?? '1';

    final result = await getContactsUseCase(
      GetContactsParams(
        clientId: clientId,
        userId: finalUserId,
      ),
    );

    result.fold(
      (failure) => state = ContactsState.error(failure.message),
      (contacts) => state = ContactsState.loaded(contacts),
    );
  }
}
