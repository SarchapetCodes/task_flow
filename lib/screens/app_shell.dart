import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_flow/screens/profile_screen.dart';
import 'package:task_flow/theme/app_theme.dart';

import '../providers/task_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'add_task_screen.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    CalendarScreen(),
    SizedBox.shrink(),
    StatisticsScreen(),
    ProfileScreen(),
  ];

  void openAddTask() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoaded = context.select<TaskProvider, bool>(
      (provider) => provider.isLoaded,
    );

    if (!isLoaded) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor(context),
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.green),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: currentIndex, children: screens),
      ),
      bottomNavigationBar: BottomNavBar(
        index: currentIndex,
        onTap: (index) {
          if (index == 2) {
            openAddTask();
          } else {
            setState(() => currentIndex = index);
          }
        },
        onAdd: openAddTask,
      ),
    );
  }
}
