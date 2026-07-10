import 'package:fitness_app/exercises/data/exercise_data_source_provider.dart';
import 'package:fitness_app/exercises/models/exercise_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 按 id 读取动作详情，避免详情页依赖一次性的全局选中状态。
final exerciseByIdProvider = Provider.autoDispose
    .family<AsyncValue<ExerciseModel?>, String>((ref, exerciseId) {
      final exercisesAsync = ref.watch(exercisesProvider);
      return exercisesAsync.whenData((exercises) {
        for (final exercise in exercises) {
          if (exercise.id == exerciseId) return exercise;
        }
        return null;
      });
    });
