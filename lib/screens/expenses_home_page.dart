import 'package:flutter/material.dart';
import 'package:flutter_expensenav/models/expense.dart';
import 'package:flutter_expensenav/screens/add_expense_page.dart';

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  final List<Expense> _expenses = [
    Expense(title: 'Shopping', amount: 850.00),
    Expense(title: 'Groceries', amount: 1200.00),
    Expense(title: '2nd Semester Tuition', amount: 45000.00),
    Expense(title: 'Daily Allowance', amount: 150.00),
    Expense(title: 'Vacation Fund', amount: 5000.00),
  ];

  Future<void> _goToAddExpense() async {
    final Expense? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    if (result != null && mounted) {
      setState(() => _expenses.add(result));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added: ${result.title}'),
          backgroundColor: const Color(0xFF2e7d32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _goToEditExpense(int index) async {
    final Expense? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpensePage(existing: _expenses[index]),
      ),
    );

    if (result != null && mounted) {
      setState(() => _expenses[index] = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated: ${result.title}'),
          backgroundColor: const Color(0xFF388e3c),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  String _formatAmount(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '₱$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf1f8f1),
              Color(0xFFe8f5e9),
              Color(0xFFc8e6c9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: Color(0xFF1b5e20),
                        ),
                        children: [
                          TextSpan(text: 'My Expense '),
                          TextSpan(
                            text: 'Naviga-Ror!',
                            style: TextStyle(color: Color(0xFF43a047)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_expenses.length} expense${_expenses.length != 1 ? 's' : ''} tracked',
                      style: const TextStyle(
                        color: Color(0xFF66bb6a),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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

              // Expense List
              Expanded(
                child: _expenses.isEmpty
                    ? const Center(
                        child: Text(
                          'No expenses yet.\nTap + to get started.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF81c784),
                            fontSize: 15,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: _expenses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final expense = _expenses[index];
                          return GestureDetector(
                            onTap: () => _goToEditExpense(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF81c784).withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFe8f5e9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text('💸', style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense.title,
                                          style: const TextStyle(
                                            color: Color(0xFF1b5e20),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatAmount(expense.amount),
                                          style: const TextStyle(
                                            color: Color(0xFF43a047),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right,
                                      color: Color(0xFFa5d6a7), size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddExpense,
        backgroundColor: const Color(0xFF2e7d32),
        foregroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add),
      ),
    );
  }
}