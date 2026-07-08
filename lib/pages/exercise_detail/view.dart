import 'package:fitness_app/core/settings/app_locale_provider.dart';
import 'package:fitness_app/core/settings/app_text.dart';
import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/core/widgets/image_gif_asset.dart';
import 'package:fitness_app/exercises/models/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseDetailPage extends ConsumerWidget {
  const ExerciseDetailPage({super.key, required this.exercise});

  final ExerciseModel exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final appText = ref.watch(appTextProvider);
    final instructions = exercise.instruction(locale);
    final steps = exercise.steps(locale);

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // GIF 动态图
              AspectRatio(
                aspectRatio: 16 / 9,
                child: DLAssetGifImage(
                  imageName: "${exercise.id}-${exercise.mediaId}.gif",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      _buildPlaceholder(context),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 基础信息卡片
                    _buildInfoCard(context, appText, locale),
                    const SizedBox(height: 16),

                    // Instructions 说明
                    if (instructions.isNotEmpty) ...[
                      Text(
                        appText.instructionLabel,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        instructions,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Instruction Steps 步骤
                    if (steps.isNotEmpty) ...[
                      Text(
                        appText.stepsLabel,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...steps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;
                        return _StepItem(index: index + 1, text: step);
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    DLAppText appText,
    Locale locale,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              label: 'Body Part',
              value: _formatBodyPart(exercise.bodyPart),
            ),
            const Divider(height: 16),
            _InfoRow(label: 'Equipment', value: exercise.equipment),
            const Divider(height: 16),
            _InfoRow(label: 'Target', value: exercise.target),
            if (exercise.muscleGroup.isNotEmpty) ...[
              const Divider(height: 16),
              _InfoRow(label: 'Muscle Group', value: exercise.muscleGroup),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.fitness_center,
          size: 64,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatBodyPart(String bodyPart) {
    return bodyPart
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                '$index',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
