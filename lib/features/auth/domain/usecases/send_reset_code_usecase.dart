import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SendResetCodeUseCase implements UseCase<void, String> {
  final AuthRepository _repository;

  SendResetCodeUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String email) {
    return _repository.sendPasswordResetCode(email);
  }
}
