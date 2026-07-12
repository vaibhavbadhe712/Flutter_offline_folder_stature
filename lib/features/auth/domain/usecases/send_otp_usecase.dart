import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SendOtpUseCase implements UseCase<String, String> {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String phoneNumber) {
    return _repository.sendOtp(phoneNumber);
  }
}
