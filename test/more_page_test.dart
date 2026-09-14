import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isanosaurus/features/home/home_page.dart';
import 'package:isanosaurus/features/more/more_page.dart';
import 'package:isanosaurus/features/anatomy/anatomy_page.dart';
import 'package:isanosaurus/features/timeline/timeline_page.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('catalog filters and mock quantities calculate correctly', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MorePage()));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNWidgets(4));
    await tapVisible(tester, find.byTooltip('เพิ่ม ISANOSAURUS Tee'));
    await tapVisible(tester, find.byTooltip('เพิ่ม ISANOSAURUS Tee'));
    await tapVisible(tester, find.widgetWithText(ChoiceChip, 'เข็มกลัด'));
    expect(find.text('ISANOSAURUS Tee'), findsNothing);
    expect(find.text('Fossil Pin'), findsOneWidget);
    await tapVisible(tester, find.byTooltip('เพิ่ม Fossil Pin'));
    expect(find.text('เลือกทั้งหมด 3 ชิ้น • ฿900'), findsOneWidget);
    await tapVisible(tester, find.byTooltip('ลด Fossil Pin'));
    expect(find.text('เลือกทั้งหมด 2 ชิ้น • ฿780'), findsOneWidget);
    for (final entry in {
      'เสื้อ': 'ISANOSAURUS Tee',
      'โปสการ์ด': 'Cretaceous Card',
      'สมุด': 'Dino Notebook',
    }.entries) {
      await tapVisible(tester, find.widgetWithText(ChoiceChip, entry.key));
      expect(find.text(entry.value), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    }
    await tapVisible(tester, find.text('ล้างรายการที่เลือก'));
    expect(find.byKey(const ValueKey('selection-summary')), findsNothing);
    await tapVisible(tester, find.widgetWithText(ChoiceChip, 'ทั้งหมด'));
    expect(find.byType(Image), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('more navigation replaces tabs and resets temporary selection', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('เพิ่มเติม'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byTooltip('เพิ่ม ISANOSAURUS Tee'));
    for (final label in ['กายวิภาค', 'ไทม์ไลน์']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(
        find.byType(label == 'กายวิภาค' ? AnatomyPage : TimelinePage),
        findsOneWidget,
      );
      await tester.tap(find.text('เพิ่มเติม'));
      await tester.pumpAndSettle();
      expect(find.byType(MorePage), findsOneWidget);
      expect(find.byKey(const ValueKey('selection-summary')), findsNothing);
    }
    await tester.tap(find.text('หน้าหลัก'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(HomePage))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('more scrolls on small screens with large text', (tester) async {
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
        home: const MorePage(),
      ),
    );
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byTooltip('เพิ่ม Dino Notebook'));
    await tester.ensureVisible(find.byKey(const ValueKey('selection-summary')));
    await tester.pumpAndSettle();
    expect(find.text('เลือกทั้งหมด 1 ชิ้น • ฿149'), findsOneWidget);
    expect(find.text('หน้าหลัก').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
