import 'base_model.dart';

class StudySession extends BaseModel {
  final String topic;
  final int durationMinutes;
  final int focusLevel;
  final String notes;

  StudySession({
    required String id,
    required this.topic,
    required this.durationMinutes,
    required this.focusLevel,
    required this.notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'],
      topic: map['topic'],
      durationMinutes: map['durationMinutes'],
      focusLevel: map['focusLevel'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'durationMinutes': durationMinutes,
      'focusLevel': focusLevel,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
