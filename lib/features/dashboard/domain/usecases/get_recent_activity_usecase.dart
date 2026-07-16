import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/recent_activity_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentActivityParams {
  final String clientId;
  final String userId;

  const GetRecentActivityParams({
    required this.clientId,
    required this.userId,
  });
}

@lazySingleton
class GetRecentActivityUseCase implements UseCase<List<RecentActivityEntity>, GetRecentActivityParams> {
  final DashboardRepository _repository;

  GetRecentActivityUseCase(this._repository);

  @override
  Future<Either<Failure, List<RecentActivityEntity>>> call(GetRecentActivityParams params) {
    return _repository.getRecentActivity(
      clientId: params.clientId,
      userId: params.userId,
    );
  }
}
