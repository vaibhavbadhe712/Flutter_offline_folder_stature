import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import 'package:injectable/injectable.dart';

/// Protocol for the remote authorization datasource.
abstract class AuthRemoteDataSource {
  /// Attempt login with credentials. Returns API response payload containing user info and tokens.
  Future<Map<String, dynamic>> login(String email, String password);

  /// Notify backend of active session termination.
  Future<void> logout();

  /// Request an OTP code.
  Future<void> sendOtp(String phoneNumber);

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
      '/auth/api/auth/login',
      data: {
        'email': email,
        'password': password,
        'captchaToken': null,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    final userJson = responseData['user'] as Map<String, dynamic>;
    final firstName = userJson['first_name'] as String? ?? '';
    final lastName = userJson['last_name'] as String? ?? '';
    final name = '$firstName $lastName'.trim();

    final mappedUser = {
      'id': userJson['id'] as String? ?? '',
      'email': userJson['email'] as String? ?? '',
      'name': name.isEmpty ? 'BAAP AI User' : name,
      'role': 'User',
    };

    return {
      'user': mappedUser,
      'access_token': responseData['access_token'] as String? ?? '',
      'refresh_token': responseData['refresh_token'] as String? ?? '',
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
  Future<void> sendOtp(String phoneNumber) async {
    // Extract the exact 10 digits (strip country code prefix like +91 and spaces)
    final cleanedPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final phone10Digits = cleanedPhone.length > 10
        ? cleanedPhone.substring(cleanedPhone.length - 10)
        : cleanedPhone;

    await _dioClient.post(
      '/auth/api/auth/request-otp',
      data: {'phone': phone10Digits},
    );
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    // Extract the exact 10 digits (strip country code prefix like +91 and spaces)
    final cleanedPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final phone10Digits = cleanedPhone.length > 10
        ? cleanedPhone.substring(cleanedPhone.length - 10)
        : cleanedPhone;

    final response = await _dioClient.post(
      '/auth/api/auth/verify-otp',
      data: {
        'phone': phone10Digits,
        'otp': otp,
        'captchaToken': null,
      },
    );

    final responseData = response.data as Map<String, dynamic>;
    final userJson = responseData['user'] as Map<String, dynamic>;
    final firstName = userJson['first_name'] as String? ?? '';
    final lastName = userJson['last_name'] as String? ?? '';
    final name = '$firstName $lastName'.trim();

    final mappedUser = {
      'id': userJson['id'] as String? ?? '',
      'email': userJson['email'] as String? ?? '',
      'name': name.isEmpty ? 'BAAP AI User' : name,
      'role': 'User',
    };

    return {
      'user': mappedUser,
      'access_token': responseData['access_token'] as String? ?? '',
      'refresh_token': responseData['refresh_token'] as String? ?? '',
    };
  }

  @override
  Future<void> sendPasswordResetCode(String email) async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1));
      if (email == 'error@company.com') {
        throw const AuthException(message: 'No user found with this email address.');
      }
      return;
    }

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
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1));
      if (code != '123456') {
        throw const AuthException(message: 'Invalid verification code. Use 123456.');
      }
      return;
    }

    await _dioClient.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      },
    );
  }
}
