class Note {
  final String id;
  final String? title;
  final String content;
  final String type; // text, code, reflection
  final List<String>? tags;
  final String? linkedEntityType;
  final String? linkedEntityId;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    this.title,
    required this.content,
    this.type = 'text',
    this.tags,
    this.linkedEntityType,
    this.linkedEntityId,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      title: map['title'] as String?,
      content: map['content'] as String,
      type: map['type'] as String? ?? 'text',
      tags: map['tags_json'] != null 
          ? (map['tags_json'] as String).split(',').where((t) => t.isNotEmpty).toList()
          : null,
      linkedEntityType: map['linked_entity_type'] as String?,
      linkedEntityId: map['linked_entity_id'] as String?,
      isPinned: (map['is_pinned'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'tags_json': tags?.join(','),
      'linked_entity_type': linkedEntityType,
      'linked_entity_id': linkedEntityId,
      'is_pinned': isPinned ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
