import 'package:flutter_test/flutter_test.dart';
import 'package:enterprise_app/features/auth/data/models/user_model.dart';
import 'package:enterprise_app/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserModel Serialization & Domain Mapping Tests', () {
    const rawJson = {
      'id': 'EMP-4001',
      'email': 'admin@enterprise.com',
      'name': 'Sarah Connor',
      'role': 'ADMIN',
    };

    test('should parse from JSON to UserModel correctly', () {
      final model = UserModel.fromJson(rawJson);

      expect(model.id, 'EMP-4001');
      expect(model.email, 'admin@enterprise.com');
      expect(model.name, 'Sarah Connor');
      expect(model.role, 'ADMIN');
    });

    test('should map to domain UserEntity correctly', () {
      final model = UserModel.fromJson(rawJson);
      final entity = model.toEntity();

      expect(entity, isA<UserEntity>());
      expect(entity.id, model.id);
      expect(entity.email, model.email);
      expect(entity.name, model.name);
      expect(entity.role, model.role);
    });

    test('should serialize to JSON map correctly', () {
      const model = UserModel(
        id: 'EMP-4001',
        email: 'admin@enterprise.com',
        name: 'Sarah Connor',
        role: 'ADMIN',
      );

      final jsonMap = model.toJson();

      expect(jsonMap['id'], 'EMP-4001');
      expect(jsonMap['email'], 'admin@enterprise.com');
      expect(jsonMap['name'], 'Sarah Connor');
      expect(jsonMap['role'], 'ADMIN');
    });
  });
}
