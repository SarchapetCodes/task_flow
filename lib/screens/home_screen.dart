import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.visibleTasks;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
                      DateFormat('EEEE, d MMMM', 'hy').format(DateTime.now()),
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Բարև, Արեն.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                backgroundColor: AppTheme.card,
                child: Text('Ա', style: TextStyle(color: AppTheme.green)),
              ),
            ],
          ),
          const SizedBox(height: 22),

          ProgressCard(
            done: provider.completedToday,
            total: provider.totalToday,
            progress: provider.progress,
          ),

          const SizedBox(height: 16),

          TaskFilterBar(value: provider.filter, onChanged: provider.setFilter),

          const SizedBox(height: 16),

          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'Գործ չկա',
                      style: TextStyle(color: AppTheme.muted, fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          provider.deleteTask(task.id);
                        },
                        child: TaskCard(
                          task: task,
                          onToggle: () {
                            provider.toggleTask(task.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
