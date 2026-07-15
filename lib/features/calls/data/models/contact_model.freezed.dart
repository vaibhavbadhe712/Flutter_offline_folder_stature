// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) {
  return _ContactModel.fromJson(json);
}

/// @nodoc
mixin _$ContactModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get group => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ContactModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactModelCopyWith<ContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactModelCopyWith<$Res> {
  factory $ContactModelCopyWith(
    ContactModel value,
    $Res Function(ContactModel) then,
  ) = _$ContactModelCopyWithImpl<$Res, ContactModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    @JsonKey(name: 'phone_number') String phoneNumber,
    String? email,
    String group,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$ContactModelCopyWithImpl<$Res, $Val extends ContactModel>
    implements $ContactModelCopyWith<$Res> {
  _$ContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phoneNumber = null,
    Object? email = freezed,
    Object? group = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            group: null == group
                ? _value.group
                : group // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ContactModelImplCopyWith<$Res>
    implements $ContactModelCopyWith<$Res> {
  factory _$$ContactModelImplCopyWith(
    _$ContactModelImpl value,
    $Res Function(_$ContactModelImpl) then,
  ) = __$$ContactModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    @JsonKey(name: 'phone_number') String phoneNumber,
    String? email,
    String group,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$ContactModelImplCopyWithImpl<$Res>
    extends _$ContactModelCopyWithImpl<$Res, _$ContactModelImpl>
    implements _$$ContactModelImplCopyWith<$Res> {
  __$$ContactModelImplCopyWithImpl(
    _$ContactModelImpl _value,
    $Res Function(_$ContactModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phoneNumber = null,
    Object? email = freezed,
    Object? group = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ContactModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        group: null == group
            ? _value.group
            : group // ignore: cast_nullable_to_non_nullable
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
class _$ContactModelImpl extends _ContactModel {
  const _$ContactModelImpl({
    required this.id,
    @JsonKey(name: 'first_name') required this.firstName,
    @JsonKey(name: 'last_name') required this.lastName,
    @JsonKey(name: 'phone_number') required this.phoneNumber,
    this.email,
    required this.group,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : super._();

  factory _$ContactModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @override
  final String? email;
  @override
  final String group;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'ContactModel(id: $id, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, email: $email, group: $group, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    phoneNumber,
    email,
    group,
    createdAt,
  );

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactModelImplCopyWith<_$ContactModelImpl> get copyWith =>
      __$$ContactModelImplCopyWithImpl<_$ContactModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactModelImplToJson(this);
  }
}

abstract class _ContactModel extends ContactModel {
  const factory _ContactModel({
    required final int id,
    @JsonKey(name: 'first_name') required final String firstName,
    @JsonKey(name: 'last_name') required final String lastName,
    @JsonKey(name: 'phone_number') required final String phoneNumber,
    final String? email,
    required final String group,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$ContactModelImpl;
  const _ContactModel._() : super._();

  factory _ContactModel.fromJson(Map<String, dynamic> json) =
      _$ContactModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  @JsonKey(name: 'phone_number')
  String get phoneNumber;
  @override
  String? get email;
  @override
  String get group;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of ContactModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactModelImplCopyWith<_$ContactModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactResponseModel _$ContactResponseModelFromJson(Map<String, dynamic> json) {
  return _ContactResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ContactResponseModel {
  int get total => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<ContactModel> get contacts => throw _privateConstructorUsedError;

  /// Serializes this ContactResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactResponseModelCopyWith<ContactResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactResponseModelCopyWith<$Res> {
  factory $ContactResponseModelCopyWith(
    ContactResponseModel value,
    $Res Function(ContactResponseModel) then,
  ) = _$ContactResponseModelCopyWithImpl<$Res, ContactResponseModel>;
  @useResult
  $Res call({int total, int skip, int limit, List<ContactModel> contacts});
}

/// @nodoc
class _$ContactResponseModelCopyWithImpl<
  $Res,
  $Val extends ContactResponseModel
>
    implements $ContactResponseModelCopyWith<$Res> {
  _$ContactResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? contacts = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            skip: null == skip
                ? _value.skip
                : skip // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            contacts: null == contacts
                ? _value.contacts
                : contacts // ignore: cast_nullable_to_non_nullable
                      as List<ContactModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContactResponseModelImplCopyWith<$Res>
    implements $ContactResponseModelCopyWith<$Res> {
  factory _$$ContactResponseModelImplCopyWith(
    _$ContactResponseModelImpl value,
    $Res Function(_$ContactResponseModelImpl) then,
  ) = __$$ContactResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int skip, int limit, List<ContactModel> contacts});
}

/// @nodoc
class __$$ContactResponseModelImplCopyWithImpl<$Res>
    extends _$ContactResponseModelCopyWithImpl<$Res, _$ContactResponseModelImpl>
    implements _$$ContactResponseModelImplCopyWith<$Res> {
  __$$ContactResponseModelImplCopyWithImpl(
    _$ContactResponseModelImpl _value,
    $Res Function(_$ContactResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? contacts = null,
  }) {
    return _then(
      _$ContactResponseModelImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        skip: null == skip
            ? _value.skip
            : skip // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        contacts: null == contacts
            ? _value._contacts
            : contacts // ignore: cast_nullable_to_non_nullable
                  as List<ContactModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactResponseModelImpl implements _ContactResponseModel {
  const _$ContactResponseModelImpl({
    required this.total,
    required this.skip,
    required this.limit,
    required final List<ContactModel> contacts,
  }) : _contacts = contacts;

  factory _$ContactResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactResponseModelImplFromJson(json);

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;
  final List<ContactModel> _contacts;
  @override
  List<ContactModel> get contacts {
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contacts);
  }

  @override
  String toString() {
    return 'ContactResponseModel(total: $total, skip: $skip, limit: $limit, contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactResponseModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    skip,
    limit,
    const DeepCollectionEquality().hash(_contacts),
  );

  /// Create a copy of ContactResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactResponseModelImplCopyWith<_$ContactResponseModelImpl>
  get copyWith =>
      __$$ContactResponseModelImplCopyWithImpl<_$ContactResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactResponseModelImplToJson(this);
  }
}

abstract class _ContactResponseModel implements ContactResponseModel {
  const factory _ContactResponseModel({
    required final int total,
    required final int skip,
    required final int limit,
    required final List<ContactModel> contacts,
  }) = _$ContactResponseModelImpl;

  factory _ContactResponseModel.fromJson(Map<String, dynamic> json) =
      _$ContactResponseModelImpl.fromJson;

  @override
  int get total;
  @override
  int get skip;
  @override
  int get limit;
  @override
  List<ContactModel> get contacts;

  /// Create a copy of ContactResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactResponseModelImplCopyWith<_$ContactResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
