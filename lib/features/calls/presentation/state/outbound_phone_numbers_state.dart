import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/phone_number_entity.dart';

part 'outbound_phone_numbers_state.freezed.dart';

@freezed
class OutboundPhoneNumbersState with _$OutboundPhoneNumbersState {
  const factory OutboundPhoneNumbersState.initial() = _Initial;
  const factory OutboundPhoneNumbersState.loading() = _Loading;
  const factory OutboundPhoneNumbersState.loaded(List<PhoneNumberEntity> phoneNumbers) = _Loaded;
  const factory OutboundPhoneNumbersState.error(String message) = _Error;
}
