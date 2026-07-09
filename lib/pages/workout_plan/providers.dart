import 'dart:convert';
import 'package:fitness_app/exercises/data/exercise_data_source_provider.dart';
import 'package:fitness_app/exercises/models/exercise_model.dart';
import 'package:fitness_app/exercises/models/localized_value.dart';
import 'package:fitness_app/pages/workout_plan/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 任务状态
enum TaskStatus { inProgress, completed, abandoned }

/// 任务（训练计划）
class WorkoutTask {
  const WorkoutTask({
    required this.id,
    required this.name,
    required this.items,
    required this.cycles,
    required this.status,
    this.progress = 0.0,
    this.createdAt,
    this.completedAt,
  });

  final String id;
  final String name;
  final List<WorkoutItem> items;
  final int cycles;
  final TaskStatus status;
  final double progress; // 0.0 - 1.0
  final DateTime? createdAt;
  final DateTime? completedAt;

  WorkoutTask copyWith({
    String? id,
    String? name,
    List<WorkoutItem>? items,
    int? cycles,
    TaskStatus? status,
    double? progress,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return WorkoutTask(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      cycles: cycles ?? this.cycles,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((i) => i.toJson()).toList(),
      'cycles': cycles,
      'status': status.index,
      'progress': progress,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory WorkoutTask.fromJson(
    Map<String, dynamic> json,
    ExerciseModel Function(String id) getExercise,
  ) {
    final itemsList = (json['items'] as List<dynamic>?) ?? [];
    final items = itemsList.map((itemJson) {
      final exerciseId = itemJson['exerciseId'] as String;
      final exercise = getExercise(exerciseId);
      return WorkoutItem.fromJson(itemJson as Map<String, dynamic>, exercise);
    }).toList();

    return WorkoutTask(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Workout',
      items: items,
      cycles: json['cycles'] as int? ?? 1,
      status: TaskStatus.values[json['status'] as int? ?? 0],
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }
}

/// 当前创建的任务
final currentTaskProvider =
    NotifierProvider<CurrentTaskNotifier, WorkoutTaskState>(
  CurrentTaskNotifier.new,
);

class WorkoutTaskState {
  const WorkoutTaskState({
    this.items = const [],
    this.cycles = 1,
  });

  final List<WorkoutItem> items;
  final int cycles;

  WorkoutTaskState copyWith({
    List<WorkoutItem>? items,
    int? cycles,
  }) {
    return WorkoutTaskState(
      items: items ?? this.items,
      cycles: cycles ?? this.cycles,
    );
  }

  bool get isEmpty => items.isEmpty;
}

class CurrentTaskNotifier extends Notifier<WorkoutTaskState> {
  @override
  WorkoutTaskState build() {
    return const WorkoutTaskState();
  }

  void addExercise(ExerciseModel exercise) {
    final newItem = WorkoutItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exercise: exercise,
    );
    state = state.copyWith(items: [...state.items, newItem]);
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != itemId).toList(),
    );
  }

  void updateSets(String itemId, int sets) {
    state = state.copyWith(
      items: state.items.map((i) {
        if (i.id == itemId) return i.copyWith(sets: sets);
        return i;
      }).toList(),
    );
  }

  void updateReps(String itemId, int reps) {
    state = state.copyWith(
      items: state.items.map((i) {
        if (i.id == itemId) return i.copyWith(reps: reps);
        return i;
      }).toList(),
    );
  }

  void updateCycles(int cycles) {
    state = state.copyWith(cycles: cycles);
  }

  void clearTask() {
    state = const WorkoutTaskState();
  }

  Future<void> createTask() async {
    if (state.isEmpty) return;

    final task = WorkoutTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Workout ${DateTime.now().millisecondsSinceEpoch}',
      items: state.items,
      cycles: state.cycles,
      status: TaskStatus.inProgress,
      createdAt: DateTime.now(),
    );

    await ref.read(tasksProvider.notifier).addTask(task);
    clearTask();
  }
}

/// 所有任务列表
final tasksProvider = NotifierProvider<TasksNotifier, List<WorkoutTask>>(
  TasksNotifier.new,
);

/// 选中的任务详情
final selectedTaskProvider = StateProvider<WorkoutTask?>((ref) => null);

class TasksNotifier extends Notifier<List<WorkoutTask>> {
  static const _storageKey = 'workout_tasks';

  @override
  List<WorkoutTask> build() {
    Future.microtask(() => _loadFromStorage());
    return [];
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString == null) return;

      final exercises = ref.read(exercisesProvider).maybeWhen(
        data: (data) => data,
        orElse: () => <ExerciseModel>[],
      );
      final exerciseMap = {for (var e in exercises) e.id: e};

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final tasks = jsonList.map((json) {
        return WorkoutTask.fromJson(
          json as Map<String, dynamic>,
          (id) => exerciseMap[id] ?? _createPlaceholderExercise(id),
        );
      }).toList();

      // 按创建时间倒序
      tasks.sort((a, b) =>
          (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));

      state = tasks;
    } catch (e) {
      // 忽略错误
    }
  }

  ExerciseModel _createPlaceholderExercise(String id) {
    return ExerciseModel(
      id: id,
      name: 'Unknown Exercise',
      category: '',
      bodyPart: '',
      equipment: '',
      instructions: const LocalizedText({}),
      instructionSteps: const LocalizedTextList({}),
      muscleGroup: '',
      secondaryMuscles: const [],
      target: '',
      image: null,
      gifUrl: null,
      mediaId: '',
      createdAt: null,
    );
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = state.map((t) => t.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      // 忽略错误
    }
  }

  Future<void> addTask(WorkoutTask task) async {
    state = [task, ...state];
    await _saveToStorage();
  }

  Future<void> updateTask(WorkoutTask task) async {
    state = state.map((t) => t.id == task.id ? task : t).toList();
    await _saveToStorage();
  }

  Future<void> removeTask(String taskId) async {
    state = state.where((t) => t.id != taskId).toList();
    await _saveToStorage();
  }

  Future<void> completeTask(String taskId) async {
    state = state.map((t) {
      if (t.id == taskId) {
        return t.copyWith(
          status: TaskStatus.completed,
          progress: 1.0,
          completedAt: DateTime.now(),
        );
      }
      return t;
    }).toList();
    await _saveToStorage();
  }

  Future<void> abandonTask(String taskId) async {
    state = state.map((t) {
      if (t.id == taskId) {
        return t.copyWith(status: TaskStatus.abandoned);
      }
      return t;
    }).toList();
    await _saveToStorage();
  }

  Future<void> updateProgress(String taskId, double progress) async {
    state = state.map((t) {
      if (t.id == taskId) {
        return t.copyWith(progress: progress.clamp(0.0, 1.0));
      }
      return t;
    }).toList();
    await _saveToStorage();
  }
}
