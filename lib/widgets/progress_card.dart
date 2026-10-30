import 'package:flutter/material.dart';
import 'package:task_flow/theme/app_theme.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.done,
    required this.total,
    required this.progress,
  });

  final int done;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppTheme.borderColor(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Օրվա առաջընթացը',
                  style: TextStyle(color: mutedColor),
                ),
              ),
              Text(
                '$done/$total',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppTheme.borderColor(context),
              color: AppTheme.green,
            ),
          ),
        ],
      ),
    );
  }
}
