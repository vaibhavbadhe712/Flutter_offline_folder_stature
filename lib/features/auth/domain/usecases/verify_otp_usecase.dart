import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class VerifyOtpUseCase implements UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(params.phoneNumber, params.otp);
  }
}

class VerifyOtpParams {
  final String phoneNumber;
  final String otp;

  const VerifyOtpParams({required this.phoneNumber, required this.otp});
}
