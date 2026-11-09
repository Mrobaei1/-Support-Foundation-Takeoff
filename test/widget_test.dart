import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:support_foundation_takeoff/main.dart';

void main() {
  testWidgets('shows offline takeoff home page', (tester) async {
    await tester.pumpWidget(const SupportFoundationApp());
    await tester.pumpAndSettle();

    expect(find.text('متره فونداسیون ساپورت‌ها'), findsOneWidget);
    expect(find.text('پروژه خط لوله پروپان'), findsOneWidget);
    expect(find.text('176'), findsOneWidget);
  });

  testWidgets('search filters support identifiers', (tester) async {
    await tester.pumpWidget(const SupportFoundationApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), 'SU-034');
    await tester.pump();

    expect(find.text('SU-034'), findsOneWidget);
    expect(find.text('SU-035'), findsNothing);
  });
}
