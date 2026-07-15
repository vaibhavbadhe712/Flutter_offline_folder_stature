import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/assistant_entity.dart';
import '../repositories/calls_repository.dart';

class GetAssistantsParams {
  final String clientId;
  final String userId;

  const GetAssistantsParams({
    required this.clientId,
    required this.userId,
  });
}

@lazySingleton
class GetAssistantsUseCase implements UseCase<List<AssistantEntity>, GetAssistantsParams> {
  final CallsRepository _repository;

  GetAssistantsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AssistantEntity>>> call(GetAssistantsParams params) {
    return _repository.getAssistants(
      clientId: params.clientId,
      userId: params.userId,
    );
  }
}
