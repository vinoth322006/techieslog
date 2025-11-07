import 'base_model.dart';

class Task extends BaseModel {
  final String title;
  final String? description;
  final int priority;
  final int status;
  final int? estimatedMinutes;
  final int actualMinutes;
  final DateTime? dueDate;
  final String? projectId;

  Task({
    required String id,
    required this.title,
    this.description,
    this.priority = 1,
    this.status = 0,
    this.estimatedMinutes,
    this.actualMinutes = 0,
    this.dueDate,
    this.projectId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'] ?? 1,
      status: map['status'] ?? 0,
      estimatedMinutes: map['estimated_minutes'],
      actualMinutes: map['actual_minutes'] ?? 0,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      projectId: map['project_id'],
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
      'priority': priority,
      'status': status,
      'estimated_minutes': estimatedMinutes,
      'actual_minutes': actualMinutes,
      'due_date': dueDate?.toIso8601String(),
      'project_id': projectId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
