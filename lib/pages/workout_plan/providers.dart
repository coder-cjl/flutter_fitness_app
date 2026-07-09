import 'dart:convert';
import 'package:fitness_app/exercises/data/exercise_data_source_provider.dart';
import 'package:fitness_app/exercises/models/exercise_model.dart';
import 'package:fitness_app/exercises/models/localized_value.dart';
import 'package:fitness_app/pages/workout_plan/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 草稿训练计划列表（持久化）
final draftWorkoutPlansProvider =
    NotifierProvider<DraftWorkoutPlansNotifier, List<WorkoutPlan>>(
  DraftWorkoutPlansNotifier.new,
);

class DraftWorkoutPlansNotifier extends Notifier<List<WorkoutPlan>> {
  static const _storageKey = 'draft_workout_plans';

  @override
  List<WorkoutPlan> build() {
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
      final plans = jsonList.map((json) {
        return WorkoutPlan.fromJson(
          json as Map<String, dynamic>,
          (id) => exerciseMap[id] ?? _createPlaceholderExercise(id),
        );
      }).toList();

      state = plans;
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
      final jsonList = state.map((plan) => plan.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      // 忽略错误
    }
  }

  /// 添加新草稿
  Future<void> addDraft() async {
    final newPlan = WorkoutPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Workout ${state.length + 1}',
      items: [],
      cycles: 1,
    );
    state = [newPlan, ...state];
    await _saveToStorage();
  }

  /// 更新草稿
  Future<void> updateDraft(WorkoutPlan plan) async {
    state = state.map((p) => p.id == plan.id ? plan : p).toList();
    await _saveToStorage();
  }

  /// 删除草稿
  Future<void> removeDraft(String planId) async {
    state = state.where((p) => p.id != planId).toList();
    await _saveToStorage();
  }

  /// 添加动作到草稿
  Future<void> addExerciseToDraft(String planId, ExerciseModel exercise) async {
    final newItem = WorkoutItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exercise: exercise,
    );
    state = state.map((plan) {
      if (plan.id == planId) {
        return plan.copyWith(items: [...plan.items, newItem]);
      }
      return plan;
    }).toList();
    await _saveToStorage();
  }

  /// 从草稿移除动作
  Future<void> removeExerciseFromDraft(String planId, String itemId) async {
    state = state.map((plan) {
      if (plan.id == planId) {
        return plan.copyWith(
          items: plan.items.where((i) => i.id != itemId).toList(),
        );
      }
      return plan;
    }).toList();
    await _saveToStorage();
  }

  /// 更新草稿中的动作项
  Future<void> updateDraftItem(
    String planId,
    String itemId, {
    int? sets,
    int? reps,
  }) async {
    state = state.map((plan) {
      if (plan.id == planId) {
        return plan.copyWith(
          items: plan.items.map((item) {
            if (item.id == itemId) {
              return item.copyWith(sets: sets ?? item.sets, reps: reps ?? item.reps);
            }
            return item;
          }).toList(),
        );
      }
      return plan;
    }).toList();
    await _saveToStorage();
  }

  /// 更新草稿循环次数
  Future<void> updateDraftCycles(String planId, int cycles) async {
    state = state.map((plan) {
      if (plan.id == planId) {
        return plan.copyWith(cycles: cycles);
      }
      return plan;
    }).toList();
    await _saveToStorage();
  }
}

/// 已完成的训练计划列表
final completedWorkoutPlansProvider =
    NotifierProvider<CompletedWorkoutPlansNotifier, List<WorkoutPlan>>(
  CompletedWorkoutPlansNotifier.new,
);

class CompletedWorkoutPlansNotifier extends Notifier<List<WorkoutPlan>> {
  static const _storageKey = 'completed_workout_plans';

  @override
  List<WorkoutPlan> build() {
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
      final plans = jsonList.map((json) {
        return WorkoutPlan.fromJson(
          json as Map<String, dynamic>,
          (id) => exerciseMap[id] ?? _createPlaceholderExercise(id),
        );
      }).toList();

      // 按完成时间倒序
      plans.sort((a, b) {
        final aTime = a.completedAt ?? DateTime.now();
        final bTime = b.completedAt ?? DateTime.now();
        return bTime.compareTo(aTime);
      });

      state = plans;
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
      final jsonList = state.map((plan) => plan.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      // 忽略错误
    }
  }

  /// 添加完成记录
  Future<void> addCompleted(WorkoutPlan plan) async {
    final completedPlan = plan.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    state = [completedPlan, ...state];
    await _saveToStorage();
  }

  /// 删除完成记录
  Future<void> removeCompleted(String planId) async {
    state = state.where((p) => p.id != planId).toList();
    await _saveToStorage();
  }
}
