// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:provider_state_management/main.dart';
import 'package:provider_state_management/providers/task_provider.dart';

void main() {
  testWidgets('adds, completes, and deletes a task', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('A clear page.'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(3));

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Plan the week');
    await tester.enterText(
      find.byType(TextFormField).last,
      'Choose the three most important priorities.',
    );
    await tester.tap(find.text('Add task').last);
    await tester.pumpAndSettle();

    expect(find.text('Plan the week'), findsOneWidget);
    expect(
      find.text('Choose the three most important priorities.'),
      findsOneWidget,
    );
    expect(find.text('IN PROGRESS'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2));

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.text('COMPLETED'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete task'));
    await tester.pumpAndSettle();
    expect(find.text('Plan the week'), findsNothing);
    expect(find.text('A clear page.'), findsOneWidget);
  });
}
