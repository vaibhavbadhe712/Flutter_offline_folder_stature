// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_metrics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardMetricsModel _$DashboardMetricsModelFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardMetricsModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardMetricsModel {
  @JsonKey(name: 'total_calls')
  int get totalCalls => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_minutes')
  num get totalMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spend')
  num get totalSpend => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spend_usd')
  num get totalSpendUsd => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spend_local')
  num get totalSpendLocal => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'exchange_rate')
  num get exchangeRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_assistants')
  int get activeAssistants => throw _privateConstructorUsedError;

  /// Serializes this DashboardMetricsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardMetricsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardMetricsModelCopyWith<DashboardMetricsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardMetricsModelCopyWith<$Res> {
  factory $DashboardMetricsModelCopyWith(
    DashboardMetricsModel value,
    $Res Function(DashboardMetricsModel) then,
  ) = _$DashboardMetricsModelCopyWithImpl<$Res, DashboardMetricsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_calls') int totalCalls,
    @JsonKey(name: 'total_minutes') num totalMinutes,
    @JsonKey(name: 'total_spend') num totalSpend,
    @JsonKey(name: 'total_spend_usd') num totalSpendUsd,
    @JsonKey(name: 'total_spend_local') num totalSpendLocal,
    String currency,
    @JsonKey(name: 'exchange_rate') num exchangeRate,
    @JsonKey(name: 'active_assistants') int activeAssistants,
  });
}

/// @nodoc
class _$DashboardMetricsModelCopyWithImpl<
  $Res,
  $Val extends DashboardMetricsModel
>
    implements $DashboardMetricsModelCopyWith<$Res> {
  _$DashboardMetricsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardMetricsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCalls = null,
    Object? totalMinutes = null,
    Object? totalSpend = null,
    Object? totalSpendUsd = null,
    Object? totalSpendLocal = null,
    Object? currency = null,
    Object? exchangeRate = null,
    Object? activeAssistants = null,
  }) {
    return _then(
      _value.copyWith(
            totalCalls: null == totalCalls
                ? _value.totalCalls
                : totalCalls // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMinutes: null == totalMinutes
                ? _value.totalMinutes
                : totalMinutes // ignore: cast_nullable_to_non_nullable
                      as num,
            totalSpend: null == totalSpend
                ? _value.totalSpend
                : totalSpend // ignore: cast_nullable_to_non_nullable
                      as num,
            totalSpendUsd: null == totalSpendUsd
                ? _value.totalSpendUsd
                : totalSpendUsd // ignore: cast_nullable_to_non_nullable
                      as num,
            totalSpendLocal: null == totalSpendLocal
                ? _value.totalSpendLocal
                : totalSpendLocal // ignore: cast_nullable_to_non_nullable
                      as num,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            exchangeRate: null == exchangeRate
                ? _value.exchangeRate
                : exchangeRate // ignore: cast_nullable_to_non_nullable
                      as num,
            activeAssistants: null == activeAssistants
                ? _value.activeAssistants
                : activeAssistants // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardMetricsModelImplCopyWith<$Res>
    implements $DashboardMetricsModelCopyWith<$Res> {
  factory _$$DashboardMetricsModelImplCopyWith(
    _$DashboardMetricsModelImpl value,
    $Res Function(_$DashboardMetricsModelImpl) then,
  ) = __$$DashboardMetricsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_calls') int totalCalls,
    @JsonKey(name: 'total_minutes') num totalMinutes,
    @JsonKey(name: 'total_spend') num totalSpend,
    @JsonKey(name: 'total_spend_usd') num totalSpendUsd,
    @JsonKey(name: 'total_spend_local') num totalSpendLocal,
    String currency,
    @JsonKey(name: 'exchange_rate') num exchangeRate,
    @JsonKey(name: 'active_assistants') int activeAssistants,
  });
}

/// @nodoc
class __$$DashboardMetricsModelImplCopyWithImpl<$Res>
    extends
        _$DashboardMetricsModelCopyWithImpl<$Res, _$DashboardMetricsModelImpl>
    implements _$$DashboardMetricsModelImplCopyWith<$Res> {
  __$$DashboardMetricsModelImplCopyWithImpl(
    _$DashboardMetricsModelImpl _value,
    $Res Function(_$DashboardMetricsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardMetricsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCalls = null,
    Object? totalMinutes = null,
    Object? totalSpend = null,
    Object? totalSpendUsd = null,
    Object? totalSpendLocal = null,
    Object? currency = null,
    Object? exchangeRate = null,
    Object? activeAssistants = null,
  }) {
    return _then(
      _$DashboardMetricsModelImpl(
        totalCalls: null == totalCalls
            ? _value.totalCalls
            : totalCalls // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMinutes: null == totalMinutes
            ? _value.totalMinutes
            : totalMinutes // ignore: cast_nullable_to_non_nullable
                  as num,
        totalSpend: null == totalSpend
            ? _value.totalSpend
            : totalSpend // ignore: cast_nullable_to_non_nullable
                  as num,
        totalSpendUsd: null == totalSpendUsd
            ? _value.totalSpendUsd
            : totalSpendUsd // ignore: cast_nullable_to_non_nullable
                  as num,
        totalSpendLocal: null == totalSpendLocal
            ? _value.totalSpendLocal
            : totalSpendLocal // ignore: cast_nullable_to_non_nullable
                  as num,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        exchangeRate: null == exchangeRate
            ? _value.exchangeRate
            : exchangeRate // ignore: cast_nullable_to_non_nullable
                  as num,
        activeAssistants: null == activeAssistants
            ? _value.activeAssistants
            : activeAssistants // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardMetricsModelImpl extends _DashboardMetricsModel {
  const _$DashboardMetricsModelImpl({
    @JsonKey(name: 'total_calls') required this.totalCalls,
    @JsonKey(name: 'total_minutes') required this.totalMinutes,
    @JsonKey(name: 'total_spend') required this.totalSpend,
    @JsonKey(name: 'total_spend_usd') required this.totalSpendUsd,
    @JsonKey(name: 'total_spend_local') required this.totalSpendLocal,
    required this.currency,
    @JsonKey(name: 'exchange_rate') required this.exchangeRate,
    @JsonKey(name: 'active_assistants') required this.activeAssistants,
  }) : super._();

  factory _$DashboardMetricsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardMetricsModelImplFromJson(json);

  @override
  @JsonKey(name: 'total_calls')
  final int totalCalls;
  @override
  @JsonKey(name: 'total_minutes')
  final num totalMinutes;
  @override
  @JsonKey(name: 'total_spend')
  final num totalSpend;
  @override
  @JsonKey(name: 'total_spend_usd')
  final num totalSpendUsd;
  @override
  @JsonKey(name: 'total_spend_local')
  final num totalSpendLocal;
  @override
  final String currency;
  @override
  @JsonKey(name: 'exchange_rate')
  final num exchangeRate;
  @override
  @JsonKey(name: 'active_assistants')
  final int activeAssistants;

  @override
  String toString() {
    return 'DashboardMetricsModel(totalCalls: $totalCalls, totalMinutes: $totalMinutes, totalSpend: $totalSpend, totalSpendUsd: $totalSpendUsd, totalSpendLocal: $totalSpendLocal, currency: $currency, exchangeRate: $exchangeRate, activeAssistants: $activeAssistants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardMetricsModelImpl &&
            (identical(other.totalCalls, totalCalls) ||
                other.totalCalls == totalCalls) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.totalSpend, totalSpend) ||
                other.totalSpend == totalSpend) &&
            (identical(other.totalSpendUsd, totalSpendUsd) ||
                other.totalSpendUsd == totalSpendUsd) &&
            (identical(other.totalSpendLocal, totalSpendLocal) ||
                other.totalSpendLocal == totalSpendLocal) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.activeAssistants, activeAssistants) ||
                other.activeAssistants == activeAssistants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCalls,
    totalMinutes,
    totalSpend,
    totalSpendUsd,
    totalSpendLocal,
    currency,
    exchangeRate,
    activeAssistants,
  );

  /// Create a copy of DashboardMetricsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardMetricsModelImplCopyWith<_$DashboardMetricsModelImpl>
  get copyWith =>
      __$$DashboardMetricsModelImplCopyWithImpl<_$DashboardMetricsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardMetricsModelImplToJson(this);
  }
}

