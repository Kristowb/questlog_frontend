// This is a basic Flutter widget test for QuestLog.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
// This is a basic Flutter widget test for QuestLog.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:questlog_frontend/main.dart';
import 'package:questlog_frontend/screens/onboarding_screen.dart';

void main() {
  testWidgets('QuestLog App onboarding render smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuestLogApp());
    // Wait for animations from flutter_animate to complete.
    await tester.pumpAndSettle();

    // Verify that OnboardingScreen is rendered.
    expect(find.byType(OnboardingScreen), findsOneWidget);

    // Verify that the title and buttons of onboarding are present.
    expect(find.text('QUESTLOG'), findsOneWidget);
    expect(find.text('PETUALANGAN KEBUGARAN'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
  });
}
