import 'package:flutter/material.dart';
import 'package:task_flow/theme/app_theme.dart';

import '../providers/task_provider.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskFilter value;
  final ValueChanged<TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = {
      TaskFilter.all: 'Բոլորը',
      TaskFilter.active: 'Ակտիվ',
      TaskFilter.completed: 'Ավարտված',
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskFilter.values.map((filter) {
        final selected = value == filter;

        return ChoiceChip(
          label: Text(labels[filter]!),
          selected: selected,
          showCheckmark: false,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),

          selectedColor: AppTheme.green,
          backgroundColor: AppTheme.background,

          side: BorderSide(color: selected ? AppTheme.green : AppTheme.border),

          labelStyle: TextStyle(
            color: selected ? AppTheme.background : AppTheme.muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),

          onSelected: (_) => onChanged(filter),
        );
      }).toList(),
    );
  }
}