abstract class _DashboardMetricsModel extends DashboardMetricsModel {
  const factory _DashboardMetricsModel({
    @JsonKey(name: 'total_calls') required final int totalCalls,
    @JsonKey(name: 'total_minutes') required final num totalMinutes,
    @JsonKey(name: 'total_spend') required final num totalSpend,
    @JsonKey(name: 'total_spend_usd') required final num totalSpendUsd,
    @JsonKey(name: 'total_spend_local') required final num totalSpendLocal,
    required final String currency,
    @JsonKey(name: 'exchange_rate') required final num exchangeRate,
    @JsonKey(name: 'active_assistants') required final int activeAssistants,
  }) = _$DashboardMetricsModelImpl;
  const _DashboardMetricsModel._() : super._();

  factory _DashboardMetricsModel.fromJson(Map<String, dynamic> json) =
      _$DashboardMetricsModelImpl.fromJson;

  @override
  @JsonKey(name: 'total_calls')
  int get totalCalls;
  @override
  @JsonKey(name: 'total_minutes')
  num get totalMinutes;
  @override
  @JsonKey(name: 'total_spend')
  num get totalSpend;
  @override
  @JsonKey(name: 'total_spend_usd')
  num get totalSpendUsd;
  @override
  @JsonKey(name: 'total_spend_local')
  num get totalSpendLocal;
  @override
  String get currency;
  @override
  @JsonKey(name: 'exchange_rate')
  num get exchangeRate;
  @override
  @JsonKey(name: 'active_assistants')
  int get activeAssistants;

  /// Create a copy of DashboardMetricsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardMetricsModelImplCopyWith<_$DashboardMetricsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
