import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isanosaurus/features/auth/login_page.dart';
import 'package:isanosaurus/features/auth/register_page.dart';

void main() {
  Future<void> openRegistration(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    final link = find.text('ยังไม่มีบัญชี? สมัครสมาชิก');
    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);
  }

  Future<void> submit(WidgetTester tester) async {
    final button = find.widgetWithText(FilledButton, 'สมัครสมาชิก');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('registration requires valid fields and explicit consent', (
    tester,
  ) async {
    await openRegistration(tester);
    await submit(tester);
    expect(find.text('กรุณากรอกชื่อผู้ใช้'), findsOneWidget);
    expect(find.text('กรุณากรอกอีเมล'), findsOneWidget);
    expect(find.text('กรุณากรอกรหัสผ่าน'), findsOneWidget);
    expect(
      find.text('กรุณายอมรับเงื่อนไขก่อนทดลองสมัครสมาชิก'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('ชื่อผู้ใช้')),
      'นักสำรวจ',
    );
    await tester.enterText(find.byKey(const ValueKey('อีเมล')), 'invalid');
    await tester.enterText(find.byKey(const ValueKey('รหัสผ่าน')), 'short');
    await submit(tester);
    expect(find.text('กรุณากรอกอีเมลให้ถูกต้อง'), findsOneWidget);
    expect(find.text('รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('อีเมล')),
      'demo@example.com',
    );
    await tester.enterText(find.byKey(const ValueKey('รหัสผ่าน')), 'demo-pass');
    await submit(tester);
    expect(find.byType(RegisterPage), findsOneWidget);
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await submit(tester);
    expect(find.byType(RegisterPage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(
      find.text('ทดลองสมัครสมาชิกสำเร็จ ไม่มีการสร้างบัญชีหรือบันทึกข้อมูล'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('ยังไม่มีบัญชี? สมัครสมาชิก'));
    await tester.tap(find.text('ยังไม่มีบัญชี? สมัครสมาชิก'));
    await tester.pumpAndSettle();
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.controller.text, isEmpty);
    }
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('registration back and login link return to the existing login', (
    tester,
  ) async {
    await openRegistration(tester);
    await tester.ensureVisible(find.byTooltip('กลับ'));
    await tester.tap(find.byTooltip('กลับ'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsNothing);
    await tester.ensureVisible(find.text('ยังไม่มีบัญชี? สมัครสมาชิก'));
    await tester.tap(find.text('ยังไม่มีบัญชี? สมัครสมาชิก'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('มีบัญชีอยู่แล้ว? เข้าสู่ระบบ'));
    await tester.tap(find.text('มีบัญชีอยู่แล้ว? เข้าสู่ระบบ'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(RegisterPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'small-screen keyboard supports scrolling, password visibility and terms',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.5)),
            child: child!,
          ),
          home: const RegisterPage(),
        ),
      );
      await tester.enterText(
        find.byKey(const ValueKey('รหัสผ่าน')),
        'demo-pass',
      );
      await tester.ensureVisible(find.byTooltip('แสดงรหัสผ่าน'));
      await tester.tap(find.byTooltip('แสดงรหัสผ่าน'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
        isFalse,
      );
      await tester.ensureVisible(find.text('อ่านเงื่อนไขสำหรับโหมดทดลอง'));
      await tester.tap(find.text('อ่านเงื่อนไขสำหรับโหมดทดลอง'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('ปิด'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
        isFalse,
      );
      await submit(tester);
      expect(tester.takeException(), isNull);
    },
  );
}
