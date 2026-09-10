import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:isanosaurus/main.dart';
import 'package:isanosaurus/features/auth/login_page.dart';
import 'package:isanosaurus/features/home/home_page.dart';

void main() {
  testWidgets('onboarding opens login and back returns to onboarding', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('เริ่มสำรวจ'));
    await tester.tap(find.text('เริ่มสำรวจ'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('กลับ'));
    await tester.tap(find.byTooltip('กลับ'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('demo validates input and clears password after submission', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    final submit = find.widgetWithText(FilledButton, 'เข้าสู่ระบบ');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('กรุณากรอกอีเมล'), findsOneWidget);
    expect(find.text('กรุณากรอกรหัสผ่าน'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.enterText(find.byType(TextFormField).last, 'demo-password');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('กรุณากรอกอีเมลให้ถูกต้อง'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).first,
      'demo@example.com',
    );
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    Navigator.of(tester.element(find.byType(HomePage))).pop();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).last)
          .controller!
          .text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('guest bypasses validation on a small screen with keyboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    final guest = find.widgetWithText(
      OutlinedButton,
      'เข้าใช้งานแบบผู้เยี่ยมชม',
    );
    await tester.ensureVisible(guest);
    await tester.tap(guest);
    await tester.pumpAndSettle();
    expect(find.text('กรุณากรอกอีเมล'), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the onboarding screen as the first page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('ISANOSAURUS'), findsOneWidget);
    expect(find.text('ย้อนเวลาสู่โลก\nของอีสานโนซอรัส'), findsOneWidget);
    expect(find.text('เริ่มสำรวจ'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
