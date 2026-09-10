import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isanosaurus/features/home/home_page.dart';
import 'package:isanosaurus/features/anatomy/anatomy_page.dart';
import 'package:isanosaurus/features/timeline/timeline_page.dart';

void main() {
  testWidgets('timeline opens from both entry points and tabs do not stack', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('ไทม์ไลน์').first);
    await tester.tap(find.text('ไทม์ไลน์').first);
    await tester.pumpAndSettle();
    expect(find.byType(TimelinePage), findsOneWidget);
    await tester.tap(find.text('หน้าหลัก'));
    await tester.pumpAndSettle();
    expect(find.byType(TimelinePage), findsNothing);
    await tester.tap(find.text('ไทม์ไลน์').last);
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('กายวิภาค'));
      await tester.pumpAndSettle();
      expect(find.byType(AnatomyPage), findsOneWidget);
      await tester.tap(find.text('ไทม์ไลน์'));
      await tester.pumpAndSettle();
      expect(find.byType(TimelinePage), findsOneWidget);
    }
    Navigator.of(tester.element(find.byType(TimelinePage))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(AnatomyPage), findsNothing);
    expect(find.byType(TimelinePage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'timeline fits small screens with large text and keeps navigation visible',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: const TimelinePage(),
        ),
      );
      await tester.pumpAndSettle();
      final dates = [
        'ประมาณ 210 ล้านปีก่อน',
        'พ.ศ. 2541',
        'พ.ศ. 2543',
        'ปัจจุบัน',
      ];
      var previous = double.negativeInfinity;
      for (final date in dates) {
        final y = tester.getTopLeft(find.text(date)).dy;
        expect(y, greaterThan(previous));
        previous = y;
      }
      await tester.ensureVisible(find.text('ปัจจุบัน'));
      await tester.pumpAndSettle();
      expect(find.text('หน้าหลัก').hitTestable(), findsOneWidget);
      await tester.tap(find.text('เพิ่มเติม'));
      await tester.pumpAndSettle();
      expect(find.text('เพิ่มเติม จะเปิดให้ใช้งานเร็ว ๆ นี้'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
