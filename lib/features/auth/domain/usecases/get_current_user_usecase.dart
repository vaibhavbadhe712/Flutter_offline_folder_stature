import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Usecase to retrieve the current active user session.
@lazySingleton
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
