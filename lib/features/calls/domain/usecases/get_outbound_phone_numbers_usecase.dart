import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/phone_number_entity.dart';
import '../repositories/calls_repository.dart';

class GetOutboundPhoneNumbersParams {
  final String clientId;
  final String userId;

  const GetOutboundPhoneNumbersParams({
    required this.clientId,
    required this.userId,
  });
}

@lazySingleton
class GetOutboundPhoneNumbersUseCase implements UseCase<List<PhoneNumberEntity>, GetOutboundPhoneNumbersParams> {
  final CallsRepository _repository;

  GetOutboundPhoneNumbersUseCase(this._repository);

  @override
  Future<Either<Failure, List<PhoneNumberEntity>>> call(GetOutboundPhoneNumbersParams params) {
    return _repository.getOutboundPhoneNumbers(
      clientId: params.clientId,
      userId: params.userId,
    );
  }
}
