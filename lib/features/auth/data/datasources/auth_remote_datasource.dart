import '../../../../core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

/// Protocol for the remote authorization datasource.
abstract class AuthRemoteDataSource {
  /// Attempt login with credentials. Returns API response payload containing user info and tokens.
  Future<Map<String, dynamic>> login(String email, String password);

  /// Notify backend of active session termination.
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Note: In production this points to your specific auth route.
    final response = await _dioClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    // Call remote logout endpoint
    await _dioClient.post('/auth/logout');
  }
}
