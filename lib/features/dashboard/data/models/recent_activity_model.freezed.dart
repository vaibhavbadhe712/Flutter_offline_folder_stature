// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecentActivityModel _$RecentActivityModelFromJson(Map<String, dynamic> json) {
  return _RecentActivityModel.fromJson(json);
}

/// @nodoc
mixin _$RecentActivityModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'assistant_name')
  String? get assistantName => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_info')
  String? get contactInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_number')
  String? get fromNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_number')
  String? get toNumber => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_time')
  String? get dateTime => throw _privateConstructorUsedError;
  num? get cost => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_usd')
  num? get costUsd => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_local')
  num? get costLocal => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  /// Serializes this RecentActivityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentActivityModelCopyWith<RecentActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentActivityModelCopyWith<$Res> {
  factory $RecentActivityModelCopyWith(
    RecentActivityModel value,
    $Res Function(RecentActivityModel) then,
  ) = _$RecentActivityModelCopyWithImpl<$Res, RecentActivityModel>;
  @useResult
  $Res call({
    int id,
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
  });
}

/// @nodoc
class _$RecentActivityModelCopyWithImpl<$Res, $Val extends RecentActivityModel>
    implements $RecentActivityModelCopyWith<$Res> {
  _$RecentActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assistantName = freezed,
    Object? contactInfo = freezed,
    Object? fromNumber = freezed,
    Object? toNumber = freezed,
    Object? duration = freezed,
    Object? status = freezed,
    Object? dateTime = freezed,
    Object? cost = freezed,
    Object? costUsd = freezed,
    Object? costLocal = freezed,
    Object? currency = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            assistantName: freezed == assistantName
                ? _value.assistantName
                : assistantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactInfo: freezed == contactInfo
                ? _value.contactInfo
                : contactInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            fromNumber: freezed == fromNumber
                ? _value.fromNumber
                : fromNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            toNumber: freezed == toNumber
                ? _value.toNumber
                : toNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateTime: freezed == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            cost: freezed == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as num?,
            costUsd: freezed == costUsd
                ? _value.costUsd
                : costUsd // ignore: cast_nullable_to_non_nullable
                      as num?,
            costLocal: freezed == costLocal
                ? _value.costLocal
                : costLocal // ignore: cast_nullable_to_non_nullable
                      as num?,
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentActivityModelImplCopyWith<$Res>
    implements $RecentActivityModelCopyWith<$Res> {
  factory _$$RecentActivityModelImplCopyWith(
    _$RecentActivityModelImpl value,
    $Res Function(_$RecentActivityModelImpl) then,
  ) = __$$RecentActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
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
  });
}

