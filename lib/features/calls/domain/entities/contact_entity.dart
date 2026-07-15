import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_entity.freezed.dart';

@freezed
class ContactEntity with _$ContactEntity {
  const factory ContactEntity({
    required int id,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? email,
    required String group,
    required String createdAt,
  }) = _ContactEntity;
}
