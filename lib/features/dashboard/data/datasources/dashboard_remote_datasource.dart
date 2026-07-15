import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_metrics_model.dart';
import 'package:injectable/injectable.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardMetricsModel> getMetrics({
    required String clientId,
    required String userId,
    String filter = '7 days',
  });
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient _dioClient;

  DashboardRemoteDataSourceImpl(this._dioClient);

  @override
  Future<DashboardMetricsModel> getMetrics({
    required String clientId,
    required String userId,
    String filter = '7 days',
  }) async {
    final path = '/api/workspace/client/$clientId/user/$userId/metrics';
    
    final response = await _dioClient.get(
      path,
      queryParameters: {
        'config_type': 'default',
        'filter': filter,
      },
    );
    
    return DashboardMetricsModel.fromJson(response.data as Map<String, dynamic>);
  }
}