import 'package:fitness_app/pages/exercise_detail/provider.dart';
import 'package:fitness_app/pages/workout_plan/providers.dart';
import 'package:fitness_app/router/app_route_url.dart';
import 'package:fitness_app/router/app_router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({super.key, required this.task});

  final WorkoutTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(task.name)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: task.items.length,
        itemBuilder: (context, index) {
          final item = task.items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              title: Text(item.exercise.name),
              subtitle: Text('${item.sets} sets × ${item.reps} reps'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ref.read(selectedExerciseProvider.notifier).state = item.exercise;
                ref
                    .read(navigationProvider)
                    .pushNamed(AppRoute.exerciseDetailName, params: {'id': item.exercise.id});
              },
            ),
          );
        },
      ),
    );
  }
}
