import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isanosaurus/features/home/widgets/narration_header.dart';

class FakeNarration extends NarrationAudio {
  final positionEvents = StreamController<Duration>.broadcast();
  final durationEvents = StreamController<Duration>.broadcast();
  final completionEvents = StreamController<void>.broadcast();
  bool playing = false, disposed = false, fail = false;
  int loads = 0;
  Completer<void>? loading;
  @override
  Stream<Duration> get positions => positionEvents.stream;
  @override
  Stream<Duration> get durations => durationEvents.stream;
  @override
  Stream<void> get completed => completionEvents.stream;
  @override
  Future<void> load() async {
    loads++;
    if (fail) throw StateError('Cannot load');
    await loading?.future;
    durationEvents.add(const Duration(seconds: 90));
  }

  @override
  Future<void> resume() async {
    playing = true;
  }

  @override
  Future<void> pause() async {
    playing = false;
  }

  @override
  Future<void> stop() async {
    playing = false;
  }

  @override
  Future<void> dispose() async {
    playing = false;
    disposed = true;
    await positionEvents.close();
    await durationEvents.close();
    await completionEvents.close();
  }
}

void main() {
  late FakeNarration audio;
  setUp(() => audio = FakeNarration());
  Future<void> show(WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: NarrationHeader(audioFactory: () => audio),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> tap(WidgetTester tester, String tooltip) async {
    await tester.tap(find.byTooltip(tooltip));
    await tester.pumpAndSettle();
  }

  testWidgets('listen, pause, resume, complete, close and reopen', (
    tester,
  ) async {
    await show(tester);
    expect(find.byKey(const ValueKey('narration-bar')), findsNothing);
    expect(audio.loads, 0);
    await tap(tester, 'ฟังเสียงพากย์');
    expect(audio.playing, isTrue);
    audio.positionEvents.add(const Duration(seconds: 30));
    await tester.pumpAndSettle();
    expect(find.text('0:30 / 1:30'), findsOneWidget);
    await tap(tester, 'พักเสียงพากย์');
    expect(audio.playing, isFalse);
    await tap(tester, 'เล่นเสียงพากย์ต่อ');
    expect(audio.loads, 1);
    audio.completionEvents.add(null);
    await tester.pumpAndSettle();
    await tap(tester, 'เล่นเสียงพากย์ต่อ');
    expect(audio.loads, 2);
    await tap(tester, 'ปิดเสียงพากย์');
    expect(audio.playing, isFalse);
    expect(find.byKey(const ValueKey('narration-bar')), findsNothing);
    await tap(tester, 'ฟังเสียงพากย์');
    expect(audio.loads, 3);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    expect(audio.playing, isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(audio.disposed, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('closing while loading prevents delayed playback', (
    tester,
  ) async {
    audio.loading = Completer<void>();
    await show(tester);
    await tester.tap(find.byTooltip('ฟังเสียงพากย์'));
    await tester.pump();
    await tap(tester, 'ปิดเสียงพากย์');
    audio.loading!.complete();
    await tester.pumpAndSettle();
    expect(audio.playing, isFalse);
    expect(find.byKey(const ValueKey('narration-bar')), findsNothing);
  });

  testWidgets('load failure can be retried', (tester) async {
    audio.fail = true;
    await show(tester);
    await tap(tester, 'ฟังเสียงพากย์');
    expect(find.text('เล่นเสียงไม่ได้ กรุณาลองอีกครั้ง'), findsOneWidget);
    audio.fail = false;
    await tap(tester, 'ลองเล่นเสียงอีกครั้ง');
    expect(audio.playing, isTrue);
    expect(tester.takeException(), isNull);
  });
}
