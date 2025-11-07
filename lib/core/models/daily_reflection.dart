import 'base_model.dart';

class DailyReflection extends BaseModel {
  final String content;
  final int mood;
  final List<String> tags;

  DailyReflection({
    required String id,
    required this.content,
    required this.mood,
    required this.tags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory DailyReflection.fromMap(Map<String, dynamic> map) {
    return DailyReflection(
      id: map['id'],
      content: map['content'],
      mood: map['mood'],
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'mood': mood,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
