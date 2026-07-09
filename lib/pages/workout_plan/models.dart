import 'dart:convert';
import 'package:fitness_app/exercises/models/exercise_model.dart';

/// 单个动作项：包含练习和组数/次数配置
class WorkoutItem {
  const WorkoutItem({
    required this.id,
    required this.exercise,
    this.sets = 1,
    this.reps = 1,
  });

  final String id;
  final ExerciseModel exercise;
  final int sets;
  final int reps;

  WorkoutItem copyWith({
    String? id,
    ExerciseModel? exercise,
    int? sets,
    int? reps,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exercise.id,
      'exerciseName': exercise.name,
      'exerciseBodyPart': exercise.bodyPart,
      'exerciseEquipment': exercise.equipment,
      'exerciseTarget': exercise.target,
      'mediaId': exercise.mediaId,
      'sets': sets,
      'reps': reps,
    };
  }

  factory WorkoutItem.fromJson(Map<String, dynamic> json, ExerciseModel exercise) {
    return WorkoutItem(
      id: json['id'] as String,
      exercise: exercise,
      sets: json['sets'] as int? ?? 1,
      reps: json['reps'] as int? ?? 1,
    );
  }
}

/// 训练计划：包含多个循环轮次，每轮有多个动作
class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.items,
    required this.cycles,
    this.isCompleted = false,
    this.completedAt,
  });

  final String id;
  final String name;
  final List<WorkoutItem> items;
  final int cycles;
  final bool isCompleted;
  final DateTime? completedAt;

  WorkoutPlan copyWith({
    String? id,
    String? name,
    List<WorkoutItem>? items,
    int? cycles,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      cycles: cycles ?? this.cycles,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'cycles': cycles,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory WorkoutPlan.fromJson(Map<String, dynamic> json, ExerciseModel Function(String id) getExercise) {
    final itemsList = (json['items'] as List<dynamic>?) ?? [];
    final items = itemsList.map((itemJson) {
      final exerciseId = itemJson['exerciseId'] as String;
      final exercise = getExercise(exerciseId);
      return WorkoutItem.fromJson(itemJson as Map<String, dynamic>, exercise);
    }).toList();

    return WorkoutPlan(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Workout',
      items: items,
      cycles: json['cycles'] as int? ?? 1,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory WorkoutPlan.fromJsonString(String source, ExerciseModel Function(String id) getExercise) {
    return WorkoutPlan.fromJson(jsonDecode(source) as Map<String, dynamic>, getExercise);
  }
}
