// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recent_activity_entity.dart';

part 'recent_activity_model.freezed.dart';
part 'recent_activity_model.g.dart';

@freezed
class RecentActivityModel with _$RecentActivityModel {
  const factory RecentActivityModel({
    required int id,
    @JsonKey(name: 'assistant_name') String? assistantName,
    @JsonKey(name: 'contact_info') String? contactInfo,
    @JsonKey(name: 'from_number') String? fromNumber,
    @JsonKey(name: 'to_number') String? toNumber,
    String? duration,
    String? status,
    @JsonKey(name: 'date_time') String? dateTime,
    num? cost,
    @JsonKey(name: 'cost_usd') num? costUsd,
    @JsonKey(name: 'cost_local') num? costLocal,
    String? currency,
  }) = _RecentActivityModel;

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) =>
      _$RecentActivityModelFromJson(json);

  const RecentActivityModel._();

  RecentActivityEntity toEntity() {
    return RecentActivityEntity(
      id: id,
      assistantName: assistantName ?? 'AGENT',
      contactInfo: contactInfo ?? 'Unknown Contact',
      fromNumber: fromNumber ?? '',
      toNumber: toNumber ?? '',
      duration: duration ?? '',
      status: status ?? 'Completed',
      dateTime: dateTime ?? DateTime.now().toIso8601String(),
      cost: (cost ?? 0.0).toDouble(),
      costUsd: (costUsd ?? 0.0).toDouble(),
      costLocal: (costLocal ?? 0.0).toDouble(),
      currency: currency ?? 'INR',
    );
  }
}
