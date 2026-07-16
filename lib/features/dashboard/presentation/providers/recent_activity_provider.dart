import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/usecases/get_recent_activity_usecase.dart';
import '../state/recent_activity_state.dart';

final recentActivityProvider = StateNotifierProvider<RecentActivityNotifier, RecentActivityState>((ref) {
  final authState = ref.watch(authProvider);
  final notifier = RecentActivityNotifier(
    getRecentActivityUseCase: getIt<GetRecentActivityUseCase>(),
    secureStorage: getIt<SecureStorageService>(),
  );

  authState.maybeWhen(
    authenticated: (user) {
      notifier.fetchRecentActivity(userId: user.id);
    },
    orElse: () {
      notifier.fetchRecentActivity();
    },
  );

  return notifier;
});

class RecentActivityNotifier extends StateNotifier<RecentActivityState> {
  final GetRecentActivityUseCase getRecentActivityUseCase;
  final SecureStorageService secureStorage;

  RecentActivityNotifier({
    required this.getRecentActivityUseCase,
    required this.secureStorage,
  }) : super(const RecentActivityState.initial());

  Future<void> fetchRecentActivity({String? userId}) async {
    state = const RecentActivityState.loading();

    final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
    final finalUserId = userId ?? '2';

    final result = await getRecentActivityUseCase(
      GetRecentActivityParams(
        clientId: clientId,
        userId: finalUserId,
      ),
    );

    result.fold(
      (failure) => state = RecentActivityState.error(failure.message),
      (activities) => state = RecentActivityState.loaded(activities),
    );
  }
}
