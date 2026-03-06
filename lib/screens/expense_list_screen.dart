import 'package:flutter/material.dart';
import 'package:flutter_expensenav/models/expense.dart';
import 'package:flutter_expensenav/widgets/expense_item.dart';
import 'package:flutter_expensenav/screens/expense_form_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final List<Expense> _expenses = [
    Expense(title: 'Groceries',            amount: 1200.00, date: DateTime(2026, 3, 1)),
    Expense(title: '2nd Semester Tuition', amount: 45000.00, date: DateTime(2026, 2, 28)),
    Expense(title: 'Shopping',             amount: 850.00,  date: DateTime(2026, 2, 25)),
    Expense(title: 'Daily Allowance',      amount: 150.00,  date: DateTime(2026, 2, 24)),
    Expense(title: 'Vacation Fund',        amount: 5000.00, date: DateTime(2026, 2, 20)),
    Expense(title: 'Electric Bill',        amount: 2300.00, date: DateTime(2026, 2, 15)),
    Expense(title: 'Transport Fare',       amount: 320.00,  date: DateTime(2026, 2, 10)),
  ];

 Future<void> _addExpense() async {
  final result = await Navigator.push<Expense>(
    context, MaterialPageRoute(builder: (_) => const ExpenseFormScreen()));
  if (result != null && mounted) {
    setState(() => _expenses.insert(0, result));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added: ${result.title}'),
      backgroundColor: const Color(0xFF2e7d32),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}

 Future<void> _editExpense(int index) async {
  final result = await Navigator.push<Expense>(
    context, MaterialPageRoute(builder: (_) => ExpenseFormScreen(existingExpense: _expenses[index])));
  if (result != null && mounted) {
    setState(() => _expenses[index] = result);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Updated: ${result.title}'),
      backgroundColor: const Color(0xFF388e3c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}

  void _deleteExpense(int index) {
    final removed = _expenses[index];
    setState(() => _expenses.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: Text('Deleted: ${removed.title}'),
  backgroundColor: const Color(0xFFc62828),
  behavior: SnackBarBehavior.floating,
  duration: const Duration(seconds: 1), // ← add this
  action: SnackBarAction(
    label: 'Undo',
    textColor: Colors.white,
    onPressed: () => setState(() => _expenses.insert(index, removed)),
  ),
));
  }

  // ── Part C: Empty state ──────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90, height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFe8f5e9), shape: BoxShape.circle),
            child: const Center(child: Text('🗒️', style: TextStyle(fontSize: 42))),
          ),
          const SizedBox(height: 20),
          const Text('No expenses yet',
            style: TextStyle(color: Color(0xFF1b5e20), fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Tap + to add one',
            style: TextStyle(color: Color(0xFF81c784), fontSize: 14)),
        ],
      ),
    );
  }

  // ── Part B: ListView.separated ───────────────────────────────────────────
  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      itemCount: _expenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
  return Dismissible(
    key: ValueKey(_expenses[index].title + _expenses[index].date.toString()),
    direction: DismissDirection.endToStart,
    onDismissed: (_) => _deleteExpense(index),
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFffebee),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFc62828), size: 26),
    ),
    child: ExpenseItem(
      expense: _expenses[index],
      onTap: () => _editExpense(index),
    ),
  );
},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFf1f8f1), Color(0xFFe8f5e9), Color(0xFFc8e6c9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(text: const TextSpan(
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900,
                          letterSpacing: -0.5, color: Color(0xFF1b5e20)),
                      children: [
                        TextSpan(text: 'My Expense '),
                        TextSpan(text: 'Naviga-Ror!',
                            style: TextStyle(color: Color(0xFF43a047))),
                      ],
                    )),
                    const SizedBox(height: 4),
                    Text(
                      _expenses.isEmpty
                          ? 'Start tracking your spending'
                          : '${_expenses.length} expense${_expenses.length != 1 ? 's' : ''} tracked',
                      style: const TextStyle(color: Color(0xFF66bb6a), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: Color(0xFFa5d6a7), thickness: 1),
              ),
              const SizedBox(height: 8),
              // Part B & C: list or empty state
              Expanded(child: _expenses.isEmpty ? _buildEmptyState() : _buildList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        backgroundColor: const Color(0xFF2e7d32),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}