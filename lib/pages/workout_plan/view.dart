import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/core/widgets/image_asset.dart';
import 'package:fitness_app/exercises/data/exercise_data_source_provider.dart';
import 'package:fitness_app/exercises/models/exercise_model.dart';
import 'package:fitness_app/pages/exercise_all/state.dart';
import 'package:fitness_app/pages/workout_plan/models.dart';
import 'package:fitness_app/pages/workout_plan/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// 选择动作时的筛选状态
final exerciseSelectorFilterProvider =
    NotifierProvider<ExerciseSelectorFilterNotifier, String?>(
      ExerciseSelectorFilterNotifier.new,
    );

class ExerciseSelectorFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? bodyPart) {
    state = bodyPart;
  }
}

// 选择动作时的筛选列表
final filteredSelectorExercisesProvider =
    Provider<AsyncValue<List<ExerciseModel>>>((ref) {
      final exercisesAsync = ref.watch(exercisesProvider);
      final selectedBodyPart = ref.watch(exerciseSelectorFilterProvider);

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

// 当前选中的草稿ID
final selectedDraftIdProvider = StateProvider<String?>((ref) => null);

class WorkoutPlanPage extends ConsumerWidget {
  const WorkoutPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftPlans = ref.watch(draftWorkoutPlansProvider);
    final selectedDraftId = ref.watch(selectedDraftIdProvider);
    final appText = ref.watch(appTextProvider);

    // 如果没有选中的草稿或者选中的不在列表中，自动选中第一个
    if (selectedDraftId == null && draftPlans.isNotEmpty) {
      Future.microtask(() {
        ref.read(selectedDraftIdProvider.notifier).state = draftPlans.first.id;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appText.workoutPlanTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(draftWorkoutPlansProvider.notifier).addDraft();
            },
            tooltip: appText.addWorkoutLabel,
          ),
        ],
      ),
      body: draftPlans.isEmpty
          ? _buildEmptyState(context, ref)
          : _buildPlanList(context, ref, draftPlans, selectedDraftId),
      floatingActionButton: selectedDraftId != null
          ? FloatingActionButton.extended(
              onPressed: () => _showExerciseSelector(context, ref),
              icon: const Icon(Icons.add),
              label: Text(appText.addExerciseLabel),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final appText = ref.watch(appTextProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            appText.workoutPlanEmpty,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(draftWorkoutPlansProvider.notifier).addDraft();
            },
            icon: const Icon(Icons.add),
            label: Text(appText.createWorkoutLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanList(
    BuildContext context,
    WidgetRef ref,
    List<WorkoutPlan> draftPlans,
    String? selectedDraftId,
  ) {
    final appText = ref.watch(appTextProvider);
    final selectedPlan = draftPlans
        .where((p) => p.id == selectedDraftId)
        .firstOrNull;

    return Row(
      children: [
        // 左侧：计划列表
        SizedBox(
          width: 100,
          child: ListView.builder(
            itemCount: draftPlans.length,
            itemBuilder: (context, index) {
              final plan = draftPlans[index];
              final isSelected = plan.id == selectedDraftId;
              return ListTile(
                dense: true,
                selected: isSelected,
                selectedTileColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer,
                title: Text(
                  plan.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${plan.items.length} exercises',
                  style: const TextStyle(fontSize: 10),
                ),
                onTap: () {
                  ref.read(selectedDraftIdProvider.notifier).state = plan.id;
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {
                    ref
                        .read(draftWorkoutPlansProvider.notifier)
                        .removeDraft(plan.id);
                    if (selectedDraftId == plan.id) {
                      final remaining = draftPlans
                          .where((p) => p.id != plan.id)
                          .toList();
                      ref.read(selectedDraftIdProvider.notifier).state =
                          remaining.isNotEmpty ? remaining.first.id : null;
                    }
                  },
                ),
              );
            },
          ),
        ),
        const VerticalDivider(width: 1),
        // 右侧：计划详情
        Expanded(
          child: selectedPlan == null
              ? Center(child: Text(appText.selectWorkoutHint))
              : _WorkoutPlanDetail(plan: selectedPlan),
        ),
      ],
    );
  }

  void _showExerciseSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _ExerciseSelectorSheet(),
    );
  }
}

class _WorkoutPlanDetail extends ConsumerWidget {
  const _WorkoutPlanDetail({required this.plan});

  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appText = ref.watch(appTextProvider);

    return Column(
      children: [
        // 循环次数
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appText.cyclesLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: plan.cycles > 1
                        ? () {
                            ref
                                .read(draftWorkoutPlansProvider.notifier)
                                .updateDraftCycles(plan.id, plan.cycles - 1);
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${plan.cycles}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(draftWorkoutPlansProvider.notifier)
                          .updateDraftCycles(plan.id, plan.cycles + 1);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // 动作列表
        Expanded(
          child: plan.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        appText.noExercisesHint,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: plan.items.length,
                  itemBuilder: (context, index) {
                    final item = plan.items[index];
                    return _WorkoutItemTile(
                      planId: plan.id,
                      item: item,
                      index: index,
                    );
                  },
                ),
        ),
        // 完成按钮
        if (plan.items.isNotEmpty)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(completedWorkoutPlansProvider.notifier)
                      .addCompleted(plan);
                  await ref
                      .read(draftWorkoutPlansProvider.notifier)
                      .removeDraft(plan.id);
                  ref.read(selectedDraftIdProvider.notifier).state = null;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(appText.workoutCompletedMessage),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(appText.completeWorkoutLabel),
              ),
            ),
          ),
      ],
    );
  }
}

