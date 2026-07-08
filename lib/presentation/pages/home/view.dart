import 'package:fitness_app/core/settings/app_settings.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:fitness_app/data/exercise_data_source.dart';
import 'package:fitness_app/data/models/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final exercisesAsync = ref.watch(exercisesProvider);

    return exercisesAsync.when(
      loading: () => Center(child: Text(AppText.homeLoading(locale))),
      error: (error, stack) =>
          Center(child: Text(AppText.homeLoadError(locale))),
      data: (exercises) {
        if (exercises.isEmpty) {
          return Center(child: Text(AppText.homeEmpty(locale)));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: exercises.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return _ExercisePreviewCard(exercise: exercise, locale: locale);
          },
        );
      },
    );
  }
}

class _ExercisePreviewCard extends StatelessWidget {
  const _ExercisePreviewCard({required this.exercise, required this.locale});

  final ExerciseModel exercise;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final instruction = exercise.instruction(locale);
    final steps = exercise.steps(locale);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('${exercise.bodyPart} · ${exercise.target}'),
            const SizedBox(height: 8),
            Text(
              '${AppText.instructionLabel(locale)}: $instruction',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (steps.isNotEmpty)
              Text(
                '${AppText.stepsLabel(locale)}: ${steps.first}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
