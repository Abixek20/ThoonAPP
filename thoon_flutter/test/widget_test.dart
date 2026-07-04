import 'package:flutter_test/flutter_test.dart';
import 'package:thoon_flutter/main.dart';

void main() {
  testWidgets('Thoon App splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ThoonApp());

    // Verify that Splash screen has loaded brand title
    expect(find.text('THOON'), findsOneWidget);
  });
}
