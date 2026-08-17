import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';

final campaignGroupsProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
  final dioClient = getIt<DioClient>();
  final secureStorage = getIt<SecureStorageService>();
  final clientId = await secureStorage.getSelectedClientId() ?? '3cdca960-1f63-4064-b832-a512799460f9';
  
  final path = '/api/contacts/client/$clientId/user/$userId/groups';
  final response = await dioClient.get(path);
  
  List<String> groupsList = [];
  if (response.data is List) {
    final list = response.data as List<dynamic>;
    groupsList = list.map((e) {
      if (e is Map) {
        return (e['name'] ?? e['group'] ?? e['id'] ?? '').toString();
      }
      return e.toString();
    }).where((s) => s.isNotEmpty).toList();
  } else if (response.data is Map) {
    final dataMap = response.data as Map<String, dynamic>;
    final dynamic groupsData = dataMap['groups'] ?? dataMap['data'] ?? dataMap['results'] ?? [];
    if (groupsData is List) {
      groupsList = groupsData.map((e) {
        if (e is Map) {
          return (e['name'] ?? e['group'] ?? e['id'] ?? '').toString();
        }
        return e.toString();
      }).where((s) => s.isNotEmpty).toList();
    }
  }
  return groupsList;
});
