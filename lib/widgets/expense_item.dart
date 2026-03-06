import 'package:flutter/material.dart';
import 'package:flutter_expensenav/models/expense.dart';

/// Reusable widget that renders a single expense row using Card + ListTile.
/// Displays: title, formatted amount, and date (e.g. "Mar 12").
class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseItem({
    super.key,
    required this.expense,
    this.onTap,
  });

  /// Maps expense title keywords to a category emoji icon.
  String get _categoryEmoji {
    final t = expense.title.toLowerCase();
    if (t.contains('grocery') || t.contains('food') || t.contains('meal')) return '🛒';
    if (t.contains('shopping') || t.contains('cloth') || t.contains('buy')) return '🛍️';
    if (t.contains('tuition') || t.contains('school') || t.contains('study')) return '🎓';
    if (t.contains('transport') || t.contains('commut') || t.contains('fare')) return '🚌';
    if (t.contains('vacation') || t.contains('travel') || t.contains('trip')) return '✈️';
    if (t.contains('allowance') || t.contains('daily')) return '💰';
    if (t.contains('electric') || t.contains('bill') || t.contains('water')) return '💡';
    if (t.contains('health') || t.contains('medic') || t.contains('pharma')) return '💊';
    return '💸';
  }

  /// Formats the date as "Mar 12" or "Dec 5".
  String get _formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[expense.date.month - 1]} ${expense.date.day}';
  }

  /// Formats amount as ₱1,200.00
  String get _formattedAmount {
    final formatted = expense.amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '₱$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFe8f5e9), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: const Color(0xFFc8e6c9),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          // Leading: category icon badge
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFe8f5e9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(_categoryEmoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          // Title: expense name
          title: Text(
            expense.title,
            style: const TextStyle(
              color: Color(0xFF1b5e20),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Subtitle: date (e.g. "Mar 12")
          subtitle: Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 11, color: Color(0xFF81c784)),
              const SizedBox(width: 4),
              Text(
                _formattedDate,
                style: const TextStyle(
                  color: Color(0xFF81c784),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Trailing: amount + chevron
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formattedAmount,
                    style: const TextStyle(
                      color: Color(0xFF2e7d32),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFFa5d6a7), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
