import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/dashboard_metrics_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardMetricsParams {
  final String clientId;
  final String userId;
  final String filter;

  const GetDashboardMetricsParams({
    required this.clientId,
    required this.userId,
    this.filter = '7 days',
  });
}

@lazySingleton
class GetDashboardMetricsUseCase implements UseCase<DashboardMetricsEntity, GetDashboardMetricsParams> {
  final DashboardRepository _repository;

  GetDashboardMetricsUseCase(this._repository);

  @override
  Future<Either<Failure, DashboardMetricsEntity>> call(GetDashboardMetricsParams params) {
    return _repository.getMetrics(
      clientId: params.clientId,
      userId: params.userId,
      filter: params.filter,
    );
  }
}
