import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  static const String _storageKey = 'saved_tasks';

  final List<TaskItem> _tasks = [];

  Future<void> _saveQueue = Future<void>.value();

  TaskFilter _filter = TaskFilter.all;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  TaskFilter get filter => _filter;

  List<TaskItem> get allTasks => List.unmodifiable(_tasks);

  int _completedToday = 0;
  int _totalToday = 0;
  int _completedThisWeek = 0;
  int _totalCompleted = 0;
  int _streak = 0;

  double _averageCompletedPerDay = 0;

  String _productiveDay = 'Դեռ ավարտված առաջադրանքներ չկան։';

  List<int> _weekCounts = List.filled(7, 0);

  Map<TaskCategory, int> _categoryCounts = {};
  Map<TaskCategory, int> _categoryTotals = {};

  int get completedToday => _completedToday;
  int get totalToday => _totalToday;

  double get progress => _totalToday == 0 ? 0 : _completedToday / _totalToday;

  int get completedThisWeek => _completedThisWeek;
  int get totalCompleted => _totalCompleted;
  int get streak => _streak;

  double get averageCompletedPerDay => _averageCompletedPerDay;

  String get productiveDay => _productiveDay;

  List<int> get weekCounts => List.unmodifiable(_weekCounts);

  Map<TaskCategory, int> get categoryCounts =>
      Map.unmodifiable(_categoryCounts);

  Map<TaskCategory, int> get categoryTotals =>
      Map.unmodifiable(_categoryTotals);

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTasks = prefs.getString(_storageKey);

      if (savedTasks != null) {
        final List<dynamic> decoded = jsonDecode(savedTasks);

        _tasks
          ..clear()
          ..addAll(
            decoded.map(
              (item) => TaskItem.fromJson(Map<String, dynamic>.from(item)),
            ),
          );
      }
    } catch (e) {
      debugPrint('Առաջադրանքները բեռնելու սխալ՝ $e');
    }

    _isLoaded = true;
    _recalculateStats();
    notifyListeners();
  }

  void _saveTasks() {
    _saveQueue = _saveQueue.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();

        final encoded = jsonEncode(
          _tasks.map((task) => task.toJson()).toList(),
        );

        await prefs.setString(_storageKey, encoded);
      } catch (e) {
        debugPrint('Առաջադրանքները պահպանելու սխալ՝ $e');
      }
    });
  }

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

  void _recalculateStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final start = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );

    final counts = List<int>.filled(7, 0);
    final weekdayCounts = List<int>.filled(7, 0);

    final categoryCounts = {
      for (final category in TaskCategory.values) category: 0,
    };

    final categoryTotals = {
      for (final category in TaskCategory.values) category: 0,
    };

    var completedToday = 0;
    var totalToday = 0;
    var completedThisWeek = 0;
    var totalCompleted = 0;

    final completedDays = <String, int>{};

    for (final task in _tasks) {
      if (_sameDay(task.dateTime, today)) {
        totalToday++;

        if (task.isDone) {
          completedToday++;
        }
      }

      categoryTotals[task.category] = (categoryTotals[task.category] ?? 0) + 1;

      if (!task.isDone || task.completedAt == null) {
        continue;
      }

      totalCompleted++;

      categoryCounts[task.category] = (categoryCounts[task.category] ?? 0) + 1;

      final completedAt = task.completedAt!;

      final completedDate = DateTime(
        completedAt.year,
        completedAt.month,
        completedAt.day,
      );

      final dayKey =
          '${completedDate.year}-${completedDate.month}-${completedDate.day}';

      completedDays[dayKey] = (completedDays[dayKey] ?? 0) + 1;

      weekdayCounts[completedDate.weekday - 1]++;

      final difference = completedDate.difference(start).inDays;

      if (difference >= 0 && difference < 7) {
        counts[difference]++;
        completedThisWeek++;
      }
    }

    int getCount(DateTime date) {
      final key = '${date.year}-${date.month}-${date.day}';
      return completedDays[key] ?? 0;
    }

    var streak = 0;
    var streakDate = today;

    if (getCount(streakDate) == 0) {
      streakDate = streakDate.subtract(const Duration(days: 1));
    }

    for (var i = 0; i < 365; i++) {
      if (getCount(streakDate) == 0) break;

      streak++;

      streakDate = streakDate.subtract(const Duration(days: 1));
    }

    const days = [
      'երկուշաբթի',
      'երեքշաբթի',
      'չորեքշաբթի',
      'հինգշաբթի',
      'ուրբաթ',
      'շաբաթ',
      'կիրակի',
    ];

    var productiveDay = 'Դեռ ավարտված առաջադրանքներ չկան։';

    if (weekdayCounts.any((count) => count > 0)) {
      final maxCount = weekdayCounts.reduce((a, b) => a > b ? a : b);

      final index = weekdayCounts.indexOf(maxCount);

      productiveDay = '${days[index]}՝ $maxCount առաջադրանք';
    }

    _completedToday = completedToday;
    _totalToday = totalToday;
    _completedThisWeek = completedThisWeek;
    _totalCompleted = totalCompleted;
    _streak = streak;
    _weekCounts = counts;
    _categoryCounts = categoryCounts;
    _categoryTotals = categoryTotals;

    _averageCompletedPerDay = completedThisWeek / 7;

    _productiveDay = productiveDay;
  }

  void setFilter(TaskFilter value) {
    if (_filter == value) return;

    _filter = value;
    notifyListeners();
  }

  void addTask(TaskItem task) {
    _tasks.insert(0, task);
    _filter = TaskFilter.all;

    _recalculateStats();
    notifyListeners();
    _saveTasks();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) return;

    final task = _tasks[index];
    final newDone = !task.isDone;

    _tasks[index] = task.copyWith(
      isDone: newDone,
      completedAt: newDone ? DateTime.now() : null,
      clearCompletedAt: !newDone,
    );

    _recalculateStats();
    notifyListeners();
    _saveTasks();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);

    _recalculateStats();
    notifyListeners();
    _saveTasks();
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
}
