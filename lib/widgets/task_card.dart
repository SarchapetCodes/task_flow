import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onToggle});

  final TaskItem task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: task.isDone ? AppTheme.green : Colors.transparent,
                border: Border.all(
                  color: task.isDone ? AppTheme.green : AppTheme.muted,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: task.isDone
                  ? const Icon(
                      Icons.check,
                      size: 15,
                      color: AppTheme.background,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: task.isDone ? AppTheme.muted : AppTheme.darkGreen,
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (task.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.note,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                  ),
                ],
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: task.category.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.category.label,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.background,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(task.dateTime),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.muted,
                      ),
                    ),
                    if (task.reminder)
                      const Icon(
                        Icons.notifications_active_outlined,
                        size: 14,
                        color: AppTheme.green,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
