import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:isanosaurus/features/anatomy/widgets/movement_video_card.dart';

class FakeVideoPlatform extends VideoPlayerPlatform {
  final events = <int, StreamController<VideoEvent>>{};
  bool playing = false;
  bool fail = false;
  double volume = 1;
  Duration position = Duration.zero;
  String? asset;
  int disposed = 0;
  @override
  Future<void> init() async {}
  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async {
    asset = options.dataSource.asset;
    final id = events.length;
    final stream = StreamController<VideoEvent>();
    events[id] = stream;
    if (fail) {
      stream.addError(
        PlatformException(code: 'test_error', message: 'Video unavailable'),
      );
    } else {
      stream.add(
        VideoEvent(
          eventType: VideoEventType.initialized,
          duration: const Duration(seconds: 60),
          size: const Size(1920, 1080),
        ),
      );
    }
    return id;
  }

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) => events[playerId]!.stream;
  @override
  Future<void> dispose(int playerId) async {
    disposed++;
    await events[playerId]!.close();
  }

  @override
  Future<void> setLooping(int playerId, bool looping) async {}
  @override
  Future<void> play(int playerId) async {
    playing = true;
  }

  @override
  Future<void> pause(int playerId) async {
    playing = false;
  }

  @override
  Future<void> setVolume(int playerId, double volume) async {
    this.volume = volume;
  }

  @override
  Future<void> seekTo(int playerId, Duration position) async {
    this.position = position;
  }

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}
  @override
  Future<Duration> getPosition(int playerId) async => position;
  @override
  Widget buildViewWithOptions(VideoViewOptions options) => const SizedBox();
}

void main() {
  late FakeVideoPlatform platform;
  setUp(() {
    platform = FakeVideoPlatform();
    VideoPlayerPlatform.instance = platform;
  });

  Future<void> showCard(WidgetTester tester) async {
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
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: MovementVideoCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('เล่นวิดีโอการเคลื่อนไหว'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'video starts on demand, controls work and background pauses playback',
    (tester) async {
      await showCard(tester);
      expect(platform.asset, isNull);
      await tester.tap(find.byTooltip('เล่นวิดีโอการเคลื่อนไหว'));
      await tester.pumpAndSettle();
      expect(platform.asset, MovementVideoCard.videoAsset);
      expect(platform.playing, isTrue);
      await tester.ensureVisible(find.byTooltip('หยุดชั่วคราว'));
      await tester.tap(find.byTooltip('หยุดชั่วคราว'));
      await tester.pumpAndSettle();
      expect(platform.playing, isFalse);
      await tester.tap(find.byTooltip('ปิดเสียง'));
      await tester.pumpAndSettle();
      expect(platform.volume, 0);
      await tester.ensureVisible(find.byType(Slider));
      await tester.tap(find.byType(Slider));
      await tester.pumpAndSettle();
      expect(platform.position.inSeconds, greaterThan(0));
      await tester.tap(find.byTooltip('เล่นวิดีโอ'));
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();
      expect(platform.playing, isFalse);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(() async {});
      await tester.pumpAndSettle();
      expect(platform.disposed, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('failed video offers a working retry', (tester) async {
    platform.fail = true;
    await showCard(tester);
    await tester.tap(find.byTooltip('เล่นวิดีโอการเคลื่อนไหว'));
    await tester.pumpAndSettle();
    expect(
      find.text('ไม่สามารถเล่นวิดีโอได้ กรุณาลองอีกครั้ง'),
      findsOneWidget,
    );
    platform.fail = false;
    await tester.tap(find.byTooltip('ลองโหลดวิดีโออีกครั้ง'));
    await tester.runAsync(() async {});
    await tester.pumpAndSettle();
    expect(platform.playing, isTrue);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
