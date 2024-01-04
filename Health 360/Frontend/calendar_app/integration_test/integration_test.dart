import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:integration_test/integration_test.dart';
import 'package:Health_Guardian/main.dart' as app;
import 'package:Health_Guardian/Analytics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//to run full file,type in terminal -> flutter test integration_test/integration_test.dart
//to run a group->
//to run a test - >
// https://www.youtube.com/watch?v=WPEsnJgW99M
// run each group individually

//Element Finder
final goToTask = find.widgetWithText(ElevatedButton, 'Go to Task Page');
final goToLogin = find.widgetWithText(ElevatedButton, 'Go to Login Page');
final helloUser = find.widgetWithText(Text, 'Hello');
final calendarIcon = find.byIcon(Icons.calendar_month_outlined);
final resultIcon = find.byIcon(Icons.list_alt_outlined);
final loginButton = find.textContaining('Login');
final selected_date = find.textContaining('Selected Date');

final sortBy_Dropdown = find.textContaining('Sort By');

final backArrow = find.byIcon(Icons.arrow_back);
final analytics_icon = find.byIcon(Icons.analytics);
final total_tasks_key = find.byKey(totalTaskKey);
final avgPHQKey_key = find.byKey(avgPHQKey);
final avgSleepKey_key = find.byKey(avgSleepKey);
final PHQScore_key = find.byKey(PHQScoreKey);
final SleepScore_key = find.byKey(SleepScoreKey);
final phq_ot_key = find.byKey(SleepScoreKey);
final sleep_ot_key = find.byKey(SleepScoreKey);

void main() {
  TaskPageTest();
  CalendarPageTest();
  AnalyticsPageTest();
  ResultsPageTest();

}

Future<void> TaskPageTest() async {
  group('Login Page', () {
    //  Add the IntegrationTestWidgetsFlutterBinding and .ensureInitialized
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    //  Create your test case
    testWidgets("Task Page Opening", (tester) async {
      //  execute the app.main() function
      app.main();
      // Wait until the app has settled
      await tester.pumpAndSettle();
      await tester.tap(goToLogin);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'skulkarni');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'suny123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.textContaining('Hello'), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(calendarIcon);
      await tester.pumpAndSettle();
      expect(selected_date, findsOneWidget);
      await tester.pumpAndSettle();

      // TODO 13: Check the semantics of the checkbox if it is not checked
    });
  });
}


Future<void> CalendarPageTest() async {
  group('Calendar Page ', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets("Calendar", (tester) async {
      //  execute the app.main() function
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(goToLogin);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'skulkarni');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'suny123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(calendarIcon);
      await tester.pumpAndSettle();
      expect(selected_date, findsOneWidget);
      // print("DONE");
      await tester.pumpAndSettle();
      await tester.tap(backArrow);
      await tester.pumpAndSettle();
      expect(find.textContaining('Hello'), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}

Future<void> AnalyticsPageTest() async {
  group('Analytics Page', () {
    //  Add the IntegrationTestWidgetsFlutterBinding and .ensureInitialized
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    //  Create your test case
    testWidgets("Analytics Charts  Displayed", (tester) async {
      //  execute the app.main() function
      app.main();
      // Wait until the app has settled
      await tester.pumpAndSettle();
      await tester.tap(goToLogin);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'skulkarni');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'suny123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(analytics_icon);
      await tester.pumpAndSettle();

      expect(total_tasks_key, findsOneWidget);
      expect(avgPHQKey_key, findsOneWidget);
      expect(avgSleepKey_key, findsOneWidget);
      expect(PHQScore_key, findsOneWidget);
      expect(phq_ot_key, findsOneWidget);
      expect(SleepScore_key, findsOneWidget);
      expect(sleep_ot_key, findsOneWidget);
      await tester.pumpAndSettle();

    });
  });
}


Future<void> ResultsPageTest() async {
  group('Results Page', () {
    //  Add the IntegrationTestWidgetsFlutterBinding and .ensureInitialized
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    //  Create your test case
    testWidgets("Results", (tester) async {
      //  execute the app.main() function
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(goToLogin);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'skulkarni');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'suny123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(resultIcon);
      await tester.pumpAndSettle();
      expect(sortBy_Dropdown, findsOneWidget);
      await tester.pumpAndSettle();
      final dropdownButton = find.byType(DropdownButton);
      await tester.tap(backArrow);
      await tester.pumpAndSettle();
      expect(find.textContaining('Hello'), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}

