// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_number_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhoneNumberModel _$PhoneNumberModelFromJson(Map<String, dynamic> json) {
  return _PhoneNumberModel.fromJson(json);
}

/// @nodoc
mixin _$PhoneNumberModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String get phoneNumber => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_sid')
  String get accountSid => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PhoneNumberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhoneNumberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhoneNumberModelCopyWith<PhoneNumberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneNumberModelCopyWith<$Res> {
  factory $PhoneNumberModelCopyWith(
    PhoneNumberModel value,
    $Res Function(PhoneNumberModel) then,
  ) = _$PhoneNumberModelCopyWithImpl<$Res, PhoneNumberModel>;
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'phone_number') String phoneNumber,
    String provider,
    @JsonKey(name: 'account_sid') String accountSid,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$PhoneNumberModelCopyWithImpl<$Res, $Val extends PhoneNumberModel>
    implements $PhoneNumberModelCopyWith<$Res> {
  _$PhoneNumberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhoneNumberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? provider = null,
    Object? accountSid = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as String,
            accountSid: null == accountSid
                ? _value.accountSid
                : accountSid // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhoneNumberModelImplCopyWith<$Res>
    implements $PhoneNumberModelCopyWith<$Res> {
  factory _$$PhoneNumberModelImplCopyWith(
    _$PhoneNumberModelImpl value,
    $Res Function(_$PhoneNumberModelImpl) then,
  ) = __$$PhoneNumberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(name: 'phone_number') String phoneNumber,
    String provider,
    @JsonKey(name: 'account_sid') String accountSid,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$PhoneNumberModelImplCopyWithImpl<$Res>
    extends _$PhoneNumberModelCopyWithImpl<$Res, _$PhoneNumberModelImpl>
    implements _$$PhoneNumberModelImplCopyWith<$Res> {
  __$$PhoneNumberModelImplCopyWithImpl(
    _$PhoneNumberModelImpl _value,
    $Res Function(_$PhoneNumberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhoneNumberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? provider = null,
    Object? accountSid = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$PhoneNumberModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
        accountSid: null == accountSid
            ? _value.accountSid
            : accountSid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhoneNumberModelImpl extends _PhoneNumberModel {
  const _$PhoneNumberModelImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'phone_number') required this.phoneNumber,
    required this.provider,
    @JsonKey(name: 'account_sid') required this.accountSid,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : super._();

  factory _$PhoneNumberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneNumberModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @override
  final String provider;
  @override
  @JsonKey(name: 'account_sid')
  final String accountSid;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'PhoneNumberModel(id: $id, name: $name, phoneNumber: $phoneNumber, provider: $provider, accountSid: $accountSid, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneNumberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.accountSid, accountSid) ||
                other.accountSid == accountSid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    phoneNumber,
    provider,
    accountSid,
    createdAt,
  );

  /// Create a copy of PhoneNumberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneNumberModelImplCopyWith<_$PhoneNumberModelImpl> get copyWith =>
      __$$PhoneNumberModelImplCopyWithImpl<_$PhoneNumberModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneNumberModelImplToJson(this);
  }
}

abstract class _PhoneNumberModel extends PhoneNumberModel {
  const factory _PhoneNumberModel({
    required final int id,
    required final String name,
    @JsonKey(name: 'phone_number') required final String phoneNumber,
    required final String provider,
    @JsonKey(name: 'account_sid') required final String accountSid,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$PhoneNumberModelImpl;
  const _PhoneNumberModel._() : super._();

  factory _PhoneNumberModel.fromJson(Map<String, dynamic> json) =
      _$PhoneNumberModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'phone_number')
  String get phoneNumber;
  @override
  String get provider;
  @override
  @JsonKey(name: 'account_sid')
  String get accountSid;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of PhoneNumberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneNumberModelImplCopyWith<_$PhoneNumberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
