import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/calls_repository.dart';

class StartTestCallParams {
  final String clientId;
  final String userId;
  final int assistantId;
  final String toNumber;
  final int phoneNumberId;
  final int contactId;

  const StartTestCallParams({
    required this.clientId,
    required this.userId,
    required this.assistantId,
    required this.toNumber,
    required this.phoneNumberId,
    required this.contactId,
  });
}

@lazySingleton
class StartTestCallUseCase implements UseCase<String, StartTestCallParams> {
  final CallsRepository _repository;

  StartTestCallUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(StartTestCallParams params) {
    return _repository.startTestCall(
      clientId: params.clientId,
      userId: params.userId,
      assistantId: params.assistantId,
      toNumber: params.toNumber,
      phoneNumberId: params.phoneNumberId,
      contactId: params.contactId,
    );
  }
}
