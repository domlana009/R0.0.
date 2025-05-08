import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/report_page.dart';

void main() {
  testWidgets('App starts and shows login page', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });

  testWidgets('LoginPage has two text fields and two buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Créer un compte'), findsOneWidget);
  });

  testWidgets('ReportPage shows input fields and submission button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: ReportPage()));

    expect(find.widgetWithText(TextField, 'عنوان التقرير'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'محتوى التقرير'), findsOneWidget);
    expect(find.text('إرسال التقرير'), findsOneWidget);
  });
}
