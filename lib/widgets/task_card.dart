import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_flow/theme/app_theme.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onToggle});

  final TaskItem task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);
    final cardColor = AppTheme.cardColor(context);
    final borderColor = AppTheme.borderColor(context);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
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
                  color: task.isDone ? AppTheme.green : mutedColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: task.isDone
                  ? Icon(
                      Icons.check,
                      size: 15,
                      color: Theme.of(context).colorScheme.onPrimary,
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
                    color: task.isDone ? mutedColor : textColor,
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (task.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.note,
                    style: TextStyle(color: mutedColor, fontSize: 11),
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
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(task.dateTime),
                      style: TextStyle(fontSize: 10, color: mutedColor),
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
