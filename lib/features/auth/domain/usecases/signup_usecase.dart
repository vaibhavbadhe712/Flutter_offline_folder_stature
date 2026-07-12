import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Usecase to handle signup operations.
@lazySingleton
class SignupUseCase implements UseCase<void, SignupParams> {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SignupParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
    );
  }
}

class SignupParams {
  final String email;
  final String password;
  final String name;
  final String phone;

  const SignupParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}
