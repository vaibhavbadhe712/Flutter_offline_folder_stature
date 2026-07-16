import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/dashboard_metrics_entity.dart';
import '../../domain/entities/recent_activity_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DashboardMetricsEntity>> getMetrics({
    required String clientId,
    required String userId,
    String filter = '7 days',
  }) async {
    try {
      final model = await _remoteDataSource.getMetrics(
        clientId: clientId,
        userId: userId,
        filter: filter,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during loading metrics: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RecentActivityEntity>>> getRecentActivity({
    required String clientId,
    required String userId,
  }) async {
    try {
      final models = await _remoteDataSource.getRecentActivity(
        clientId: clientId,
        userId: userId,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during loading activities: $e'));
    }
  }
}