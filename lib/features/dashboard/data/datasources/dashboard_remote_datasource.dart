import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_metrics_model.dart';
import '../models/recent_activity_model.dart';
import 'package:injectable/injectable.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardMetricsModel> getMetrics({
    required String clientId,
    required String userId,
  });

  Future<List<RecentActivityModel>> getRecentActivity({
    required String clientId,
    required String userId,
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
  }) async {
    final path = '/api/workspace/client/$clientId/user/$userId/metrics';
    
    final response = await _dioClient.get(
      path,
      queryParameters: {
        'config_type': 'default',
      },
    );
    
    return DashboardMetricsModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivity({
    required String clientId,
    required String userId,
  }) async {
    final path = '/api/workspace/client/$clientId/user/$userId/recent-activity';
    
    final response = await _dioClient.get(
      path,
      queryParameters: {
        'config_type': 'custom',
      },
    );
    
    final List<dynamic> list = response.data as List<dynamic>;
    return list.map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}