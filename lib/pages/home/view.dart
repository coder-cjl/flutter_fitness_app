import 'package:fitness_app/core/settings/app_text.dart';
import 'package:fitness_app/core/settings/app_text_provider.dart';
import 'package:fitness_app/pages/workout_plan/providers.dart';
import 'package:fitness_app/router/app_route_url.dart';
import 'package:fitness_app/router/app_router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appText = ref.watch(appTextProvider);
    final tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(appText.homePageTitle)),
        body: Center(child: Text(appText.loadingTasks)),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(appText.homePageTitle)),
        body: Center(child: Text(appText.tasksLoadError)),
      ),
      data: (tasks) => _buildContent(context, appText, tasks),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DLAppText appText,
    List<WorkoutTask> tasks,
  ) {
    final inProgressTasks = tasks
        .where((t) => t.status == TaskStatus.inProgress)
        .toList();
    final completedTasks = tasks
        .where((t) => t.status == TaskStatus.completed)
        .toList();
    final abandonedTasks = tasks
        .where((t) => t.status == TaskStatus.abandoned)
        .toList();

    if (tasks.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(appText.homePageTitle)),
        body: Center(
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
                appText.workoutHistoryEmpty,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                appText.workoutHistoryEmptyHint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(appText.homePageTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProgressCard(tasks: tasks),
            const SizedBox(height: 24),
            if (inProgressTasks.isNotEmpty) ...[
              _SectionHeader(
                title: appText.workoutInProgress,
                count: inProgressTasks.length,
              ),
              ...inProgressTasks.map((t) => _TaskCard(task: t)),
              const SizedBox(height: 24),
            ],
            if (completedTasks.isNotEmpty) ...[
              _SectionHeader(
                title: appText.workoutCompleted,
                count: completedTasks.length,
              ),
              ...completedTasks.take(5).map((t) => _TaskCard(task: t)),
              const SizedBox(height: 24),
            ],
            if (abandonedTasks.isNotEmpty) ...[
              _SectionHeader(
                title: appText.workoutAbandoned,
                count: abandonedTasks.length,
              ),
              ...abandonedTasks.take(5).map((t) => _TaskCard(task: t)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.tasks});
  final List<WorkoutTask> tasks;

  @override
  Widget build(BuildContext context) {
    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final inProgress = tasks
        .where((t) => t.status == TaskStatus.inProgress)
        .length;
    final abandoned = tasks
        .where((t) => t.status == TaskStatus.abandoned)
        .length;
    final total = tasks.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completed of $total tasks',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                      Center(
                        child: Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _LegendDot(
                  label: 'In Progress $inProgress',
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                _LegendDot(label: 'Completed $completed', color: Colors.green),
                const SizedBox(width: 16),
                _LegendDot(label: 'Abandoned $abandoned', color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.task});
  final WorkoutTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          ref
              .read(navigationProvider)
              .pushNamed(AppRoute.taskDetailName, params: {'id': task.id});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${task.items.length} exercises × ${task.cycles} cycles',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _StatusIcon(status: task.status),
                ],
              ),
              if (task.status == TaskStatus.inProgress) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: task.progress,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async => await ref
                          .read(tasksProvider.notifier)
                          .abandonTask(task.id),
                      child: const Text('Abandon'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async => await ref
                          .read(tasksProvider.notifier)
                          .completeTask(task.id),
                      child: const Text('Complete'),
                    ),
                  ],
                ),
              ],
              if (task.completedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  _formatDate(task.completedAt!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: task.items.take(5).map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.exercise.name,
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TaskStatus.inProgress:
        return Icon(
          Icons.play_circle_outline,
          color: Theme.of(context).colorScheme.primary,
        );
      case TaskStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case TaskStatus.abandoned:
        return const Icon(Icons.cancel, color: Colors.grey);
    }
  }
}
