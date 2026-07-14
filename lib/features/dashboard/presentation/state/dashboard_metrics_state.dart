import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_metrics_entity.dart';

part 'dashboard_metrics_state.freezed.dart';

@freezed
class DashboardMetricsState with _$DashboardMetricsState {
  const factory DashboardMetricsState.initial() = _Initial;
  const factory DashboardMetricsState.loading() = _Loading;
  const factory DashboardMetricsState.loaded(DashboardMetricsEntity metrics) = _Loaded;
  const factory DashboardMetricsState.error(String message) = _Error;
}