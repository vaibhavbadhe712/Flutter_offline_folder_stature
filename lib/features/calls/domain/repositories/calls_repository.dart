import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/phone_number_entity.dart';
import '../entities/assistant_entity.dart';

abstract class CallsRepository {
  Future<Either<Failure, List<PhoneNumberEntity>>> getOutboundPhoneNumbers({
    required String clientId,
    required String userId,
  });

  Future<Either<Failure, List<AssistantEntity>>> getAssistants({
    required String clientId,
    required String userId,
  });
}
