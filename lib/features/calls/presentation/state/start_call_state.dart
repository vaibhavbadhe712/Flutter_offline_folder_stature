import 'package:freezed_annotation/freezed_annotation.dart';

part 'start_call_state.freezed.dart';

@freezed
class StartCallState with _$StartCallState {
  const factory StartCallState.initial() = _Initial;
  const factory StartCallState.loading() = _Loading;
  const factory StartCallState.success(String message) = _Success;
  const factory StartCallState.error(String message) = _Error;
}
