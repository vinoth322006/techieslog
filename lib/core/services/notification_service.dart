import 'package:flutter/material.dart';

/// Notification service with SnackBars and scheduled tasks
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  static void setScaffoldMessengerKey(GlobalKey<ScaffoldMessengerState> key) {
    _scaffoldMessengerKey = key;
  }

  Future<void> initialize() async {
    // Notification service initialized
    // Android permissions are handled in AndroidManifest.xml
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    _showSnackBar('$title\n$body');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final delay = scheduledDate.difference(DateTime.now());
    if (delay.isNegative) return;

    Future.delayed(delay, () {
      _showSnackBar('$title\n$body');
    });
  }

  Future<void> cancelNotification(int id) async {
    // Notification cancelled
  }

  Future<void> cancelAllNotifications() async {
    // All notifications cancelled
  }

  void _showSnackBar(String message) {
    if (_scaffoldMessengerKey?.currentState != null) {
      _scaffoldMessengerKey!.currentState!.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xFF6366F1),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  // Convenience methods
  Future<void> showDailyReminder() async {
    await showNotification(
      id: 1,
      title: '📅 Daily Reminder',
      body: 'Time to check your productivity goals!',
    );
  }

  Future<void> showHabitReminder(String habitName) async {
    await showNotification(
      id: 2,
      title: '🔥 Habit Reminder',
      body: 'Don\'t forget to complete: $habitName',
    );
  }

  Future<void> showTaskReminder(String taskName) async {
    await showNotification(
      id: 3,
      title: '✅ Task Reminder',
      body: 'You have a pending task: $taskName',
    );
  }

  Future<void> showGoalReminder(String goalName) async {
    await showNotification(
      id: 4,
      title: '🎯 Goal Reminder',
      body: 'Keep working towards: $goalName',
    );
  }

  Future<void> showFinanceReminder(String message) async {
    await showNotification(
      id: 5,
      title: '💰 Finance Alert',
      body: message,
    );
  }

  Future<void> scheduleDailyReminder(NotificationTime time) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await scheduleNotification(
      id: 100,
      title: '📅 Daily Reminder',
      body: 'Time to check your productivity goals!',
      scheduledDate: scheduledDate,
    );
  }
}

class NotificationTime {
  final int hour;
  final int minute;

  NotificationTime({required this.hour, required this.minute});

  factory NotificationTime.fromString(String time) {
    final parts = time.split(':');
    return NotificationTime(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
