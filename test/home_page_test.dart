import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isanosaurus/features/home/home_page.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('home scrolls without overflow at text scale $scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<Image>(find.byType(Image)).image,
        const AssetImage(HomePage.dinosaurImageAsset),
      );
      await tester.ensureVisible(find.text('เรื่องน่ารู้'));
      await tester.pumpAndSettle();
      expect(find.text('หน้าหลัก').hitTestable(), findsOneWidget);
      await tester.tap(find.text('เพิ่มเติม'));
      await tester.pumpAndSettle();
      expect(find.text('เพิ่มเติม จะเปิดให้ใช้งานเร็ว ๆ นี้'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
