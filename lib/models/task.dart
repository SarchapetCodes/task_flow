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
  const TaskItem({
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
  final bool isDone;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'category': category.name,
      'dateTime': dateTime.toIso8601String(),
      'reminder': reminder,
      'isDone': isDone,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      title: json['title'] as String,
      note: json['note'] as String? ?? '',
      category: TaskCategory.values.firstWhere(
        (category) => category.name == json['category'],
        orElse: () => TaskCategory.other,
      ),
      dateTime: DateTime.parse(json['dateTime'] as String),
      reminder: json['reminder'] as bool? ?? false,
      isDone: json['isDone'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }

  TaskItem copyWith({
    String? title,
    String? note,
    TaskCategory? category,
    DateTime? dateTime,
    bool? reminder,
    bool? isDone,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return TaskItem(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      reminder: reminder ?? this.reminder,
      isDone: isDone ?? this.isDone,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
    );
  }
}
