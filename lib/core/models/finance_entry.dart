class FinanceEntry {
  final String id;
  final DateTime entryDate;
  final int type; // 0=Expense, 1=Income
  final double amount;
  final String category;
  final String? subcategory;
  final String? description;
  final String? paymentMethod;
  final List<String>? tags;
  final bool isTechInvestment;
  final int? roiRating; // 1-5 for tech investments
  final DateTime createdAt;
  final DateTime updatedAt;

  FinanceEntry({
    required this.id,
    required this.entryDate,
    required this.type,
    required this.amount,
    required this.category,
    this.subcategory,
    this.description,
    this.paymentMethod,
    this.tags,
    this.isTechInvestment = false,
    this.roiRating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FinanceEntry.fromMap(Map<String, dynamic> map) {
    return FinanceEntry(
      id: map['id'] as String,
      entryDate: DateTime.parse(map['entry_date'] as String),
      type: map['type'] as int,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      subcategory: map['subcategory'] as String?,
      description: map['description'] as String?,
      paymentMethod: map['payment_method'] as String?,
      tags: map['tags_json'] != null 
          ? List<String>.from(map['tags_json'] as List) 
          : null,
      isTechInvestment: (map['is_tech_investment'] as int?) == 1,
      roiRating: map['roi_rating'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entry_date': entryDate.toIso8601String().split('T')[0],
      'type': type,
      'amount': amount,
      'category': category,
      'subcategory': subcategory,
      'description': description,
      'payment_method': paymentMethod,
      'tags_json': tags?.join(','),
      'is_tech_investment': isTechInvestment ? 1 : 0,
      'roi_rating': roiRating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
