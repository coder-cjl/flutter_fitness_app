import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/core/widgets/image_asset.dart';
import 'package:fitness_app/pages/exercise_all/state.dart';
import 'package:fitness_app/pages/workout_plan/models.dart';
import 'package:fitness_app/pages/workout_plan/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutPlanPage extends ConsumerWidget {
  const WorkoutPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(currentTaskProvider);
    final appText = ref.watch(appTextProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appText.workoutPlanTitle),
        actions: [
          if (!taskState.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref.read(currentTaskProvider.notifier).clearTask();
              },
              tooltip: appText.clearPlanLabel,
            ),
        ],
      ),
      body: taskState.isEmpty
          ? _buildEmptyState(context, ref)
          : _buildTaskContent(context, ref, taskState),
      floatingActionButton: taskState.isEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showExerciseSelector(context, ref),
              icon: const Icon(Icons.add),
              label: Text(appText.addExerciseLabel),
            )
          : FloatingActionButton.extended(
              onPressed: () => _showExerciseSelector(context, ref),
              icon: const Icon(Icons.add),
              label: Text(appText.addExerciseLabel),
            ),
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
          Text(
            appText.workoutPlanEmptyHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskContent(
    BuildContext context,
    WidgetRef ref,
    WorkoutTaskState taskState,
  ) {
    final appText = ref.watch(appTextProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 循环次数
          _buildCyclesSection(context, ref, taskState),

          // 动作列表
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              appText.workoutItemsLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: taskState.items.length,
            itemBuilder: (context, index) {
              final item = taskState.items[index];
              return _WorkoutItemCard(item: item, index: index);
            },
          ),

          // 创建任务按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(currentTaskProvider.notifier).createTask();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(appText.taskCreatedMessage),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(appText.createTaskLabel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyclesSection(
    BuildContext context,
    WidgetRef ref,
    WorkoutTaskState taskState,
  ) {
    final appText = ref.watch(appTextProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              appText.cyclesLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: taskState.cycles > 1
                      ? () {
                          ref
                              .read(currentTaskProvider.notifier)
                              .updateCycles(taskState.cycles - 1);
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
                    '${taskState.cycles}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(currentTaskProvider.notifier)
                        .updateCycles(taskState.cycles + 1);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
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

class _WorkoutItemCard extends ConsumerWidget {
  const _WorkoutItemCard({required this.item, required this.index});

  final WorkoutItem item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appText = ref.watch(appTextProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.exercise.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    ref.read(currentTaskProvider.notifier).removeItem(item.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _SetRepControl(
                    label: appText.setsLabel,
                    value: item.sets,
                    onChanged: (value) {
                      ref
                          .read(currentTaskProvider.notifier)
                          .updateSets(item.id, value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SetRepControl(
                    label: appText.repsLabel,
                    value: item.reps,
                    onChanged: (value) {
                      ref
                          .read(currentTaskProvider.notifier)
                          .updateReps(item.id, value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SetRepControl extends StatelessWidget {
  const _SetRepControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
              visualDensity: VisualDensity.compact,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add_circle_outline),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
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
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: DLAssetImage(
                              imageName:
                                  "${exercise.id}-${exercise.mediaId}.jpg",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  Container(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
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
                              .read(currentTaskProvider.notifier)
                              .addExercise(exercise);
                          Navigator.pop(context);
                        },
                      );
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
