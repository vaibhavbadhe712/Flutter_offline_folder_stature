// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssistantModelImpl _$$AssistantModelImplFromJson(Map<String, dynamic> json) =>
    _$AssistantModelImpl(
      id: (json['id'] as num).toInt(),
      publicId: json['public_id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      llmModel: json['llm_model'] as String,
      llmProvider: json['llm_provider'] as String,
      voiceProvider: json['voice_provider'] as String,
      inboundEnabled: json['inbound_enabled'] as bool,
      inboundPhoneNumberId: (json['inbound_phone_number_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$AssistantModelImplToJson(
  _$AssistantModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'public_id': instance.publicId,
  'name': instance.name,
  'status': instance.status,
  'llm_model': instance.llmModel,
  'llm_provider': instance.llmProvider,
  'voice_provider': instance.voiceProvider,
  'inbound_enabled': instance.inboundEnabled,
  'inbound_phone_number_id': instance.inboundPhoneNumberId,
  'created_at': instance.createdAt,
};
