import 'package:flutter/material.dart';
import 'package:flutter_expensenav/screens/expense_list_screen.dart';


void main() {
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Expense Naviga-Ror!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2e7d32),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFf1f8f1),
        useMaterial3: true,
      ),
     home: const ExpenseListScreen(),
    );
  }
}