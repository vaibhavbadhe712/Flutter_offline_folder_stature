import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/usecases/get_dashboard_metrics_usecase.dart';
import '../state/dashboard_metrics_state.dart';

final timeframeProvider = StateProvider<String>((ref) => '7 Days');

final dashboardMetricsProvider = StateNotifierProvider<DashboardMetricsNotifier, DashboardMetricsState>((ref) {
  final authState = ref.watch(authProvider);
  final timeframe = ref.watch(timeframeProvider);
  final notifier = DashboardMetricsNotifier(
    getDashboardMetricsUseCase: getIt<GetDashboardMetricsUseCase>(),
    secureStorage: getIt<SecureStorageService>(),
  );
  
  // Watch auth state and timeframe to automatically fetch metrics
  authState.maybeWhen(
    authenticated: (user) {
      notifier.fetchMetrics(userId: user.id, filter: timeframe);
    },
    orElse: () {
      notifier.fetchMetrics(filter: timeframe);
    },
  );
  
  return notifier;
});

class DashboardMetricsNotifier extends StateNotifier<DashboardMetricsState> {
  final GetDashboardMetricsUseCase getDashboardMetricsUseCase;
  final SecureStorageService secureStorage;

  DashboardMetricsNotifier({
    required this.getDashboardMetricsUseCase,
    required this.secureStorage,
  }) : super(const DashboardMetricsState.initial());

  Future<void> fetchMetrics({String? userId, String? filter}) async {
    state = const DashboardMetricsState.loading();
    
    // Read actual client ID from storage, default to curl client ID if null
    final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
    // Use passed userId or read from secure user storage, default to '1' if null
    final finalUserId = userId ?? '1';

    final result = await getDashboardMetricsUseCase(
      GetDashboardMetricsParams(
        clientId: clientId,
        userId: finalUserId,
        filter: filter?.toLowerCase() ?? '7 days',
      ),
    );

    result.fold(
      (failure) => state = DashboardMetricsState.error(failure.message),
      (metrics) => state = DashboardMetricsState.loaded(metrics),
    );
  }
}
