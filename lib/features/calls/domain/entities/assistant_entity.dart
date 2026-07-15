import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_entity.freezed.dart';

@freezed
class AssistantEntity with _$AssistantEntity {
  const factory AssistantEntity({
    required int id,
    required String publicId,
    required String name,
    required String status,
    required String llmModel,
    required String llmProvider,
    required String voiceProvider,
    required bool inboundEnabled,
    int? inboundPhoneNumberId,
    required String createdAt,
  }) = _AssistantEntity;
}
