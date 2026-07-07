import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User DTO model handling JSON serialization and deserialization.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    required String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  const UserModel._();

  /// Converts this DTO to clean domain UserEntity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      role: role,
    );
  }

  /// Maps a domain UserEntity back to this UserModel.
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      role: entity.role,
    );
  }
}
