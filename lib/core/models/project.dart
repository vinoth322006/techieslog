import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'base_model.dart';

class ProjectProgress {
  final String id;
  final String projectId;
  final int progressPercent;
  final String? notes;
  final DateTime recordedAt;

  ProjectProgress({
    required this.id,
    required this.projectId,
    required this.progressPercent,
    this.notes,
    required this.recordedAt,
  });

  factory ProjectProgress.fromMap(Map<String, dynamic> map) {
    return ProjectProgress(
      id: map['id'] as String,
      projectId: map['project_id'] as String,
      progressPercent: map['progress_percent'] as int,
      notes: map['notes'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'progress_percent': progressPercent,
      'notes': notes,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}

class ProjectLink {
  final String type; // github, linkedin, web, figma, notion, other
  final String url;
  final String? label;

  ProjectLink({
    required this.type,
    required this.url,
    this.label,
  });

  factory ProjectLink.fromMap(Map<String, dynamic> map) {
    return ProjectLink(
      type: map['type'] as String,
      url: map['url'] as String,
      label: map['label'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'url': url,
      'label': label,
    };
  }
}

class Project extends BaseModel {
  final String title;
  final String? description;
  final int status;
  final int progressPercent;
  final String? category; // e.g., Work, Personal, Learning, Creative
  final String? notes; // User notes about the project
  final int priority; // 1-5 priority level
  final DateTime? targetDate; // Target completion date
  final DateTime? startDate; // Project start date
  final int tasksCompleted; // Number of completed tasks
  final int totalTasks; // Total number of tasks
  final String? owner; // Project owner/lead
  final List<String>? tags; // Project tags
  final List<ProjectLink>? links; // GitHub, LinkedIn, Web, Figma, Notion links
  final List<ProjectProgress>? progressHistory; // Track progress over time

  Project({
    required String id,
    required this.title,
    this.description,
    this.status = 0,
    this.progressPercent = 0,
    this.category,
    this.notes,
    this.priority = 1,
    this.targetDate,
    this.startDate,
    this.tasksCompleted = 0,
    this.totalTasks = 0,
    this.owner,
    this.tags,
    this.links,
    this.progressHistory,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'] ?? 0,
      progressPercent: map['progress_percent'] ?? 0,
      category: map['category'] as String?,
      notes: map['notes'] as String?,
      priority: map['priority'] as int? ?? 1,
      targetDate: map['target_date'] != null ? DateTime.parse(map['target_date'] as String) : null,
      startDate: map['start_date'] != null ? DateTime.parse(map['start_date'] as String) : null,
      tasksCompleted: map['tasks_completed'] as int? ?? 0,
      totalTasks: map['total_tasks'] as int? ?? 0,
      owner: map['owner'] as String?,
      tags: map['tags'] != null
          ? (map['tags'] is String
              ? List<String>.from(jsonDecode(map['tags']) as List)
              : List<String>.from(map['tags'] as List))
          : null,
      links: map['links'] != null
          ? (map['links'] is String
              ? (jsonDecode(map['links']) as List)
                  .map((link) => ProjectLink.fromMap(link as Map<String, dynamic>))
                  .toList()
              : (map['links'] as List)
                  .map((link) => ProjectLink.fromMap(link as Map<String, dynamic>))
                  .toList())
          : null,
      progressHistory: map['progress_history'] != null
          ? (map['progress_history'] is String
              ? (jsonDecode(map['progress_history']) as List)
                  .map((progress) => ProjectProgress.fromMap(progress as Map<String, dynamic>))
                  .toList()
              : (map['progress_history'] as List)
                  .map((progress) => ProjectProgress.fromMap(progress as Map<String, dynamic>))
                  .toList())
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'progress_percent': progressPercent,
      'category': category,
      'notes': notes,
      'priority': priority,
      'target_date': targetDate?.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'tasks_completed': tasksCompleted,
      'total_tasks': totalTasks,
      'owner': owner,
      'tags': tags != null ? jsonEncode(tags) : null,
      'links': links != null ? jsonEncode(links!.map((link) => link.toMap()).toList()) : null,
      'progress_history': progressHistory != null ? jsonEncode(progressHistory!.map((progress) => progress.toMap()).toList()) : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    int? status,
    int? progressPercent,
    String? category,
    String? notes,
    int? priority,
    DateTime? targetDate,
    DateTime? startDate,
    int? tasksCompleted,
    int? totalTasks,
    String? owner,
    List<String>? tags,
    List<ProjectLink>? links,
    List<ProjectProgress>? progressHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      progressPercent: progressPercent ?? this.progressPercent,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      targetDate: targetDate ?? this.targetDate,
      startDate: startDate ?? this.startDate,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      totalTasks: totalTasks ?? this.totalTasks,
      owner: owner ?? this.owner,
      tags: tags ?? this.tags,
      links: links ?? this.links,
      progressHistory: progressHistory ?? this.progressHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
