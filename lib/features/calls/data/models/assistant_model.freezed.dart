// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assistant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AssistantModel _$AssistantModelFromJson(Map<String, dynamic> json) {
  return _AssistantModel.fromJson(json);
}

/// @nodoc
mixin _$AssistantModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'public_id')
  String get publicId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'llm_model')
  String get llmModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'llm_provider')
  String get llmProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'voice_provider')
  String get voiceProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'inbound_enabled')
  bool get inboundEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'inbound_phone_number_id')
  int? get inboundPhoneNumberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AssistantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssistantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssistantModelCopyWith<AssistantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssistantModelCopyWith<$Res> {
  factory $AssistantModelCopyWith(
    AssistantModel value,
    $Res Function(AssistantModel) then,
  ) = _$AssistantModelCopyWithImpl<$Res, AssistantModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'public_id') String publicId,
    String name,
    String status,
    @JsonKey(name: 'llm_model') String llmModel,
    @JsonKey(name: 'llm_provider') String llmProvider,
    @JsonKey(name: 'voice_provider') String voiceProvider,
    @JsonKey(name: 'inbound_enabled') bool inboundEnabled,
    @JsonKey(name: 'inbound_phone_number_id') int? inboundPhoneNumberId,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$AssistantModelCopyWithImpl<$Res, $Val extends AssistantModel>
    implements $AssistantModelCopyWith<$Res> {
  _$AssistantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssistantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicId = null,
    Object? name = null,
    Object? status = null,
    Object? llmModel = null,
    Object? llmProvider = null,
    Object? voiceProvider = null,
    Object? inboundEnabled = null,
    Object? inboundPhoneNumberId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            publicId: null == publicId
                ? _value.publicId
                : publicId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            llmModel: null == llmModel
                ? _value.llmModel
                : llmModel // ignore: cast_nullable_to_non_nullable
                      as String,
            llmProvider: null == llmProvider
                ? _value.llmProvider
                : llmProvider // ignore: cast_nullable_to_non_nullable
                      as String,
            voiceProvider: null == voiceProvider
                ? _value.voiceProvider
                : voiceProvider // ignore: cast_nullable_to_non_nullable
                      as String,
            inboundEnabled: null == inboundEnabled
                ? _value.inboundEnabled
                : inboundEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            inboundPhoneNumberId: freezed == inboundPhoneNumberId
                ? _value.inboundPhoneNumberId
                : inboundPhoneNumberId // ignore: cast_nullable_to_non_nullable
                      as int?,
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
abstract class _$$AssistantModelImplCopyWith<$Res>
    implements $AssistantModelCopyWith<$Res> {
  factory _$$AssistantModelImplCopyWith(
    _$AssistantModelImpl value,
    $Res Function(_$AssistantModelImpl) then,
  ) = __$$AssistantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'public_id') String publicId,
    String name,
    String status,
    @JsonKey(name: 'llm_model') String llmModel,
    @JsonKey(name: 'llm_provider') String llmProvider,
    @JsonKey(name: 'voice_provider') String voiceProvider,
    @JsonKey(name: 'inbound_enabled') bool inboundEnabled,
    @JsonKey(name: 'inbound_phone_number_id') int? inboundPhoneNumberId,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$AssistantModelImplCopyWithImpl<$Res>
    extends _$AssistantModelCopyWithImpl<$Res, _$AssistantModelImpl>
    implements _$$AssistantModelImplCopyWith<$Res> {
  __$$AssistantModelImplCopyWithImpl(
    _$AssistantModelImpl _value,
    $Res Function(_$AssistantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssistantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicId = null,
    Object? name = null,
    Object? status = null,
    Object? llmModel = null,
    Object? llmProvider = null,
    Object? voiceProvider = null,
    Object? inboundEnabled = null,
    Object? inboundPhoneNumberId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$AssistantModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        publicId: null == publicId
            ? _value.publicId
            : publicId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        llmModel: null == llmModel
            ? _value.llmModel
            : llmModel // ignore: cast_nullable_to_non_nullable
                  as String,
        llmProvider: null == llmProvider
            ? _value.llmProvider
            : llmProvider // ignore: cast_nullable_to_non_nullable
                  as String,
        voiceProvider: null == voiceProvider
            ? _value.voiceProvider
            : voiceProvider // ignore: cast_nullable_to_non_nullable
                  as String,
        inboundEnabled: null == inboundEnabled
            ? _value.inboundEnabled
            : inboundEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        inboundPhoneNumberId: freezed == inboundPhoneNumberId
            ? _value.inboundPhoneNumberId
            : inboundPhoneNumberId // ignore: cast_nullable_to_non_nullable
                  as int?,
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
class _$AssistantModelImpl extends _AssistantModel {
  const _$AssistantModelImpl({
    required this.id,
    @JsonKey(name: 'public_id') required this.publicId,
    required this.name,
    required this.status,
    @JsonKey(name: 'llm_model') required this.llmModel,
    @JsonKey(name: 'llm_provider') required this.llmProvider,
    @JsonKey(name: 'voice_provider') required this.voiceProvider,
    @JsonKey(name: 'inbound_enabled') required this.inboundEnabled,
    @JsonKey(name: 'inbound_phone_number_id') this.inboundPhoneNumberId,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : super._();

  factory _$AssistantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssistantModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'public_id')
  final String publicId;
  @override
  final String name;
  @override
  final String status;
  @override
  @JsonKey(name: 'llm_model')
  final String llmModel;
  @override
  @JsonKey(name: 'llm_provider')
  final String llmProvider;
  @override
  @JsonKey(name: 'voice_provider')
  final String voiceProvider;
  @override
  @JsonKey(name: 'inbound_enabled')
  final bool inboundEnabled;
  @override
  @JsonKey(name: 'inbound_phone_number_id')
  final int? inboundPhoneNumberId;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'AssistantModel(id: $id, publicId: $publicId, name: $name, status: $status, llmModel: $llmModel, llmProvider: $llmProvider, voiceProvider: $voiceProvider, inboundEnabled: $inboundEnabled, inboundPhoneNumberId: $inboundPhoneNumberId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssistantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.llmModel, llmModel) ||
                other.llmModel == llmModel) &&
            (identical(other.llmProvider, llmProvider) ||
                other.llmProvider == llmProvider) &&
            (identical(other.voiceProvider, voiceProvider) ||
                other.voiceProvider == voiceProvider) &&
            (identical(other.inboundEnabled, inboundEnabled) ||
                other.inboundEnabled == inboundEnabled) &&
            (identical(other.inboundPhoneNumberId, inboundPhoneNumberId) ||
                other.inboundPhoneNumberId == inboundPhoneNumberId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    publicId,
    name,
    status,
    llmModel,
    llmProvider,
    voiceProvider,
    inboundEnabled,
    inboundPhoneNumberId,
    createdAt,
  );

  /// Create a copy of AssistantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssistantModelImplCopyWith<_$AssistantModelImpl> get copyWith =>
      __$$AssistantModelImplCopyWithImpl<_$AssistantModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssistantModelImplToJson(this);
  }
}

abstract class _AssistantModel extends AssistantModel {
  const factory _AssistantModel({
    required final int id,
    @JsonKey(name: 'public_id') required final String publicId,
    required final String name,
    required final String status,
    @JsonKey(name: 'llm_model') required final String llmModel,
    @JsonKey(name: 'llm_provider') required final String llmProvider,
    @JsonKey(name: 'voice_provider') required final String voiceProvider,
    @JsonKey(name: 'inbound_enabled') required final bool inboundEnabled,
    @JsonKey(name: 'inbound_phone_number_id') final int? inboundPhoneNumberId,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$AssistantModelImpl;
  const _AssistantModel._() : super._();

  factory _AssistantModel.fromJson(Map<String, dynamic> json) =
      _$AssistantModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'public_id')
  String get publicId;
  @override
  String get name;
  @override
  String get status;
  @override
  @JsonKey(name: 'llm_model')
  String get llmModel;
  @override
  @JsonKey(name: 'llm_provider')
  String get llmProvider;
  @override
  @JsonKey(name: 'voice_provider')
  String get voiceProvider;
  @override
  @JsonKey(name: 'inbound_enabled')
  bool get inboundEnabled;
  @override
  @JsonKey(name: 'inbound_phone_number_id')
  int? get inboundPhoneNumberId;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of AssistantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssistantModelImplCopyWith<_$AssistantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
