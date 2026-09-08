import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:isanosaurus/main.dart';

void main() {
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
