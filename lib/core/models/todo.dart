class Todo {
  final String id;
  final String title;
  final String category;
  final int priority; // 1=Low, 2=Medium, 3=High
  final int status; // 0=Pending, 1=Completed
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;

  Todo({
    required this.id,
    required this.title,
    this.category = 'General',
    this.priority = 1,
    this.status = 0,
    this.dueDate,
    required this.createdAt,
    this.completedAt,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String? ?? 'General',
      priority: map['priority'] as int? ?? 1,
      status: map['status'] as int? ?? 0,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'priority': priority,
      'status': status,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? category,
    int? priority,
    int? status,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
