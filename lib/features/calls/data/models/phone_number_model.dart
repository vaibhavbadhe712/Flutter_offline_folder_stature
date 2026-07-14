// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/phone_number_entity.dart';

part 'phone_number_model.freezed.dart';
part 'phone_number_model.g.dart';

@freezed
class PhoneNumberModel with _$PhoneNumberModel {
  const factory PhoneNumberModel({
    required int id,
    required String name,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    required String provider,
    @JsonKey(name: 'account_sid') required String accountSid,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _PhoneNumberModel;

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberModelFromJson(json);

  const PhoneNumberModel._();

  PhoneNumberEntity toEntity() {
    return PhoneNumberEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      provider: provider,
      accountSid: accountSid,
      createdAt: createdAt,
    );
  }
}
