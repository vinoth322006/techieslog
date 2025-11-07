class Budget {
  final String id;
  final String category;
  final String? subcategory;
  final double amount;
  final String period; // monthly, weekly, yearly
  final bool rolloverUnused;
  final DateTime createdAt;
  final DateTime updatedAt;

  Budget({
    required this.id,
    required this.category,
    this.subcategory,
    required this.amount,
    this.period = 'monthly',
    this.rolloverUnused = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as String,
      category: map['category'] as String,
      subcategory: map['subcategory'] as String?,
      amount: (map['amount'] as num).toDouble(),
      period: map['period'] as String? ?? 'monthly',
      rolloverUnused: (map['rollover_unused'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'subcategory': subcategory,
      'amount': amount,
      'period': period,
      'rollover_unused': rolloverUnused ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
