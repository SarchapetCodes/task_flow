import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/models/task.dart';

import '../providers/task_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const Color background = Color(0xFF0B201D);
  static const Color cardColor = Color(0xFF14352F);
  static const Color mutedColor = Color(0xFF8CB6AA);
  static const Color mintColor = Color(0xFF50D1B2);

  static const List<String> days = [
    'Երկ',
    'Երք',
    'Չոր',
    'Հնգ',
    'Ուրբ',
    'Շաբ',
    'Կիր',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final week = provider.weekCounts;
    final today = DateTime.now();

    final maxCount = week.fold<int>(
      1,
      (max, value) => value > max ? value : max,
    );

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Վիճակագրություն',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Շաբաթվա\nընթացքում',
                      value: '${provider.completedThisWeek}',
                      subtitle: 'Ավարտած\nառաջադրանք',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Շարք',
                      value: '${provider.streak} օր',
                      subtitle: 'Անընդմեջ օրերի\nշարք',
                      highlight: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Այս շաբաթ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Նպատակ՝ 5/օր',
                          style: TextStyle(color: mutedColor, fontSize: 10),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      height: 150,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (index) {
                          final day = provider.weekStart.add(
                            Duration(days: index),
                          );

                          final count = week[index];

                          final isToday =
                              day.year == today.year &&
                              day.month == today.month &&
                              day.day == today.day;

                          final height = count == 0
                              ? 5.0
                              : 85.0 * count / maxCount;

                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$count',
                                  style: TextStyle(
                                    color: isToday ? mintColor : mutedColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: height,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isToday
                                            ? mintColor
                                            : const Color(0xFF32685C),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  days[index],
                                  style: TextStyle(
                                    color: isToday ? Colors.white : mutedColor,
                                    fontSize: 10,
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

              const SizedBox(height: 20),

              const Text(
                'Ըստ կատեգորիաների',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              ...TaskCategory.values.map((category) {
                final count = provider.categoryCounts[category] ?? 0;

                final total = provider.categoryTotals[category] ?? 0;

                final progress = total == 0 ? 0.0 : count / total;

                final percentage = (progress * 100).round();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 19),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          Text(
                            '$count · $percentage%',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: const Color(0xFF244941),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            category.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 2),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2923),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_outline,
                      color: Color(0xFFFFC857),
                      size: 23,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Ամենաարդյունավետ օրը՝\n'
                        '${provider.productiveDay}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    this.highlight = false,
  });

  final String title;
  final String value;
  final String subtitle;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StatisticsScreen.cardColor,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8DCDBB),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              color: highlight ? const Color(0xFFFFC857) : Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            style: const TextStyle(
              color: StatisticsScreen.mutedColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
