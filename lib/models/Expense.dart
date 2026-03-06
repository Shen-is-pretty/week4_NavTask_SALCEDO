class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    String? id,
    required this.title,
    required this.amount,
    String? category,
    DateTime? date,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        category = category ?? 'General',
        date = date ?? DateTime.now();

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}