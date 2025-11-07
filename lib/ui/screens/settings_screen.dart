import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/notification_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NotificationProvider>(context, listen: false).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? const Color(0xFFF1F5F9) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Theme Section
          _buildSectionHeader(context, 'Theme', Icons.palette),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF475569) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: SwitchListTile(
                  secondary: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                    style: TextStyle(
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) async {
                    await themeProvider.toggleTheme();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value ? '🌙 Dark mode enabled' : '☀️ Light mode enabled',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          duration: const Duration(milliseconds: 800),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionHeader(context, 'Notifications', Icons.notifications),
          Consumer<NotificationProvider>(
            builder: (context, notifProvider, _) {
              return Column(
                children: [
                  _buildNotificationTile(
                    context,
                    Icons.alarm,
                    Colors.blue,
                    'Daily Reminder',
                    'Get daily productivity reminders at ${notifProvider.reminderTime}',
                    notifProvider.dailyReminder,
                    (value) {
                      notifProvider.setDailyReminder(value);
                      _showSnackBar(context, value ? '✓ Daily reminders enabled' : '✗ Daily reminders disabled');
                    },
                    isDark,
                  ),
                  _buildNotificationTile(
                    context,
                    Icons.local_fire_department,
                    Colors.orange,
                    'Habit Reminders',
                    'Remind me about my habits',
                    notifProvider.habitReminders,
                    (value) {
                      notifProvider.setHabitReminders(value);
                      _showSnackBar(context, value ? '✓ Habit reminders enabled' : '✗ Habit reminders disabled');
                    },
                    isDark,
                  ),
                  _buildNotificationTile(
                    context,
                    Icons.task_alt,
                    Colors.green,
                    'Task Reminders',
                    'Remind me about pending tasks',
                    notifProvider.taskReminders,
                    (value) {
                      notifProvider.setTaskReminders(value);
                      _showSnackBar(context, value ? '✓ Task reminders enabled' : '✗ Task reminders disabled');
                    },
                    isDark,
                  ),
                  _buildNotificationTile(
                    context,
                    Icons.flag,
                    Colors.purple,
                    'Goal Reminders',
                    'Remind me about my goals',
                    notifProvider.goalReminders,
                    (value) {
                      notifProvider.setGoalReminders(value);
                      _showSnackBar(context, value ? '✓ Goal reminders enabled' : '✗ Goal reminders disabled');
                    },
                    isDark,
                  ),
                  _buildNotificationTile(
                    context,
                    Icons.attach_money,
                    Colors.amber,
                    'Finance Reminders',
                    'Remind me about budget limits',
                    notifProvider.financeReminders,
                    (value) {
                      notifProvider.setFinanceReminders(value);
                      _showSnackBar(context, value ? '✓ Finance reminders enabled' : '✗ Finance reminders disabled');
                    },
                    isDark,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About', Icons.info),
          
          // Logo and App Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.hourglass_bottom, size: 80);
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'TechLog',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete Productivity Hub',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          
          _buildInfoTile(context, Icons.app_settings_alt, 'App Version', '1.0.0 (Build 1)', isDark),
          const SizedBox(height: 24),

          // Help Section
          _buildSectionHeader(context, 'Help & Support', Icons.help),
          _buildActionTile(
            context,
            Icons.bug_report,
            'Report a Bug',
            'Help us improve the app',
            () {
              _showSnackBar(context, '✓ Thank you for helping us improve!');
            },
            isDark,
          ),
          _buildActionTile(
            context,
            Icons.star,
            'Rate This App',
            'Share your feedback on app store',
            () {
              _showSnackBar(context, '⭐ Thank you for your support!');
            },
            isDark,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF475569) : const Color(0xFFE5E7EB),
        ),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: iconColor, size: 28),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF475569) : const Color(0xFFE5E7EB),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF475569) : const Color(0xFFE5E7EB),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
