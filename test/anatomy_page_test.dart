import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isanosaurus/features/anatomy/anatomy_page.dart';
import 'package:isanosaurus/features/home/home_page.dart';

void main() {
  testWidgets('home card and bottom menu open anatomy and return to home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    // First label is the shortcut card, last label is the fixed bottom menu.
    await tester.ensureVisible(find.text('กายวิภาค').first);
    await tester.tap(find.text('กายวิภาค').first);
    await tester.pumpAndSettle();
    expect(find.byType(AnatomyPage), findsOneWidget);
    await tester.tap(find.text('หน้าหลัก'));
    await tester.pumpAndSettle();
    expect(find.byType(AnatomyPage), findsNothing);
    await tester.tap(find.text('กายวิภาค').last);
    await tester.pumpAndSettle();
    expect(find.byType(AnatomyPage), findsOneWidget);
    Navigator.of(tester.element(find.byType(AnatomyPage))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('hotspots and chips stay synchronized at scale $scale', (
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
          home: const AnatomyPage(),
        ),
      );
      await tester.pumpAndSettle();
      const labels = ['หัว', 'คอ', 'ลำตัว', 'หาง', 'ขา'];
      for (var i = 0; i < labels.length; i++) {
        final hotspot = find.byTooltip('จุด ${i + 1}: ${labels[i]}');
        await tester.ensureVisible(hotspot);
        await tester.tap(hotspot);
        await tester.pumpAndSettle();
        final chip = find.widgetWithText(ChoiceChip, labels[i]);
        expect(tester.widget<ChoiceChip>(chip).selected, isTrue);
        final title = tester
            .widget<Text>(find.byKey(const ValueKey('anatomy-detail-title')))
            .data!;
        expect(title.startsWith('0${i + 1}'), isTrue);
      }
      final head = find.widgetWithText(ChoiceChip, 'หัว');
      await tester.ensureVisible(head);
      await tester.tap(head);
      await tester.pumpAndSettle();
      expect(find.text('01  ศีรษะ'), findsOneWidget);
      expect(tester.widget<ChoiceChip>(head).selected, isTrue);
      expect(find.text('หน้าหลัก').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
