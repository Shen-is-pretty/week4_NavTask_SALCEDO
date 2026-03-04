class Expense {
  final String title;
  final double amount;

  Expense({required this.title, required this.amount});

  Expense copyWith({String? title, double? amount}) {
    return Expense(
      title: title ?? this.title,
      amount: amount ?? this.amount,
    );
  }
}