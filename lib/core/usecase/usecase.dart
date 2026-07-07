import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Abstract interface for all use cases.
/// [Type] is what the use case returns on success.
/// [Params] represents parameters passed to the use case.
abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// Helper class for use cases that require no parameters.
class NoParams {
  const NoParams();
}
