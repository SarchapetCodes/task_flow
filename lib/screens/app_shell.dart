import 'package:flutter/material.dart';
import 'package:task_flow/screens/profile_screen.dart';

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
