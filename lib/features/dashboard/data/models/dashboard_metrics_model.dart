// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_metrics_entity.dart';

part 'dashboard_metrics_model.freezed.dart';
part 'dashboard_metrics_model.g.dart';

@freezed
class DashboardMetricsModel with _$DashboardMetricsModel {
  const factory DashboardMetricsModel({
    @JsonKey(name: 'total_calls') required int totalCalls,
    @JsonKey(name: 'total_minutes') required num totalMinutes,
    @JsonKey(name: 'total_spend') required num totalSpend,
    @JsonKey(name: 'total_spend_usd') required num totalSpendUsd,
    @JsonKey(name: 'total_spend_local') required num totalSpendLocal,
    required String currency,
    @JsonKey(name: 'exchange_rate') required num exchangeRate,
    @JsonKey(name: 'active_assistants') required int activeAssistants,
  }) = _DashboardMetricsModel;

  factory DashboardMetricsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardMetricsModelFromJson(json);

  const DashboardMetricsModel._();

  DashboardMetricsEntity toEntity() {
    return DashboardMetricsEntity(
      totalCalls: totalCalls,
      totalMinutes: totalMinutes.toDouble(),
      totalSpend: totalSpend.toDouble(),
      totalSpendUsd: totalSpendUsd.toDouble(),
      totalSpendLocal: totalSpendLocal.toDouble(),
      currency: currency,
      exchangeRate: exchangeRate.toDouble(),
      activeAssistants: activeAssistants,
    );
  }
}
