import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/pages/login_page.dart';

void main() {
  testWidgets('LoginPage has email & password fields and button', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // تأكّد من وجود حقلَي النص وزر الدخول
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
