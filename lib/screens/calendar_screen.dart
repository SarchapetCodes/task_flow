import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/theme/app_theme.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = context.select<TaskProvider, List<TaskItem>>(
      (provider) => provider.allTasks,
    );

    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);
    final surfaceColor = AppTheme.surfaceColor(context);
    final cardColor = AppTheme.cardColor(context);
    final backgroundColor = AppTheme.backgroundColor(context);
    final borderColor = AppTheme.borderColor(context);

    final tasks =
        allTasks.where((task) => sameDay(task.dateTime, selectedDate)).toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    const weekdays = ['Երկ', 'Երք', 'Չրք', 'Հնգ', 'Ուրբ', 'Շբթ', 'Կիր'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),

          Text(
            'Օրացույց',
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Ընտրիր օրը և տես առաջադրանքները',
            style: TextStyle(color: mutedColor),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month - 1,
                            1,
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        color: AppTheme.green,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        DateFormat('MMMM yyyy', 'hy').format(selectedDate),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month + 1,
                            1,
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.chevron_right,
                        color: AppTheme.green,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: List.generate(7, (index) {
                    final day = weekStart.add(Duration(days: index));

                    final isSelected = sameDay(day, selectedDate);
                    final isToday = sameDay(day, DateTime.now());

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => selectedDate = day);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.green : cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: isToday && !isSelected
                                ? Border.all(color: AppTheme.green)
                                : null,
                          ),
                          child: Column(
                            children: [
                              Text(
                                weekdays[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? backgroundColor
                                      : mutedColor,
                                  fontSize: 10,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isSelected
                                      ? backgroundColor
                                      : textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 8),

                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => selectedDate = DateTime.now());
                  },
                  icon: const Icon(Icons.today, size: 18),
                  label: const Text('Այսօր'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.green,
                    side: BorderSide(color: borderColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            DateFormat('d MMMM', 'hy').format(selectedDate),
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: mutedColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Այս օրվա համար գործ չկա',
                          style: TextStyle(color: mutedColor),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return TaskCard(
                        task: task,
                        onToggle: () {
                          context.read<TaskProvider>().toggleTask(task.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
