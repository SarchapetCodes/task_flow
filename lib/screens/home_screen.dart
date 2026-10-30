import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/theme/app_theme.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.select<TaskProvider, List<TaskItem>>(
      (provider) => provider.visibleTasks,
    );

    final completedToday = context.select<TaskProvider, int>(
      (provider) => provider.completedToday,
    );

    final totalToday = context.select<TaskProvider, int>(
      (provider) => provider.totalToday,
    );

    final progress = context.select<TaskProvider, double>(
      (provider) => provider.progress,
    );

    final filter = context.select<TaskProvider, TaskFilter>(
      (provider) => provider.filter,
    );

    final userName = context.select<UserProvider, String>(
      (provider) => provider.name,
    );

    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);

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
                      style: TextStyle(color: mutedColor, fontSize: 12),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Բարև, $userName',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppTheme.cardColor(context),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(color: AppTheme.green),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ProgressCard(
            done: completedToday,
            total: totalToday,
            progress: progress,
          ),

          const SizedBox(height: 16),

          TaskFilterBar(
            value: filter,
            onChanged: (value) {
              context.read<TaskProvider>().setFilter(value);
            },
          ),

          const SizedBox(height: 16),

          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      'Գործ չկա',
                      style: TextStyle(color: mutedColor, fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
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
                          context.read<TaskProvider>().deleteTask(task.id);
                        },
                        child: TaskCard(
                          task: task,
                          onToggle: () {
                            context.read<TaskProvider>().toggleTask(task.id);
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
