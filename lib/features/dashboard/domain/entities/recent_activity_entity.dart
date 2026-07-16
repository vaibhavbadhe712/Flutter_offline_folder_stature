import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_activity_entity.freezed.dart';

@freezed
class RecentActivityEntity with _$RecentActivityEntity {
  const factory RecentActivityEntity({
    required int id,
    required String assistantName,
    required String contactInfo,
    required String fromNumber,
    required String toNumber,
    required String duration,
    required String status,
    required String dateTime,
    required double cost,
    required double costUsd,
    required double costLocal,
    required String currency,
  }) = _RecentActivityEntity;
}