class _WorkoutItemTile extends ConsumerWidget {
  const _WorkoutItemTile({
    required this.planId,
    required this.item,
    required this.index,
  });

  final String planId;
  final WorkoutItem item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appText = ref.watch(appTextProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 序号
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.exercise.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Sets
                      Text('${appText.setsLabel}: '),
                      IconButton(
                        onPressed: item.sets > 1
                            ? () {
                                ref
                                    .read(draftWorkoutPlansProvider.notifier)
                                    .updateDraftItem(
                                      planId,
                                      item.id,
                                      sets: item.sets - 1,
                                    );
                              }
                            : null,
                        icon: const Icon(Icons.remove, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(' ${item.sets} '),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(draftWorkoutPlansProvider.notifier)
                              .updateDraftItem(
                                planId,
                                item.id,
                                sets: item.sets + 1,
                              );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      // Reps
                      Text('${appText.repsLabel}: '),
                      IconButton(
                        onPressed: item.reps > 1
                            ? () {
                                ref
                                    .read(draftWorkoutPlansProvider.notifier)
                                    .updateDraftItem(
                                      planId,
                                      item.id,
                                      reps: item.reps - 1,
                                    );
                              }
                            : null,
                        icon: const Icon(Icons.remove, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(' ${item.reps} '),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(draftWorkoutPlansProvider.notifier)
                              .updateDraftItem(
                                planId,
                                item.id,
                                reps: item.reps + 1,
                              );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 删除
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                ref
                    .read(draftWorkoutPlansProvider.notifier)
                    .removeExerciseFromDraft(planId, item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseSelectorSheet extends ConsumerStatefulWidget {
  const _ExerciseSelectorSheet();

  @override
  ConsumerState<_ExerciseSelectorSheet> createState() =>
      _ExerciseSelectorSheetState();
}

class _ExerciseSelectorSheetState
    extends ConsumerState<_ExerciseSelectorSheet> {
  ScrollController? _listScrollController;
  String? _previousFilter;

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(filteredSelectorExercisesProvider);
    final selectedBodyPart = ref.watch(exerciseSelectorFilterProvider);
    final appText = ref.watch(appTextProvider);

    // 检测筛选变化并滚动
    if (_previousFilter != selectedBodyPart &&
        _listScrollController?.hasClients == true) {
      _previousFilter = selectedBodyPart;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listScrollController?.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, sheetScrollController) {
        _listScrollController = sheetScrollController;

        return Column(
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appText.selectExerciseLabel,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // 筛选标签
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bodyParts.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final bodyPart = isAll ? null : bodyParts[index - 1];
                  final isSelected = selectedBodyPart == bodyPart;

                  return FilterChip(
                    label: Text(isAll ? 'All' : _formatBodyPart(bodyPart!)),
                    selected: isSelected,
                    onSelected: (_) {
                      ref
                          .read(exerciseSelectorFilterProvider.notifier)
                          .setFilter(bodyPart);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            // 练习列表
            Expanded(
              child: exercisesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text(appText.exercisesLoadError)),
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return Center(child: Text(appText.exercisesEmpty));
                  }
                  return ListView.builder(
                    controller: _listScrollController,
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return _ExerciseListTile(exercise: exercise);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatBodyPart(String bodyPart) {
    return bodyPart
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

class _ExerciseListTile extends ConsumerWidget {
  const _ExerciseListTile({required this.exercise});

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDraftId = ref.watch(selectedDraftIdProvider);
    if (selectedDraftId == null) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 56,
          height: 56,
          child: DLAssetImage(
            imageName: "${exercise.id}-${exercise.mediaId}.jpg",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.fitness_center),
            ),
          ),
        ),
      ),
      title: Text(exercise.name),
      subtitle: Text(
        '${exercise.bodyPart} | ${exercise.target}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.add_circle_outline),
      onTap: () {
        ref
            .read(draftWorkoutPlansProvider.notifier)
            .addExerciseToDraft(selectedDraftId, exercise);
        Navigator.pop(context);
      },
    );
  }
}
