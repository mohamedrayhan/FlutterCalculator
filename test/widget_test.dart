import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calculator/main.dart'; // Adjust this path if necessary

void main() {
  testWidgets('Calculator performs operations correctly', (WidgetTester tester) async {
    // Build the calculator app
    await tester.pumpWidget(CalculatorApp());

    // Verify that the initial display is '0'.
    expect(find.text('0'), findsOneWidget);

    // Input '5'
    await tester.tap(find.text('5'));
    await tester.pump();

    // Verify display shows '5'
    expect(find.text('5'), findsOneWidget);

    // Input '%'
    await tester.tap(find.text('%'));
    await tester.pump();

    // Verify output is correct after pressing '%'
    expect(find.text('0.05'), findsOneWidget); // Adjust based on expected behavior

    // Input '='
    await tester.tap(find.text('='));
    await tester.pump();

    // Verify output after pressing '='
    expect(find.text('0.05'), findsOneWidget); // Expected behavior for 5%
  });
}
