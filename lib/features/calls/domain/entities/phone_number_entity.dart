import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number_entity.freezed.dart';

@freezed
class PhoneNumberEntity with _$PhoneNumberEntity {
  const factory PhoneNumberEntity({
    required int id,
    required String name,
    required String phoneNumber,
    required String provider,
    required String accountSid,
    required String createdAt,
  }) = _PhoneNumberEntity;
}
