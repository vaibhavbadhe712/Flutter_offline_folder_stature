import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/phone_number_entity.dart';
import '../../domain/entities/assistant_entity.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/calls_repository.dart';
import '../datasources/calls_remote_datasource.dart';

@LazySingleton(as: CallsRepository)
class CallsRepositoryImpl implements CallsRepository {
  final CallsRemoteDataSource _remoteDataSource;

  CallsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PhoneNumberEntity>>> getOutboundPhoneNumbers({
    required String clientId,
    required String userId,
  }) async {
    try {
      final models = await _remoteDataSource.getOutboundPhoneNumbers(
        clientId: clientId,
        userId: userId,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during loading outbound phone numbers: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AssistantEntity>>> getAssistants({
    required String clientId,
    required String userId,
  }) async {
    try {
      final models = await _remoteDataSource.getAssistants(
        clientId: clientId,
        userId: userId,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during loading assistants: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> getContacts({
    required String clientId,
    required String userId,
  }) async {
    try {
      final models = await _remoteDataSource.getContacts(
        clientId: clientId,
        userId: userId,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during loading contacts: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> startTestCall({
    required String clientId,
    required String userId,
    required int assistantId,
    required String toNumber,
    required int phoneNumberId,
    required int contactId,
  }) async {
    try {
      final message = await _remoteDataSource.startTestCall(
        clientId: clientId,
        userId: userId,
        assistantId: assistantId,
        toNumber: toNumber,
        phoneNumberId: phoneNumberId,
        contactId: contactId,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errorData: e.errorData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An error occurred during starting test call: $e'));
    }
  }
}
