class Habit {
  final String id;
  final String title;
  final String? description;
  final String frequency; // daily, weekly, custom
  final int targetCount;
  final String? reminderTime;
  final int streakCurrent;
  final int streakLongest;
  final String? linkedGoalId;
  final DateTime? lastCheckIn; // Track last check-in for productivity
  final int totalCheckIns; // Total number of check-ins
  final String? category; // e.g., Health, Productivity, Learning, Fitness
  final String? notes; // User notes about the habit
  final int priority; // 1-5 priority level
  final String? icon; // Icon name for habit
  final bool isActive; // Whether habit is active
  final DateTime? targetDate; // Target completion date
  final DateTime createdAt;
  final DateTime updatedAt;

  Habit({
    required this.id,
    required this.title,
    this.description,
    this.frequency = 'daily',
    this.targetCount = 1,
    this.reminderTime,
    this.streakCurrent = 0,
    this.streakLongest = 0,
    this.linkedGoalId,
    this.lastCheckIn,
    this.totalCheckIns = 0,
    this.category,
    this.notes,
    this.priority = 1,
    this.icon,
    this.isActive = true,
    this.targetDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      frequency: map['frequency'] as String? ?? 'daily',
      targetCount: map['target_count'] as int? ?? 1,
      reminderTime: map['reminder_time'] as String?,
      streakCurrent: map['streak_current'] as int? ?? 0,
      streakLongest: map['streak_longest'] as int? ?? 0,
      linkedGoalId: map['linked_goal_id'] as String?,
      lastCheckIn: map['last_check_in'] != null ? DateTime.parse(map['last_check_in'] as String) : null,
      totalCheckIns: map['total_check_ins'] as int? ?? 0,
      category: map['category'] as String?,
      notes: map['notes'] as String?,
      priority: map['priority'] as int? ?? 1,
      icon: map['icon'] as String?,
      isActive: (map['is_active'] as int?) == 1,
      targetDate: map['target_date'] != null ? DateTime.parse(map['target_date'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'frequency': frequency,
      'target_count': targetCount,
      'reminder_time': reminderTime,
      'streak_current': streakCurrent,
      'streak_longest': streakLongest,
      'linked_goal_id': linkedGoalId,
      'last_check_in': lastCheckIn?.toIso8601String(),
      'total_check_ins': totalCheckIns,
      'category': category,
      'notes': notes,
      'priority': priority,
      'icon': icon,
      'is_active': isActive ? 1 : 0,
      'target_date': targetDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    String? frequency,
    int? targetCount,
    String? reminderTime,
    int? streakCurrent,
    int? streakLongest,
    String? linkedGoalId,
    DateTime? lastCheckIn,
    int? totalCheckIns,
    String? category,
    String? notes,
    int? priority,
    String? icon,
    bool? isActive,
    DateTime? targetDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      reminderTime: reminderTime ?? this.reminderTime,
      streakCurrent: streakCurrent ?? this.streakCurrent,
      streakLongest: streakLongest ?? this.streakLongest,
      linkedGoalId: linkedGoalId ?? this.linkedGoalId,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HabitCheck {
  final String id;
  final String habitId;
  final DateTime checkDate;
  final bool completed;
  final String? notes;
  final DateTime createdAt;

  HabitCheck({
    required this.id,
    required this.habitId,
    required this.checkDate,
    this.completed = false,
    this.notes,
    required this.createdAt,
  });

  factory HabitCheck.fromMap(Map<String, dynamic> map) {
    return HabitCheck(
      id: map['id'] as String,
      habitId: map['habit_id'] as String,
      checkDate: DateTime.parse(map['check_date'] as String),
      completed: (map['completed'] as int?) == 1,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'check_date': checkDate.toIso8601String().split('T')[0],
      'completed': completed ? 1 : 0,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
