import 'package:flutter/foundation.dart';

import '../models/task.dart';

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  final List<TaskItem> _tasks = [];

  TaskFilter _filter = TaskFilter.all;

  TaskFilter get filter => _filter;

  List<TaskItem> get allTasks => List.unmodifiable(_tasks);

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<TaskItem> get todayTasks {
    final now = DateTime.now();

    return _tasks.where((task) => _sameDay(task.dateTime, now)).toList();
  }

  List<TaskItem> get visibleTasks {
    return todayTasks.where((task) {
      switch (_filter) {
        case TaskFilter.all:
          return true;
        case TaskFilter.active:
          return !task.isDone;
        case TaskFilter.completed:
          return task.isDone;
      }
    }).toList();
  }

  int get completedToday => todayTasks.where((task) => task.isDone).length;

  int get totalToday => todayTasks.length;

  double get progress => totalToday == 0 ? 0 : completedToday / totalToday;

  void setFilter(TaskFilter value) {
    _filter = value;
    notifyListeners();
  }

  void addTask(TaskItem task) {
    _tasks.insert(0, task);
    _filter = TaskFilter.all;
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) return;

    final task = _tasks[index];

    task.isDone = !task.isDone;
    task.completedAt = task.isDone ? DateTime.now() : null;

    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  int completedOn(DateTime date) {
    return _tasks.where((task) {
      final completedAt = task.completedAt;

      return task.isDone && completedAt != null && _sameDay(completedAt, date);
    }).length;
  }

  DateTime get weekStart {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return today.subtract(Duration(days: today.weekday - DateTime.monday));
  }

  int get completedThisWeek {
    final start = weekStart;
    final end = start.add(const Duration(days: 7));

    return _tasks.where((task) {
      final date = task.completedAt;

      return task.isDone &&
          date != null &&
          !date.isBefore(start) &&
          date.isBefore(end);
    }).length;
  }

  int get streak {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day);

    if (completedOn(date) == 0) {
      date = date.subtract(const Duration(days: 1));
    }

    var count = 0;

    for (var i = 0; i < 365; i++) {
      if (completedOn(date) == 0) break;

      count++;
      date = date.subtract(const Duration(days: 1));
    }

    return count;
  }

  Map<TaskCategory, int> get categoryCounts {
    final counts = <TaskCategory, int>{
      for (final category in TaskCategory.values) category: 0,
    };

    for (final task in _tasks) {
      if (task.isDone) {
        counts[task.category] = (counts[task.category] ?? 0) + 1;
      }
    }

    return counts;
  }

  Map<TaskCategory, int> get categoryTotals {
    final totals = <TaskCategory, int>{
      for (final category in TaskCategory.values) category: 0,
    };

    for (final task in _tasks) {
      totals[task.category] = (totals[task.category] ?? 0) + 1;
    }

    return totals;
  }

  List<int> get weekCounts {
    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      return completedOn(date);
    });
  }

  int get totalCompleted {
    return _tasks.where((task) => task.isDone).length;
  }

  double get averageCompletedPerDay {
    final total = weekCounts.fold<int>(0, (sum, count) => sum + count);

    return total / 7;
  }

  String get productiveDay {
    const days = [
      'երկուշաբթի',
      'երեքշաբթի',
      'չորեքշաբթի',
      'հինգշաբթի',
      'ուրբաթ',
      'շաբաթ',
      'կիրակի',
    ];

    final counts = weekCounts;

    if (counts.every((count) => count == 0)) {
      return 'Դեռ ավարտված առաջադրանքներ չկան։';
    }

    final maxCount = counts.reduce((a, b) => a > b ? a : b);

    final index = counts.indexOf(maxCount);

    return '${days[index]}՝ $maxCount առաջադրանք';
  }
}
