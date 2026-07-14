// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_number_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PhoneNumberEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String get accountSid => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of PhoneNumberEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhoneNumberEntityCopyWith<PhoneNumberEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneNumberEntityCopyWith<$Res> {
  factory $PhoneNumberEntityCopyWith(
    PhoneNumberEntity value,
    $Res Function(PhoneNumberEntity) then,
  ) = _$PhoneNumberEntityCopyWithImpl<$Res, PhoneNumberEntity>;
  @useResult
  $Res call({
    int id,
    String name,
    String phoneNumber,
    String provider,
    String accountSid,
    String createdAt,
  });
}

/// @nodoc
class _$PhoneNumberEntityCopyWithImpl<$Res, $Val extends PhoneNumberEntity>
    implements $PhoneNumberEntityCopyWith<$Res> {
  _$PhoneNumberEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhoneNumberEntity
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
abstract class _$$PhoneNumberEntityImplCopyWith<$Res>
    implements $PhoneNumberEntityCopyWith<$Res> {
  factory _$$PhoneNumberEntityImplCopyWith(
    _$PhoneNumberEntityImpl value,
    $Res Function(_$PhoneNumberEntityImpl) then,
  ) = __$$PhoneNumberEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String phoneNumber,
    String provider,
    String accountSid,
    String createdAt,
  });
}

/// @nodoc
class __$$PhoneNumberEntityImplCopyWithImpl<$Res>
    extends _$PhoneNumberEntityCopyWithImpl<$Res, _$PhoneNumberEntityImpl>
    implements _$$PhoneNumberEntityImplCopyWith<$Res> {
  __$$PhoneNumberEntityImplCopyWithImpl(
    _$PhoneNumberEntityImpl _value,
    $Res Function(_$PhoneNumberEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhoneNumberEntity
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
      _$PhoneNumberEntityImpl(
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

class _$PhoneNumberEntityImpl implements _PhoneNumberEntity {
  const _$PhoneNumberEntityImpl({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.provider,
    required this.accountSid,
    required this.createdAt,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final String phoneNumber;
  @override
  final String provider;
  @override
  final String accountSid;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'PhoneNumberEntity(id: $id, name: $name, phoneNumber: $phoneNumber, provider: $provider, accountSid: $accountSid, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneNumberEntityImpl &&
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

  /// Create a copy of PhoneNumberEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneNumberEntityImplCopyWith<_$PhoneNumberEntityImpl> get copyWith =>
      __$$PhoneNumberEntityImplCopyWithImpl<_$PhoneNumberEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _PhoneNumberEntity implements PhoneNumberEntity {
  const factory _PhoneNumberEntity({
    required final int id,
    required final String name,
    required final String phoneNumber,
    required final String provider,
    required final String accountSid,
    required final String createdAt,
  }) = _$PhoneNumberEntityImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String get phoneNumber;
  @override
  String get provider;
  @override
  String get accountSid;
  @override
  String get createdAt;

  /// Create a copy of PhoneNumberEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneNumberEntityImplCopyWith<_$PhoneNumberEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
