import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/theme/app_theme.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const int dailyGoal = 5;

  @override
  Widget build(BuildContext context) {
    final completedToday = context.select<TaskProvider, int>(
      (provider) => provider.completedToday,
    );

    final totalCompleted = context.select<TaskProvider, int>(
      (provider) => provider.totalCompleted,
    );

    final averageCompleted = context.select<TaskProvider, double>(
      (provider) => provider.averageCompletedPerDay,
    );

    final completedThisWeek = context.select<TaskProvider, int>(
      (provider) => provider.completedThisWeek,
    );

    final weekCounts = context.select<TaskProvider, List<int>>(
      (provider) => provider.weekCounts,
    );

    final categoryCounts = context.select<TaskProvider, Map<TaskCategory, int>>(
      (provider) => provider.categoryCounts,
    );

    final productiveDay = context.select<TaskProvider, String>(
      (provider) => provider.productiveDay,
    );

    final goalProgress = (completedToday / dailyGoal).clamp(0.0, 1.0);

    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),

          Text(
            'Վիճակագրություն',
            style: TextStyle(
              color: textColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Հետևիր քո առաջընթացին',
            style: TextStyle(color: mutedColor, fontSize: 14),
          ),

          const SizedBox(height: 25),

          _buildGoalCard(context, completedToday, goalProgress),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Ընդհանուր',
                  '$totalCompleted',
                  Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Այս շաբաթ',
                  '$completedThisWeek',
                  Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Օրվա միջին',
                  averageCompleted.toStringAsFixed(1),
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Լավագույն օրը',
                  productiveDay,
                  Icons.star_outline,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Text(
            'Շաբաթվա առաջընթացը',
            style: TextStyle(
              color: textColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _buildWeekChart(context, weekCounts),

          const SizedBox(height: 25),

          Text(
            'Ըստ կատեգորիաների',
            style: TextStyle(
              color: textColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ...TaskCategory.values.map((category) {
            final count = categoryCounts[category] ?? 0;
            return _buildCategoryRow(context, category, count);
          }),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    int completedToday,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Օրվա նպատակը',
            style: TextStyle(
              color: AppTheme.textColor(context),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$completedToday / $dailyGoal առաջադրանք',
            style: TextStyle(color: AppTheme.mutedColor(context), fontSize: 14),
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppTheme.borderColor(context),
              valueColor: const AlwaysStoppedAnimation(AppTheme.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.green, size: 24),

          const SizedBox(height: 12),

          Text(
            value,
            style: TextStyle(
              color: AppTheme.textColor(context),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: TextStyle(color: AppTheme.mutedColor(context), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekChart(BuildContext context, List<int> weekCounts) {
    const days = ['Երկ', 'Երք', 'Չրք', 'Հնգ', 'Ուրբ', 'Շբթ', 'Կիր'];

    final maxCount = weekCounts.isEmpty
        ? 1
        : weekCounts.reduce((a, b) => a > b ? a : b).clamp(1, 1000000);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final count = index < weekCounts.length ? weekCounts[index] : 0;

          final height = 100.0 * count / maxCount;

          return Column(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  color: AppTheme.mutedColor(context),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: 22,
                height: height < 5 ? 5 : height,
                decoration: BoxDecoration(
                  color: AppTheme.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                days[index],
                style: TextStyle(
                  color: AppTheme.mutedColor(context),
                  fontSize: 10,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    TaskCategory category,
    int count,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.borderColor(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              category.label,
              style: TextStyle(
                color: AppTheme.textColor(context),
                fontSize: 14,
              ),
            ),
          ),

          Text(
            '$count',
            style: TextStyle(
              color: AppTheme.textColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
