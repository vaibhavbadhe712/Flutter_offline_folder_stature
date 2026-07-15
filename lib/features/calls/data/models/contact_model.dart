// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/contact_entity.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
class ContactModel with _$ContactModel {
  const factory ContactModel({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    String? email,
    required String group,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  const ContactModel._();

  ContactEntity toEntity() {
    return ContactEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
      group: group,
      createdAt: createdAt,
    );
  }
}

@freezed
class ContactResponseModel with _$ContactResponseModel {
  const factory ContactResponseModel({
    required int total,
    required int skip,
    required int limit,
    required List<ContactModel> contacts,
  }) = _ContactResponseModel;

  factory ContactResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ContactResponseModelFromJson(json);
}
