import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  bool _dailyReminder = true;
  String _reminderTime = '09:00';
  bool _habitReminders = true;
  bool _goalReminders = true;
  bool _taskReminders = true;
  bool _financeReminders = true;

  final NotificationService _notificationService = NotificationService();

  // Getters
  bool get dailyReminder => _dailyReminder;
  String get reminderTime => _reminderTime;
  bool get habitReminders => _habitReminders;
  bool get goalReminders => _goalReminders;
  bool get taskReminders => _taskReminders;
  bool get financeReminders => _financeReminders;

  // Setters with notification triggers
  void setDailyReminder(bool value) {
    _dailyReminder = value;
    if (value) {
      _notificationService.showDailyReminder();
      _scheduleDailyReminder();
    } else {
      _notificationService.cancelNotification(100);
    }
    _saveSettings();
    notifyListeners();
  }

  void setReminderTime(String value) {
    _reminderTime = value;
    if (_dailyReminder) {
      _scheduleDailyReminder();
    }
    _saveSettings();
    notifyListeners();
  }

  void setHabitReminders(bool value) {
    _habitReminders = value;
    if (value) {
      _notificationService.showHabitReminder('Your daily habit');
    }
    _saveSettings();
    notifyListeners();
  }

  void setGoalReminders(bool value) {
    _goalReminders = value;
    if (value) {
      _notificationService.showGoalReminder('Your goal');
    }
    _saveSettings();
    notifyListeners();
  }

  void setTaskReminders(bool value) {
    _taskReminders = value;
    if (value) {
      _notificationService.showTaskReminder('Your task');
    }
    _saveSettings();
    notifyListeners();
  }

  void setFinanceReminders(bool value) {
    _financeReminders = value;
    if (value) {
      _notificationService.showFinanceReminder('Check your budget');
    }
    _saveSettings();
    notifyListeners();
  }

  void _scheduleDailyReminder() {
    final time = NotificationTime.fromString(_reminderTime);
    _notificationService.scheduleDailyReminder(time);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyReminder = prefs.getBool('dailyReminder') ?? true;
    _reminderTime = prefs.getString('reminderTime') ?? '09:00';
    _habitReminders = prefs.getBool('habitReminders') ?? true;
    _goalReminders = prefs.getBool('goalReminders') ?? true;
    _taskReminders = prefs.getBool('taskReminders') ?? true;
    _financeReminders = prefs.getBool('financeReminders') ?? true;
    
    // Schedule daily reminder if enabled
    if (_dailyReminder) {
      _scheduleDailyReminder();
    }
    
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyReminder', _dailyReminder);
    await prefs.setString('reminderTime', _reminderTime);
    await prefs.setBool('habitReminders', _habitReminders);
    await prefs.setBool('goalReminders', _goalReminders);
    await prefs.setBool('taskReminders', _taskReminders);
    await prefs.setBool('financeReminders', _financeReminders);
  }
}