/// @nodoc
class __$$RecentActivityModelImplCopyWithImpl<$Res>
    extends _$RecentActivityModelCopyWithImpl<$Res, _$RecentActivityModelImpl>
    implements _$$RecentActivityModelImplCopyWith<$Res> {
  __$$RecentActivityModelImplCopyWithImpl(
    _$RecentActivityModelImpl _value,
    $Res Function(_$RecentActivityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assistantName = freezed,
    Object? contactInfo = freezed,
    Object? fromNumber = freezed,
    Object? toNumber = freezed,
    Object? duration = freezed,
    Object? status = freezed,
    Object? dateTime = freezed,
    Object? cost = freezed,
    Object? costUsd = freezed,
    Object? costLocal = freezed,
    Object? currency = freezed,
  }) {
    return _then(
      _$RecentActivityModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        assistantName: freezed == assistantName
            ? _value.assistantName
            : assistantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactInfo: freezed == contactInfo
            ? _value.contactInfo
            : contactInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        fromNumber: freezed == fromNumber
            ? _value.fromNumber
            : fromNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        toNumber: freezed == toNumber
            ? _value.toNumber
            : toNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateTime: freezed == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        cost: freezed == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as num?,
        costUsd: freezed == costUsd
            ? _value.costUsd
            : costUsd // ignore: cast_nullable_to_non_nullable
                  as num?,
        costLocal: freezed == costLocal
            ? _value.costLocal
            : costLocal // ignore: cast_nullable_to_non_nullable
                  as num?,
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentActivityModelImpl extends _RecentActivityModel {
  const _$RecentActivityModelImpl({
    required this.id,
    @JsonKey(name: 'assistant_name') this.assistantName,
    @JsonKey(name: 'contact_info') this.contactInfo,
    @JsonKey(name: 'from_number') this.fromNumber,
    @JsonKey(name: 'to_number') this.toNumber,
    this.duration,
    this.status,
    @JsonKey(name: 'date_time') this.dateTime,
    this.cost,
    @JsonKey(name: 'cost_usd') this.costUsd,
    @JsonKey(name: 'cost_local') this.costLocal,
    this.currency,
  }) : super._();

  factory _$RecentActivityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentActivityModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'assistant_name')
  final String? assistantName;
  @override
  @JsonKey(name: 'contact_info')
  final String? contactInfo;
  @override
  @JsonKey(name: 'from_number')
  final String? fromNumber;
  @override
  @JsonKey(name: 'to_number')
  final String? toNumber;
  @override
  final String? duration;
  @override
  final String? status;
  @override
  @JsonKey(name: 'date_time')
  final String? dateTime;
  @override
  final num? cost;
  @override
  @JsonKey(name: 'cost_usd')
  final num? costUsd;
  @override
  @JsonKey(name: 'cost_local')
  final num? costLocal;
  @override
  final String? currency;

  @override
  String toString() {
    return 'RecentActivityModel(id: $id, assistantName: $assistantName, contactInfo: $contactInfo, fromNumber: $fromNumber, toNumber: $toNumber, duration: $duration, status: $status, dateTime: $dateTime, cost: $cost, costUsd: $costUsd, costLocal: $costLocal, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentActivityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assistantName, assistantName) ||
                other.assistantName == assistantName) &&
            (identical(other.contactInfo, contactInfo) ||
                other.contactInfo == contactInfo) &&
            (identical(other.fromNumber, fromNumber) ||
                other.fromNumber == fromNumber) &&
            (identical(other.toNumber, toNumber) ||
                other.toNumber == toNumber) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.costUsd, costUsd) || other.costUsd == costUsd) &&
            (identical(other.costLocal, costLocal) ||
                other.costLocal == costLocal) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    assistantName,
    contactInfo,
    fromNumber,
    toNumber,
    duration,
    status,
    dateTime,
    cost,
    costUsd,
    costLocal,
    currency,
  );

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentActivityModelImplCopyWith<_$RecentActivityModelImpl> get copyWith =>
      __$$RecentActivityModelImplCopyWithImpl<_$RecentActivityModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentActivityModelImplToJson(this);
  }
}

abstract class _RecentActivityModel extends RecentActivityModel {
  const factory _RecentActivityModel({
    required final int id,
    @JsonKey(name: 'assistant_name') final String? assistantName,
    @JsonKey(name: 'contact_info') final String? contactInfo,
    @JsonKey(name: 'from_number') final String? fromNumber,
    @JsonKey(name: 'to_number') final String? toNumber,
    final String? duration,
    final String? status,
    @JsonKey(name: 'date_time') final String? dateTime,
    final num? cost,
    @JsonKey(name: 'cost_usd') final num? costUsd,
    @JsonKey(name: 'cost_local') final num? costLocal,
    final String? currency,
  }) = _$RecentActivityModelImpl;
  const _RecentActivityModel._() : super._();

  factory _RecentActivityModel.fromJson(Map<String, dynamic> json) =
      _$RecentActivityModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'assistant_name')
  String? get assistantName;
  @override
  @JsonKey(name: 'contact_info')
  String? get contactInfo;
  @override
  @JsonKey(name: 'from_number')
  String? get fromNumber;
  @override
  @JsonKey(name: 'to_number')
  String? get toNumber;
  @override
  String? get duration;
  @override
  String? get status;
  @override
  @JsonKey(name: 'date_time')
  String? get dateTime;
  @override
  num? get cost;
  @override
  @JsonKey(name: 'cost_usd')
  num? get costUsd;
  @override
  @JsonKey(name: 'cost_local')
  num? get costLocal;
  @override
  String? get currency;

  /// Create a copy of RecentActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentActivityModelImplCopyWith<_$RecentActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
