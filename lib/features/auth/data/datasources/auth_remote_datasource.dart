import '../../../../core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

/// Protocol for the remote authorization datasource.
abstract class AuthRemoteDataSource {
  /// Attempt login with credentials. Returns API response payload containing user info and tokens.
  Future<Map<String, dynamic>> login(String email, String password);

  /// Notify backend of active session termination.
  Future<void> logout();

  /// Request an OTP code.
  Future<String> sendOtp(String phoneNumber);

  /// Verify OTP and return tokens + user.
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp);

  /// Send password reset code.
  Future<void> sendPasswordResetCode(String email);

  /// Set new password with code.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Sign up a new user.
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  
  // Toggle this to false once actual backend APIs are ready
  static const bool _useMock = true;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dioClient.post(
      '/auth/login-password',
      data: {
        'email': email,
        'password': password,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    
    // Support both nested 'user' object and root level user fields
    final Map<String, dynamic> userJson = (responseData['user'] is Map)
        ? responseData['user'] as Map<String, dynamic>
        : responseData;

    final firstName = userJson['first_name'] as String? ?? userJson['firstName'] as String? ?? '';
    final lastName = userJson['last_name'] as String? ?? userJson['lastName'] as String? ?? '';
    var name = userJson['name'] as String? ?? '';
    if (name.isEmpty) {
      name = '$firstName $lastName'.trim();
    }

    final mappedUser = {
      'id': userJson['id'] as String? ?? userJson['userId'] as String? ?? userJson['_id'] as String? ?? '',
      'email': userJson['email'] as String? ?? '',
      'name': name.isEmpty ? 'BAAP AI User' : name,
      'role': userJson['role'] as String? ?? 'User',
    };

    return {
      'user': mappedUser,
      'access_token': responseData['access_token'] as String? ?? responseData['accessToken'] as String? ?? '',
      'refresh_token': responseData['refresh_token'] as String? ?? responseData['refreshToken'] as String? ?? '',
      'client_id': responseData['client_id'] as String? ?? '',
    };
  }

  @override
  Future<void> logout() async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
    await _dioClient.post('/auth/logout');
  }

  @override
  Future<String> sendOtp(String phoneNumber) async {
    // Extract the exact 10 digits (strip country code prefix like +91 and spaces)
    final cleanedPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final phone10Digits = cleanedPhone.length > 10
        ? cleanedPhone.substring(cleanedPhone.length - 10)
        : cleanedPhone;

    final response = await _dioClient.post(
      '/auth/request-otp',
      data: {'phone': phone10Digits},
    );
    final responseData = response.data as Map<String, dynamic>;
    return responseData['message'] as String? ?? 'OTP sent successfully';
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    // Extract the exact 10 digits (strip country code prefix like +91 and spaces)
    final cleanedPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final phone10Digits = cleanedPhone.length > 10
        ? cleanedPhone.substring(cleanedPhone.length - 10)
        : cleanedPhone;

    final response = await _dioClient.post(
      '/auth/verify-otp',
      data: {
        'phone': phone10Digits,
        'otp': otp,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    
    // Support both nested 'user' object and root level user fields
    final Map<String, dynamic> userJson = (responseData['user'] is Map)
        ? responseData['user'] as Map<String, dynamic>
        : responseData;

    final firstName = userJson['first_name'] as String? ?? userJson['firstName'] as String? ?? '';
    final lastName = userJson['last_name'] as String? ?? userJson['lastName'] as String? ?? '';
    var name = userJson['name'] as String? ?? '';
    if (name.isEmpty) {
      name = '$firstName $lastName'.trim();
    }

    final mappedUser = {
      'id': userJson['id'] as String? ?? userJson['userId'] as String? ?? userJson['_id'] as String? ?? '',
      'email': userJson['email'] as String? ?? '',
      'name': name.isEmpty ? 'BAAP AI User' : name,
      'role': userJson['role'] as String? ?? 'User',
    };

    return {
      'user': mappedUser,
      'access_token': responseData['access_token'] as String? ?? responseData['accessToken'] as String? ?? '',
      'refresh_token': responseData['refresh_token'] as String? ?? responseData['refreshToken'] as String? ?? '',
      'client_id': responseData['client_id'] as String? ?? '',
    };
  }

  @override
  Future<void> sendPasswordResetCode(String email) async {
    await _dioClient.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _dioClient.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'otp': code,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final response = await _dioClient.post(
      '/auth/signup',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'clientId': '3cdca960-1f63-4064-b832-a512799460f9',
        'phone': phone,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
