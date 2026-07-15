import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/contact_entity.dart';
import '../repositories/calls_repository.dart';

class GetContactsParams {
  final String clientId;
  final String userId;

  const GetContactsParams({
    required this.clientId,
    required this.userId,
  });
}

@lazySingleton
class GetContactsUseCase implements UseCase<List<ContactEntity>, GetContactsParams> {
  final CallsRepository _repository;

  GetContactsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ContactEntity>>> call(GetContactsParams params) {
    return _repository.getContacts(
      clientId: params.clientId,
      userId: params.userId,
    );
  }
}
