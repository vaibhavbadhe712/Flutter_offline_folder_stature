import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/assistant_entity.dart';

part 'assistants_state.freezed.dart';

@freezed
class AssistantsState with _$AssistantsState {
  const factory AssistantsState.initial() = _Initial;
  const factory AssistantsState.loading() = _Loading;
  const factory AssistantsState.loaded(List<AssistantEntity> assistants) = _Loaded;
  const factory AssistantsState.error(String message) = _Error;
}
