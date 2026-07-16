import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_metrics_entity.dart';
import '../entities/recent_activity_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardMetricsEntity>> getMetrics({
    required String clientId,
    required String userId,
  });

  Future<Either<Failure, List<RecentActivityEntity>>> getRecentActivity({
    required String clientId,
    required String userId,
  });
}
