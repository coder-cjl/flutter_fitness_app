import 'package:fitness_app/core/providers/exercise_image.dart';
import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/data/models/exercise_model.dart';
import 'package:fitness_app/presentation/pages/home/exercise_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(filteredExercisesProvider);
    final selectedBodyPart = ref.watch(bodyPartFilterProvider);
    final appText = ref.watch(appTextProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bodyParts.length + 1, // +1 for "All"
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
                          .read(bodyPartFilterProvider.notifier)
                          .setFilter(bodyPart);
                    },
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // 练习列表
            Expanded(
              child: exercisesAsync.when(
                loading: () => Center(child: Text(appText.loadingExercises)),
                error: (error, stack) =>
                    Center(child: Text(appText.exercisesLoadError)),
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return Center(child: Text(appText.exercisesEmpty));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return _ExerciseCard(exercise: exercises[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBodyPart(String bodyPart) {
    return bodyPart
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

class _ExerciseCard extends ConsumerWidget {
  const _ExerciseCard({required this.exercise});

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageMapAsync = ref.watch(exerciseImageMapProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 图片
          Expanded(
            flex: 3,
            child: imageMapAsync.when(
              data: (imageMap) {
                final imagePath = imageMap[exercise.id];
                print('Exercise ID: ${exercise.id}, Image Path: $imagePath');
                if (imagePath != null) {
                  return Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        _buildPlaceholder(context),
                  );
                }
                return _buildPlaceholder(context);
              },
              loading: () => _buildPlaceholder(context),
              error: (e, s) => _buildPlaceholder(context),
            ),
          ),

          // 信息
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    exercise.target,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.fitness_center,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
