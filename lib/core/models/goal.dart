import 'dart:convert';
import 'package:flutter/foundation.dart';

class GoalProgress {
  final String id;
  final String goalId;
  final double value;
  final String? notes;
  final DateTime recordedAt;

  GoalProgress({
    required this.id,
    required this.goalId,
    required this.value,
    this.notes,
    required this.recordedAt,
  });

  factory GoalProgress.fromMap(Map<String, dynamic> map) {
    return GoalProgress(
      id: map['id'] as String,
      goalId: map['goal_id'] as String,
      value: (map['value'] as num).toDouble(),
      notes: map['notes'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal_id': goalId,
      'value': value,
      'notes': notes,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}

class Goal {
  final String id;
  final String title;
  final String? description;
  final String? category;
  final String? type; // learning, financial, personal, project
  final double? targetValue;
  final double currentValue;
  final DateTime? targetDate;
  final int progressPercent;
  final int status; // 0=Not Started, 1=In Progress, 2=Completed, 3=Abandoned
  final String? unit; // e.g., kg, miles, dollars, books
  final int priority; // 1-5 priority level
  final String? notes; // User notes about the goal
  final int? milestonesCompleted; // Number of completed milestones
  final int? totalMilestones; // Total number of milestones
  final bool isPublic; // Whether goal is public/shared
  final List<GoalProgress>? progressHistory; // Track progress over time
  final String? reason; // Why this goal matters
  final String? strategy; // How to achieve this goal
  final int? frequency; // How often to update (days)
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.type,
    this.targetValue,
    this.currentValue = 0,
    this.targetDate,
    this.progressPercent = 0,
    this.status = 0,
    this.unit,
    this.priority = 1,
    this.notes,
    this.milestonesCompleted,
    this.totalMilestones,
    this.isPublic = false,
    this.progressHistory,
    this.reason,
    this.strategy,
    this.frequency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromMap(Map<String, dynamic> map) {
    List<GoalProgress>? progressHistory;
    if (map['progress_history'] != null) {
      final historyData = map['progress_history'];
      if (historyData is String) {
        try {
          final decoded = jsonDecode(historyData) as List;
          progressHistory = decoded
              .map((p) => GoalProgress.fromMap(p as Map<String, dynamic>))
              .toList();
        } catch (e) {
          debugPrint('Error decoding progress_history: $e');
        }
      } else if (historyData is List) {
        progressHistory = historyData
            .map((p) => GoalProgress.fromMap(p as Map<String, dynamic>))
            .toList();
      }
    }

    return Goal(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String?,
      type: map['type'] as String?,
      targetValue: map['target_value'] != null ? (map['target_value'] as num).toDouble() : null,
      currentValue: (map['current_value'] as num?)?.toDouble() ?? 0,
      targetDate: map['target_date'] != null ? DateTime.parse(map['target_date'] as String) : null,
      progressPercent: map['progress_percent'] as int? ?? 0,
      status: map['status'] as int? ?? 0,
      unit: map['unit'] as String?,
      priority: map['priority'] as int? ?? 1,
      notes: map['notes'] as String?,
      milestonesCompleted: map['milestones_completed'] as int?,
      totalMilestones: map['total_milestones'] as int?,
      isPublic: (map['is_public'] as int?) == 1,
      progressHistory: progressHistory,
      reason: map['reason'] as String?,
      strategy: map['strategy'] as String?,
      frequency: map['frequency'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'type': type,
      'target_value': targetValue,
      'current_value': currentValue,
      'target_date': targetDate?.toIso8601String(),
      'progress_percent': progressPercent,
      'status': status,
      'unit': unit,
      'priority': priority,
      'notes': notes,
      'milestones_completed': milestonesCompleted,
      'total_milestones': totalMilestones,
      'is_public': isPublic ? 1 : 0,
      'progress_history': progressHistory != null
          ? jsonEncode(progressHistory!.map((p) => p.toMap()).toList())
          : null,
      'reason': reason,
      'strategy': strategy,
      'frequency': frequency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? type,
    double? targetValue,
    double? currentValue,
    DateTime? targetDate,
    int? progressPercent,
    int? status,
    String? unit,
    int? priority,
    String? notes,
    int? milestonesCompleted,
    int? totalMilestones,
    bool? isPublic,
    List<GoalProgress>? progressHistory,
    String? reason,
    String? strategy,
    int? frequency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      targetDate: targetDate ?? this.targetDate,
      progressPercent: progressPercent ?? this.progressPercent,
      status: status ?? this.status,
      unit: unit ?? this.unit,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      milestonesCompleted: milestonesCompleted ?? this.milestonesCompleted,
      totalMilestones: totalMilestones ?? this.totalMilestones,
      isPublic: isPublic ?? this.isPublic,
      progressHistory: progressHistory ?? this.progressHistory,
      reason: reason ?? this.reason,
      strategy: strategy ?? this.strategy,
      frequency: frequency ?? this.frequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
