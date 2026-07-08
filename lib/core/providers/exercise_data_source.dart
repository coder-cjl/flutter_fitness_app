import 'dart:convert';
import 'package:fitness_app/models/exercise_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseDataSourceProvider = Provider<ExerciseDataSource>((ref) {
  return const ExerciseDataSource();
});

final exercisesProvider = FutureProvider<List<ExerciseModel>>((ref) async {
  final dataSource = ref.watch(exerciseDataSourceProvider);
  return dataSource.loadExercises();
});

class ExerciseDataSource {
  const ExerciseDataSource();

  static const String _assetPath = 'assets/jsons/exercises.json';

  Future<List<ExerciseModel>> loadExercises() async {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      return const <ExerciseModel>[];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ExerciseModel.fromJson)
        .toList(growable: false);
  }
}
