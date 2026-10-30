import 'package:flutter/material.dart';
import 'package:task_flow/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.index,
    required this.onTap,
    required this.onAdd,
  });

  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, int i) {
      return IconButton(
        onPressed: () => onTap(i),
        icon: Icon(
          icon,
          size: 21,
          color: index == i ? AppTheme.green : AppTheme.mutedColor(context),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderColor(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            item(Icons.format_list_bulleted, 0),
            item(Icons.calendar_month_outlined, 1),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.green,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                onPressed: onAdd,
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 27,
                ),
              ),
            ),
            item(Icons.bar_chart_rounded, 3),
            item(Icons.person_outline, 4),
          ],
        ),
      ),
    );
  }
}
