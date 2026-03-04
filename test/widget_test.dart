import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_expensenav/main.dart';

void main() {
  testWidgets('Expense app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseApp());
    expect(find.text('TOTAL SPENT'), findsOneWidget);
  });
}