import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Օրվա առաջընթացը',
                  style: TextStyle(color: AppTheme.muted),
                ),
              ),
              Text(
                '$done/$total',
                style: const TextStyle(
                  color: AppTheme.darkGreen,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppTheme.border,
              color: AppTheme.green,
            ),
          ),
        ],
      ),
    );
  }
}
