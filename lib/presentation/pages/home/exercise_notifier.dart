import 'package:fitness_app/data/exercise_data_source.dart';
import 'package:fitness_app/data/models/exercise_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 筛选状态
final bodyPartFilterProvider =
    NotifierProvider<BodyPartFilterNotifier, String?>(
      BodyPartFilterNotifier.new,
    );

class BodyPartFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? bodyPart) {
    state = bodyPart;
  }
}

// 过滤后的练习列表
final filteredExercisesProvider = Provider<AsyncValue<List<ExerciseModel>>>((
  ref,
) {
  final exercisesAsync = ref.watch(exercisesProvider);
  final selectedBodyPart = ref.watch(bodyPartFilterProvider);

  return exercisesAsync.whenData((exercises) {
    if (selectedBodyPart == null) {
      return exercises;
    }
    return exercises
        .where(
          (e) => e.bodyPart.toLowerCase() == selectedBodyPart.toLowerCase(),
        )
        .toList();
  });
});

// 所有身体部位分类
const bodyParts = [
  'back',
  'cardio',
  'chest',
  'lower arms',
  'lower legs',
  'neck',
  'shoulders',
  'upper arms',
  'upper legs',
  'waist',
];
