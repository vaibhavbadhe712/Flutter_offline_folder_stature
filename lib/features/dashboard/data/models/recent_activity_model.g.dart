// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecentActivityModelImpl _$$RecentActivityModelImplFromJson(
  Map<String, dynamic> json,
) => _$RecentActivityModelImpl(
  id: (json['id'] as num).toInt(),
  assistantName: json['assistant_name'] as String?,
  contactInfo: json['contact_info'] as String?,
  fromNumber: json['from_number'] as String?,
  toNumber: json['to_number'] as String?,
  duration: json['duration'] as String?,
  status: json['status'] as String?,
  dateTime: json['date_time'] as String?,
  cost: json['cost'] as num?,
  costUsd: json['cost_usd'] as num?,
  costLocal: json['cost_local'] as num?,
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$$RecentActivityModelImplToJson(
  _$RecentActivityModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'assistant_name': instance.assistantName,
  'contact_info': instance.contactInfo,
  'from_number': instance.fromNumber,
  'to_number': instance.toNumber,
  'duration': instance.duration,
  'status': instance.status,
  'date_time': instance.dateTime,
  'cost': instance.cost,
  'cost_usd': instance.costUsd,
  'cost_local': instance.costLocal,
  'currency': instance.currency,
};
