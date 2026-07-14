import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_metrics_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardMetricsEntity>> getMetrics({
    required String clientId,
    required String userId,
  });
}
