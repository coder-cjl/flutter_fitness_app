import 'package:fitness_app/data/models/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseModel', () {
    test('parses json and resolves locale-specific text', () {
      final model = ExerciseModel.fromJson({
        'id': '0001',
        'name': '3/4 sit-up',
        'category': 'waist',
        'body_part': 'waist',
        'equipment': 'body weight',
        'instructions': {'en': 'English instruction', 'zh': '中文说明'},
        'instruction_steps': {
          'en': ['step 1', 'step 2'],
          'zh': ['步骤1', '步骤2'],
        },
        'muscle_group': 'hip flexors',
        'secondary_muscles': ['hip flexors', 'lower back'],
        'target': 'abs',
        'image': null,
        'gif_url': null,
        'media_id': '2gPfomN',
        'created_at': '2026-03-18T12:31:32.854798+00:00',
      });

      expect(model.id, '0001');
      expect(model.secondaryMuscles.length, 2);
      expect(model.instruction(const Locale('zh', 'CN')), '中文说明');
      expect(
        model.steps(const Locale('zh', 'CN')),
        equals(<String>['步骤1', '步骤2']),
      );
      expect(
        model.instruction(const Locale('en', 'US')),
        'English instruction',
      );
    });

    test('falls back to english when locale not present', () {
      final model = ExerciseModel.fromJson({
        'id': 'fallback',
        'name': 'fallback-name',
        'category': 'cat',
        'body_part': 'part',
        'equipment': 'eq',
        'instructions': {'en': 'English instruction'},
        'instruction_steps': {
          'en': ['s1'],
        },
        'muscle_group': 'mg',
        'secondary_muscles': [],
        'target': 'target',
        'media_id': 'm1',
      });

      expect(
        model.instruction(const Locale('fr', 'FR')),
        'English instruction',
      );
      expect(model.steps(const Locale('fr', 'FR')), equals(<String>['s1']));
    });
  });
}
