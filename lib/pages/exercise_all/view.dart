import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/core/widgets/image_asset.dart';
import 'package:fitness_app/exercises/models/exercise_model.dart';
import 'package:fitness_app/pages/exercise_detail/provider.dart';
import 'package:fitness_app/pages/exercise_all/providers.dart';
import 'package:fitness_app/pages/exercise_all/state.dart';
import 'package:fitness_app/router/app_route_url.dart';
import 'package:fitness_app/router/app_router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseAllPage extends ConsumerWidget {
  const ExerciseAllPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(filteredExercisesProvider);
    final selectedBodyPart = ref.watch(bodyPartFilterProvider);
    final appText = ref.watch(appTextProvider);
    final scrollController = ref.watch(exerciseScrollControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(appText.exerciseAllPageTitle)),
      body: Column(
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
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.80,
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
    // final appLocale = ref.watch(appLocaleProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          ref.read(selectedExerciseProvider.notifier).state = exercise;
          ref
              .read(navigationProvider)
              .pushNamed(
                AppRoute.exerciseDetailName,
                params: {'id': exercise.id},
              );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 图片
            Expanded(
              flex: 3,
              child: DLAssetImage(
                imageName: "${exercise.id}-${exercise.mediaId}.jpg",
                fit: BoxFit.fill,
                errorBuilder: (context, error, stack) =>
                    _buildPlaceholder(context),
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
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        // _buildTag(
                        //   context,
                        //   exercise.category,
                        //   Theme.of(context).colorScheme.primaryContainer,
                        //   Theme.of(context).colorScheme.onPrimaryContainer,
                        // ),
                        _buildTag(
                          context,
                          exercise.equipment,
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildTag(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: textColor, fontSize: 10),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
