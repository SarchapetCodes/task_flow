import 'package:flutter/material.dart';

enum TaskCategory { study, sport, home, other }

extension CategoryInfo on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.study:
        return 'Ուսում';
      case TaskCategory.sport:
        return 'Սպորտ';
      case TaskCategory.home:
        return 'Տուն';
      case TaskCategory.other:
        return 'Այլ';
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.study:
        return const Color(0xFF4DD0B1);
      case TaskCategory.sport:
        return const Color(0xFFFFC15A);
      case TaskCategory.home:
        return const Color(0xFF78AFFF);
      case TaskCategory.other:
        return const Color(0xFFD6A1F2);
    }
  }
}

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    this.note = '',
    required this.category,
    required this.dateTime,
    this.reminder = false,
    this.isDone = false,
    this.completedAt,
  });

  final String id;
  final String title;
  final String note;
  final TaskCategory category;
  final DateTime dateTime;
  final bool reminder;

  bool isDone;
  DateTime? completedAt;
}
