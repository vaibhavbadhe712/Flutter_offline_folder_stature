// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_metrics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardMetricsModelImpl _$$DashboardMetricsModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardMetricsModelImpl(
  totalCalls: (json['total_calls'] as num).toInt(),
  totalMinutes: json['total_minutes'] as num,
  totalSpend: json['total_spend'] as num,
  totalSpendUsd: json['total_spend_usd'] as num,
  totalSpendLocal: json['total_spend_local'] as num,
  currency: json['currency'] as String,
  exchangeRate: json['exchange_rate'] as num,
  activeAssistants: (json['active_assistants'] as num).toInt(),
);

Map<String, dynamic> _$$DashboardMetricsModelImplToJson(
  _$DashboardMetricsModelImpl instance,
) => <String, dynamic>{
  'total_calls': instance.totalCalls,
  'total_minutes': instance.totalMinutes,
  'total_spend': instance.totalSpend,
  'total_spend_usd': instance.totalSpendUsd,
  'total_spend_local': instance.totalSpendLocal,
  'currency': instance.currency,
  'exchange_rate': instance.exchangeRate,
  'active_assistants': instance.activeAssistants,
};
