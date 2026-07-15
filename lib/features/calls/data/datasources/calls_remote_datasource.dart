import '../../../../core/network/dio_client.dart';
import '../models/phone_number_model.dart';
import '../models/assistant_model.dart';
import '../models/contact_model.dart';
import 'package:injectable/injectable.dart';

abstract class CallsRemoteDataSource {
  Future<List<PhoneNumberModel>> getOutboundPhoneNumbers({
    required String clientId,
    required String userId,
  });

  Future<List<AssistantModel>> getAssistants({
    required String clientId,
    required String userId,
  });

  Future<List<ContactModel>> getContacts({
    required String clientId,
    required String userId,
  });

  Future<String> startTestCall({
    required String clientId,
    required String userId,
    required int assistantId,
    required String toNumber,
    required int phoneNumberId,
    required int contactId,
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

  @override
  Future<List<AssistantModel>> getAssistants({
    required String clientId,
    required String userId,
  }) async {
    final path = '/api/assistants/client/$clientId/user/$userId';
    
    final response = await _dioClient.get(path);
    
    final list = response.data as List<dynamic>;
    return list.map((json) => AssistantModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ContactModel>> getContacts({
    required String clientId,
    required String userId,
  }) async {
    final path = '/api/contacts/client/$clientId/user/$userId';
    
    final response = await _dioClient.get(path);
    
    final responseData = response.data as Map<String, dynamic>;
    final list = responseData['contacts'] as List<dynamic>;
    return list.map((json) => ContactModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<String> startTestCall({
    required String clientId,
    required String userId,
    required int assistantId,
    required String toNumber,
    required int phoneNumberId,
    required int contactId,
  }) async {
    final path = '/api/calls/client/$clientId/user/$userId/start';
    
    final response = await _dioClient.post(
      path,
      data: {
        'assistant_id': assistantId,
        'to_number': toNumber,
        'phone_number_id': phoneNumberId,
        'contact_id': contactId,
      },
    );
    final responseData = response.data as Map<String, dynamic>;
    return responseData['message'] as String;
  }
}
