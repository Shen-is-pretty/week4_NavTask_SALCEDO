import 'package:flutter/material.dart';

const List<String> kCategories = [
  'Food',
  'Transport',
  'Shopping',
  'School',
  'Bills',
  'Travel',
  'Health',
  'General',
];

String categoryIcon(String category) {
  switch (category) {
    case 'Food':      return '🛒';
    case 'Transport': return '🚌';
    case 'Shopping':  return '🛍️';
    case 'School':    return '🎓';
    case 'Bills':     return '💡';
    case 'Travel':    return '✈️';
    case 'Health':    return '💊';
    default:          return '💸';
  }
}

Color categoryColor(String category) {
  switch (category) {
    case 'Food':      return const Color(0xFF2e7d32);
    case 'Transport': return const Color(0xFF388e3c);
    case 'Shopping':  return const Color(0xFF43a047);
    case 'School':    return const Color(0xFF1b5e20);
    case 'Bills':     return const Color(0xFF66bb6a);
    case 'Travel':    return const Color(0xFF81c784);
    case 'Health':    return const Color(0xFF4caf50);
    default:          return const Color(0xFF2e7d32);
  }
}