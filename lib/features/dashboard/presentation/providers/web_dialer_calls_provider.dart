import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/web_dialer_call_model.dart';

class WebDialerCallsNotifier extends StateNotifier<AsyncValue<List<WebDialerCall>>> {
  final DioClient _dioClient;
  final SecureStorageService _secureStorage;

  WebDialerCallsNotifier({
    required DioClient dioClient,
    required SecureStorageService secureStorage,
  })  : _dioClient = dioClient,
        _secureStorage = secureStorage,
        super(const AsyncValue.loading());

  Future<void> fetchCalls({String? userId}) async {
    state = const AsyncValue.loading();
    try {
      final clientId = await _secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
      final finalUserId = userId ?? 'd6e723df-7a48-4710-aa9a-57f32763eb19';
      
      final path = '/api/dialer/client/$clientId/user/$finalUserId/calls';
      
      final response = await _dioClient.get(
        path,
        queryParameters: {
          'skip': 0,
          'limit': 10,
        },
      );
      
      final List<dynamic> dataList = (response.data is List) 
          ? response.data 
          : (response.data is Map && (response.data as Map).containsKey('calls'))
              ? (response.data as Map)['calls']
              : (response.data is Map && (response.data as Map).containsKey('data'))
                  ? (response.data as Map)['data']
                  : [];
                  
      final calls = dataList.map((e) => WebDialerCall.fromJson(e as Map<String, dynamic>)).toList();
      state = AsyncValue.data(calls);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final webDialerCallsProvider = StateNotifierProvider<WebDialerCallsNotifier, AsyncValue<List<WebDialerCall>>>((ref) {
  final authState = ref.watch(authProvider);
  final notifier = WebDialerCallsNotifier(
    dioClient: getIt<DioClient>(),
    secureStorage: getIt<SecureStorageService>(),
  );
  
  authState.maybeWhen(
    authenticated: (user) {
      notifier.fetchCalls(userId: user.id);
    },
    orElse: () {
      notifier.fetchCalls();
    },
  );
  
  return notifier;
});
