import '../../../../core/network/dio_client.dart';
import '../models/phone_number_model.dart';
import 'package:injectable/injectable.dart';

abstract class CallsRemoteDataSource {
  Future<List<PhoneNumberModel>> getOutboundPhoneNumbers({
    required String clientId,
    required String userId,
  });
}

@LazySingleton(as: CallsRemoteDataSource)
class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  final DioClient _dioClient;

  CallsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<PhoneNumberModel>> getOutboundPhoneNumbers({
    required String clientId,
    required String userId,
  }) async {
    final path = '/api/phone-numbers/client/$clientId/user/$userId';
    
    final response = await _dioClient.get(path);
    
    final list = response.data as List<dynamic>;
    return list.map((json) => PhoneNumberModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
