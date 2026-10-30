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
    final provider = context.watch<TaskProvider>();

    final totalCompleted = provider.totalCompleted;
    final streak = provider.streak;
    final weekCounts = provider.weekCounts;
    final categoryTotals = provider.categoryTotals;
    final productiveDay = provider.productiveDay;

    final totalTasks = categoryTotals.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );

    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);

    final todayIndex = DateTime.now().weekday - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: textColor,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Վիճակագրություն',
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // STAT CARDS
          Row(
            children: [
              Expanded(
                child: _statCard(
                  context,
                  title: 'ԸՆԴՀԱՆՈՒՐ\nԱՌԱՋԱԴՐԱՆՔՆԵՐ',
                  value: '$totalCompleted',
                  subtitle: 'ավարտված\nառաջադրանք',
                  valueColor: textColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  context,
                  title: 'ՇԱՐՈՒՆԱԿԱԿԱՆ\nԱԿՏԻՎՈՒԹՅՈՒՆ',
                  value: '$streak օր',
                  subtitle: 'առանց բաց թողնելու',
                  valueColor: const Color(0xFFFFC15A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // WEEK CHART
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.cardColor(context),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.borderColor(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Այս շաբաթ',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Նպատակ՝ $dailyGoal/օր',
                      style: TextStyle(
                        color: AppTheme.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                SizedBox(
                  height: 155,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final count = weekCounts[index];

                      final height = count == 0
                          ? 8.0
                          : (count / 8).clamp(0.12, 1.0) * 115;

                      final isToday = index == todayIndex;

                      const days = [
                        'Երկ',
                        'Երք',
                        'Չրք',
                        'Հնգ',
                        'Ուրբ',
                        'Շբթ',
                        'Կիր',
                      ];

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Spacer(),

                            Container(
                              width: 32,
                              height: height,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? AppTheme.green
                                    : AppTheme.green.withValues(alpha: 0.30),
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              days[index],
                              style: TextStyle(
                                color: isToday ? textColor : mutedColor,
                                fontSize: 11,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // CATEGORY STATISTICS
          Text(
            'Ըստ կատեգորիաների',
            style: TextStyle(
              color: textColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ...TaskCategory.values.map((category) {
            final count = categoryTotals[category] ?? 0;

            final percentage = totalTasks == 0 ? 0.0 : count / totalTasks;

            return _categoryProgress(
              context,
              title: category.label,
              count: count,
              percentage: percentage,
              color: category.color,
              totalTasks: totalTasks,
            );
          }),

          const SizedBox(height: 22),

          // MOTIVATION CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.cardColor(context),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppTheme.borderColor(context)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.star_outline,
                  color: Color(0xFFFFC15A),
                  size: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    totalCompleted == 0
                        ? 'Սկսիր քո առաջին առաջադրանքից։ Ամեն փոքր քայլ կարևոր է։'
                        : 'Ամենաարդյունավետ օրն է՝ $productiveDay։ Շարունակի՛ր նույն ոգով։',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STAT CARD
  Widget _statCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required Color valueColor,
  }) {
    return Container(
      height: 185,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppTheme.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppTheme.mutedColor(context),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.mutedColor(context),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // CATEGORY PROGRESS
  Widget _categoryProgress(
    BuildContext context, {
    required String title,
    required int count,
    required double percentage,
    required Color color,
    required int totalTasks,
  }) {
    final percent = (percentage * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textColor(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$count · $percent%',
                style: TextStyle(
                  color: AppTheme.mutedColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 11,
              backgroundColor: AppTheme.borderColor(context),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
