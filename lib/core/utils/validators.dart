class Validators {
  static bool isValidTitle(String? value) {
    return value != null && value.trim().isNotEmpty && value.length <= 255;
  }

  static bool isValidDuration(int? minutes) {
    return minutes != null && minutes > 0 && minutes <= 1440; // 24 hours max
  }

  static bool isValidDate(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.isAfter(DateTime(2020)) && // reasonable minimum date
           date.isBefore(now.add(const Duration(days: 365 * 10))); // max 10 years ahead
  }

  static bool isValidPriority(int priority) {
    return priority >= 0 && priority <= 3;
  }

  static bool isValidStatus(int status) {
    return status >= 0 && status <= 3;
  }
}
