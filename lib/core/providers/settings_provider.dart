import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Appearance
  bool _isDarkMode = false;
  String _accentColor = 'indigo';
  double _fontSize = 14.0;
  
  // Notifications
  bool _dailyReminder = true;
  String _reminderTime = '09:00';
  bool _habitReminders = true;
  bool _goalReminders = true;
  bool _taskReminders = true;
  
  // Finance
  String _currency = 'INR';
  String _currencySymbol = '₹';
  bool _showDecimalPlaces = true;
  
  // Privacy
  bool _requirePassword = false;
  bool _biometricAuth = false;
  
  // Data
  bool _autoBackup = false;
  int _backupFrequency = 7; // days
  
  // Display
  bool _showCompletedTasks = true;
  String _dateFormat = 'dd/MM/yyyy';
  String _timeFormat = '24h';
  bool _compactView = false;
  
  // Getters
  bool get isDarkMode => _isDarkMode;
  String get accentColor => _accentColor;
  double get fontSize => _fontSize;
  bool get dailyReminder => _dailyReminder;
  String get reminderTime => _reminderTime;
  bool get habitReminders => _habitReminders;
  bool get goalReminders => _goalReminders;
  bool get taskReminders => _taskReminders;
  String get currency => _currency;
  String get currencySymbol => _currencySymbol;
  bool get showDecimalPlaces => _showDecimalPlaces;
  bool get requirePassword => _requirePassword;
  bool get biometricAuth => _biometricAuth;
  bool get autoBackup => _autoBackup;
  int get backupFrequency => _backupFrequency;
  bool get showCompletedTasks => _showCompletedTasks;
  String get dateFormat => _dateFormat;
  String get timeFormat => _timeFormat;
  bool get compactView => _compactView;
  
  // Setters
  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setAccentColor(String value) {
    _accentColor = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setFontSize(double value) {
    _fontSize = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setDailyReminder(bool value) {
    _dailyReminder = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setReminderTime(String value) {
    _reminderTime = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setHabitReminders(bool value) {
    _habitReminders = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setGoalReminders(bool value) {
    _goalReminders = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setTaskReminders(bool value) {
    _taskReminders = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setCurrency(String value, String symbol) {
    _currency = value;
    _currencySymbol = symbol;
    _saveSettings();
    notifyListeners();
  }
  
  void setShowDecimalPlaces(bool value) {
    _showDecimalPlaces = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setRequirePassword(bool value) {
    _requirePassword = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setBiometricAuth(bool value) {
    _biometricAuth = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setAutoBackup(bool value) {
    _autoBackup = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setBackupFrequency(int value) {
    _backupFrequency = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setShowCompletedTasks(bool value) {
    _showCompletedTasks = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setDateFormat(String value) {
    _dateFormat = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setTimeFormat(String value) {
    _timeFormat = value;
    _saveSettings();
    notifyListeners();
  }
  
  void setCompactView(bool value) {
    _compactView = value;
    _saveSettings();
    notifyListeners();
  }
  
  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _accentColor = prefs.getString('accentColor') ?? 'indigo';
    _fontSize = prefs.getDouble('fontSize') ?? 14.0;
    _dailyReminder = prefs.getBool('dailyReminder') ?? true;
    _reminderTime = prefs.getString('reminderTime') ?? '09:00';
    _habitReminders = prefs.getBool('habitReminders') ?? true;
    _goalReminders = prefs.getBool('goalReminders') ?? true;
    _taskReminders = prefs.getBool('taskReminders') ?? true;
    _currency = prefs.getString('currency') ?? 'INR';
    _currencySymbol = prefs.getString('currencySymbol') ?? '₹';
    _showDecimalPlaces = prefs.getBool('showDecimalPlaces') ?? true;
    _requirePassword = prefs.getBool('requirePassword') ?? false;
    _biometricAuth = prefs.getBool('biometricAuth') ?? false;
    _autoBackup = prefs.getBool('autoBackup') ?? false;
    _backupFrequency = prefs.getInt('backupFrequency') ?? 7;
    _showCompletedTasks = prefs.getBool('showCompletedTasks') ?? true;
    _dateFormat = prefs.getString('dateFormat') ?? 'dd/MM/yyyy';
    _timeFormat = prefs.getString('timeFormat') ?? '24h';
    _compactView = prefs.getBool('compactView') ?? false;
    notifyListeners();
  }
  
  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('accentColor', _accentColor);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setBool('dailyReminder', _dailyReminder);
    await prefs.setString('reminderTime', _reminderTime);
    await prefs.setBool('habitReminders', _habitReminders);
    await prefs.setBool('goalReminders', _goalReminders);
    await prefs.setBool('taskReminders', _taskReminders);
    await prefs.setString('currency', _currency);
    await prefs.setString('currencySymbol', _currencySymbol);
    await prefs.setBool('showDecimalPlaces', _showDecimalPlaces);
    await prefs.setBool('requirePassword', _requirePassword);
    await prefs.setBool('biometricAuth', _biometricAuth);
    await prefs.setBool('autoBackup', _autoBackup);
    await prefs.setInt('backupFrequency', _backupFrequency);
    await prefs.setBool('showCompletedTasks', _showCompletedTasks);
    await prefs.setString('dateFormat', _dateFormat);
    await prefs.setString('timeFormat', _timeFormat);
    await prefs.setBool('compactView', _compactView);
  }
  
  // Reset all settings
  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isDarkMode = false;
    _accentColor = 'indigo';
    _fontSize = 14.0;
    _dailyReminder = true;
    _reminderTime = '09:00';
    _habitReminders = true;
    _goalReminders = true;
    _taskReminders = true;
    _currency = 'INR';
    _currencySymbol = '₹';
    _showDecimalPlaces = true;
    _requirePassword = false;
    _biometricAuth = false;
    _autoBackup = false;
    _backupFrequency = 7;
    _showCompletedTasks = true;
    _dateFormat = 'dd/MM/yyyy';
    _timeFormat = '24h';
    _compactView = false;
    notifyListeners();
  }
}
