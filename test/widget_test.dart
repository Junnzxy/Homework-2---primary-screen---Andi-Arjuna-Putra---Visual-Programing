import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('SmartHomeScreen renders header and metrics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Andi Arjuna'), findsOneWidget);
    expect(find.text('Quick Modes'), findsOneWidget);
    expect(find.text('Active Devices'), findsOneWidget);
  });
}
