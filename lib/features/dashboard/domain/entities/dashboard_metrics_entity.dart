import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_metrics_entity.freezed.dart';

@freezed
class DashboardMetricsEntity with _$DashboardMetricsEntity {
  const factory DashboardMetricsEntity({
    required int totalCalls,
    required double totalMinutes,
    required double totalSpend,
    required double totalSpendUsd,
    required double totalSpendLocal,
    required String currency,
    required double exchangeRate,
    required int activeAssistants,
  }) = _DashboardMetricsEntity;
}