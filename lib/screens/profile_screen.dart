import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/theme/app_theme.dart';

import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = context.select<UserProvider, String>(
      (provider) => provider.name,
    );

    final isDarkMode = context.select<ThemeProvider, bool>(
      (provider) => provider.isDarkMode,
    );

    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 35),

          Text(
            'Պրոֆիլ',
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.cardColor(context),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppTheme.green, width: 2),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppTheme.green,
              size: 55,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            userName,
            style: TextStyle(
              color: textColor,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Կազմակերպիր օրդ Task Flow-ի հետ',
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedColor),
          ),

          const SizedBox(height: 30),

          _ProfileTile(
            icon: Icons.person_outline,
            title: 'Անուն',
            subtitle: 'Փոխել անունը',
            onTap: () {
              final controller = TextEditingController(text: userName);

              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: const Text('Փոխել անունը'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Մուտքագրիր անունը',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Չեղարկել'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<UserProvider>().updateName(
                            controller.text,
                          );
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Պահպանել'),
                      ),
                    ],
                  );
                },
              ).then((_) => controller.dispose());
            },
          ),

          const SizedBox(height: 12),

          _ProfileTile(
            icon: Icons.notifications_outlined,
            title: 'Հիշեցումներ',
            subtitle: 'Առաջադրանքների հիշեցումներ',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Հիշեցումները դեռ պատրաստ չեն')),
              );
            },
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor(context)),
            ),
            child: SwitchListTile(
              secondary: const Icon(
                Icons.palette_outlined,
                color: AppTheme.green,
              ),
              title: Text(
                'Մուգ թեմա',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                isDarkMode ? 'Միացված է' : 'Անջատված է',
                style: TextStyle(color: mutedColor),
              ),
              value: isDarkMode,
              activeThumbColor: AppTheme.green,
              onChanged: (value) {
                context.read<ThemeProvider>().setDarkMode(value);
              },
            ),
          ),

          const SizedBox(height: 12),

          _ProfileTile(
            icon: Icons.info_outline,
            title: 'Հավելվածի մասին',
            subtitle: 'Task Flow',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Task Flow',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Կազմակերպիր օրդ։',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.textColor(context);
    final mutedColor = AppTheme.mutedColor(context);

    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.borderColor(context)),
      ),
      tileColor: AppTheme.surfaceColor(context),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.cardColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.green),
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: mutedColor, fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right, color: mutedColor),
    );
  }
}
