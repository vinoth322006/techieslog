import 'package:intl/intl.dart';

class DailyLog {
  final String id;
  final DateTime logDate;
  final String logTime; // HH:mm format
  final String category;
  final String title;
  final String? content;
  final String? mood; // happy, neutral, sad, excited, stressed, etc.
  final List<String>? tags;
  final String? linkedEntityType; // task, project, goal, etc.
  final String? linkedEntityId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyLog({
    required this.id,
    required this.logDate,
    required this.logTime,
    required this.category,
    required this.title,
    this.content,
    this.mood,
    this.tags,
    this.linkedEntityType,
    this.linkedEntityId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      id: map['id'] as String,
      logDate: DateTime.parse(map['log_date'] as String),
      logTime: map['log_time'] as String,
      category: map['category'] as String,
      title: map['title'] as String,
      content: map['content'] as String?,
      mood: map['mood'] as String?,
      tags: map['tags_json'] != null 
          ? (map['tags_json'] as String).split(',').where((t) => t.isNotEmpty).toList()
          : null,
      linkedEntityType: map['linked_entity_type'] as String?,
      linkedEntityId: map['linked_entity_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'log_date': DateFormat('yyyy-MM-dd').format(logDate),
      'log_time': logTime,
      'category': category,
      'title': title,
      'content': content,
      'mood': mood,
      'tags_json': tags?.join(','),
      'linked_entity_type': linkedEntityType,
      'linked_entity_id': linkedEntityId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DailyLog copyWith({
    String? id,
    DateTime? logDate,
    String? logTime,
    String? category,
    String? title,
    String? content,
    String? mood,
    List<String>? tags,
    String? linkedEntityType,
    String? linkedEntityId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyLog(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      logTime: logTime ?? this.logTime,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      linkedEntityType: linkedEntityType ?? this.linkedEntityType,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper to get formatted date and time
  String get formattedDateTime {
    return '${DateFormat('MMM d, y').format(logDate)} at $logTime';
  }

  // Helper to get just the date
  String get formattedDate {
    return DateFormat('MMM d, y').format(logDate);
  }
}

// Predefined categories for logs
class LogCategories {
  static const String work = 'Work';
  static const String study = 'Study';
  static const String personal = 'Personal';
  static const String health = 'Health';
  static const String social = 'Social';
  static const String achievement = 'Achievement';
  static const String challenge = 'Challenge';
  static const String idea = 'Idea';
  static const String gratitude = 'Gratitude';
  static const String reflection = 'Reflection';
  static const String other = 'Other';

  static List<String> get all => [
    work,
    study,
    personal,
    health,
    social,
    achievement,
    challenge,
    idea,
    gratitude,
    reflection,
    other,
  ];

  static String getIcon(String category) {
    switch (category) {
      case work:
        return '💼';
      case study:
        return '📚';
      case personal:
        return '👤';
      case health:
        return '💪';
      case social:
        return '👥';
      case achievement:
        return '🏆';
      case challenge:
        return '⚡';
      case idea:
        return '💡';
      case gratitude:
        return '🙏';
      case reflection:
        return '🤔';
      default:
        return '📝';
    }
  }
}

// Predefined moods
class LogMoods {
  static const String happy = 'Happy';
  static const String excited = 'Excited';
  static const String calm = 'Calm';
  static const String neutral = 'Neutral';
  static const String tired = 'Tired';
  static const String stressed = 'Stressed';
  static const String sad = 'Sad';
  static const String anxious = 'Anxious';
  static const String motivated = 'Motivated';
  static const String grateful = 'Grateful';

  static List<String> get all => [
    happy,
    excited,
    calm,
    neutral,
    tired,
    stressed,
    sad,
    anxious,
    motivated,
    grateful,
  ];

  static String getEmoji(String mood) {
    switch (mood) {
      case happy:
        return '😊';
      case excited:
        return '🤩';
      case calm:
        return '😌';
      case neutral:
        return '😐';
      case tired:
        return '😴';
      case stressed:
        return '😰';
      case sad:
        return '😢';
      case anxious:
        return '😟';
      case motivated:
        return '💪';
      case grateful:
        return '🙏';
      default:
        return '😊';
    }
  }
}
