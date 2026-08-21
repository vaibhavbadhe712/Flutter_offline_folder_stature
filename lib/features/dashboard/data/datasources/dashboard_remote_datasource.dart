import '../../../../core/network/dio_client.dart';
import '../models/dashboard_metrics_model.dart';
import '../models/recent_activity_model.dart';
import 'package:injectable/injectable.dart';
import '../../presentation/providers/minutes_left_holder.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardMetricsModel> getMetrics({
    required String clientId,
    required String userId,
    String filter = '7 days',
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
    
    final data = response.data as Map<String, dynamic>;
    final minutesLeftVal = data['minutes_left'];
    if (minutesLeftVal is num) {
      MinutesLeftHolder.minutesLeft = minutesLeftVal.toDouble();
    }
    
    return DashboardMetricsModel.fromJson(data);
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
        'config_type': 'default',
      },
    );
    
    final List<dynamic> list = response.data as List<dynamic>;
    return list.map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}