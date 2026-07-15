// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/assistant_entity.dart';

part 'assistant_model.freezed.dart';
part 'assistant_model.g.dart';

@freezed
class AssistantModel with _$AssistantModel {
  const factory AssistantModel({
    required int id,
    @JsonKey(name: 'public_id') required String publicId,
    required String name,
    required String status,
    @JsonKey(name: 'llm_model') required String llmModel,
    @JsonKey(name: 'llm_provider') required String llmProvider,
    @JsonKey(name: 'voice_provider') required String voiceProvider,
    @JsonKey(name: 'inbound_enabled') required bool inboundEnabled,
    @JsonKey(name: 'inbound_phone_number_id') int? inboundPhoneNumberId,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _AssistantModel;

  factory AssistantModel.fromJson(Map<String, dynamic> json) =>
      _$AssistantModelFromJson(json);

  const AssistantModel._();

  AssistantEntity toEntity() {
    return AssistantEntity(
      id: id,
      publicId: publicId,
      name: name,
      status: status,
      llmModel: llmModel,
      llmProvider: llmProvider,
      voiceProvider: voiceProvider,
      inboundEnabled: inboundEnabled,
      inboundPhoneNumberId: inboundPhoneNumberId,
      createdAt: createdAt,
    );
  }
}
