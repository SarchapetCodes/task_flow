import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 35),
          const Text(
            'Պրոֆիլ',
            style: TextStyle(
              color: AppTheme.darkGreen,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.card,
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
          const Text(
            'Արեն',
            style: TextStyle(
              color: AppTheme.darkGreen,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Կազմակերպիր օրըդ Task Flow-ի հետ',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.muted),
          ),
          const SizedBox(height: 30),
          _ProfileTile(
            icon: Icons.notifications_outlined,
            title: 'Հիշեցումներ',
            subtitle: 'Առաջադրանքների հիշեցումներ',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Հիշեցումների կարգավորումը դեռ պատրաստ չէ'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _ProfileTile(
            icon: Icons.palette_outlined,
            title: 'Դիզայն',
            subtitle: 'Մուգ կանաչ թեմա',
            onTap: () {},
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
                applicationLegalese: 'Կազմակերպիր օրըդ։',
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
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.border),
      ),
      tileColor: AppTheme.surface,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.green),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.darkGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.muted, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.muted),
    );
  }
}
