// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_number_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhoneNumberModelImpl _$$PhoneNumberModelImplFromJson(
  Map<String, dynamic> json,
) => _$PhoneNumberModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phoneNumber: json['phone_number'] as String,
  provider: json['provider'] as String,
  accountSid: json['account_sid'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$PhoneNumberModelImplToJson(
  _$PhoneNumberModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone_number': instance.phoneNumber,
  'provider': instance.provider,
  'account_sid': instance.accountSid,
  'created_at': instance.createdAt,
};
