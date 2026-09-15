import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MovementVideoCard extends StatefulWidget {
  const MovementVideoCard({super.key});
  static const videoAsset = 'assets/videos/animation_video.mp4';

  @override
  State<MovementVideoCard> createState() => _MovementVideoCardState();
}

class _MovementVideoCardState extends State<MovementVideoCard>
    with WidgetsBindingObserver {
  static const _green = Color(0xFF2E6A43);
  VideoPlayerController? _controller;
  bool _loading = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && _controller != null) {
      _perform(() => _controller!.pause());
    }
  }

  Future<void> _perform(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _start() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _failed = false;
    });
    final previous = _controller;
    _controller = null;
    await _perform(() async {
      await previous?.dispose();
      if (!mounted) return;
      final controller = VideoPlayerController.asset(
        MovementVideoCard.videoAsset,
      );
      _controller = controller;
      await controller.initialize();
      if (!mounted) return;
      if (WidgetsBinding.instance.lifecycleState == null ||
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        await controller.play();
      }
    });
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  String _time(Duration value) =>
      '${value.inMinutes.toString().padLeft(2, '0')}:${(value.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'วีดีโอการเคลื่อนไหว',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF183022),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'สังเกตท่าทางและการเคลื่อนไหวของโมเดลไดโนเสาร์',
          style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF627268)),
        ),
        const SizedBox(height: 14),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDCE4DB)),
          ),
          child: controller != null && !_loading && !_failed
              ? ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => value.hasError
                      ? _placeholder(error: true)
                      : Column(
                          children: [
                            ColoredBox(
                              color: const Color(0xFF10271B),
                              child: AspectRatio(
                                aspectRatio: value.aspectRatio,
                                child: VideoPlayer(controller),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          backgroundColor: _green,
                                        ),
                                        tooltip: value.isPlaying
                                            ? 'หยุดชั่วคราว'
                                            : 'เล่นวิดีโอ',
                                        onPressed: () => _perform(() async {
                                          if (value.isPlaying) {
                                            await controller.pause();
                                          } else {
                                            if (value.position >=
                                                value.duration) {
                                              await controller.seekTo(
                                                Duration.zero,
                                              );
                                            }
                                            await controller.play();
                                          }
                                        }),
                                        icon: Icon(
                                          value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${_time(value.position)} / ${_time(value.duration)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: _green,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: value.volume == 0
                                            ? 'เปิดเสียง'
                                            : 'ปิดเสียง',
                                        onPressed: () => _perform(
                                          () => controller.setVolume(
                                            value.volume == 0 ? 1 : 0,
                                          ),
                                        ),
                                        icon: Icon(
                                          value.volume == 0
                                              ? Icons.volume_off_outlined
                                              : Icons.volume_up_outlined,
                                          color: _green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    semanticFormatterCallback: (v) => _time(
                                      Duration(milliseconds: v.round()),
                                    ),
                                    activeColor: _green,
                                    max: value.duration.inMilliseconds
                                        .toDouble()
                                        .clamp(1, double.infinity),
                                    value: value.position.inMilliseconds
                                        .toDouble()
                                        .clamp(
                                          0,
                                          value.duration.inMilliseconds
                                              .toDouble()
                                              .clamp(1, double.infinity),
                                        ),
                                    onChanged: (v) => _perform(
                                      () => controller.seekTo(
                                        Duration(milliseconds: v.round()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                )
              : _placeholder(error: _failed),
        ),
        const SizedBox(height: 10),
        const Text(
          'วิดีโอโมเดลประกอบการเรียนรู้ • แตะเล่นเพื่อเริ่มรับชม',
          style: TextStyle(fontSize: 11, height: 1.5, color: Color(0xFF627268)),
        ),
      ],
    );
  }

  Widget _placeholder({required bool error}) => Column(
    children: [
      AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEAF0E3),
            image: DecorationImage(
              image: AssetImage('assets/images/model2d.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: Center(
            child: _loading
                ? const CircularProgressIndicator(
                    semanticsLabel: 'กำลังเตรียมวิดีโอ',
                    color: _green,
                  )
                : IconButton.filled(
                    iconSize: 40,
                    style: IconButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                    tooltip: error
                        ? 'ลองโหลดวิดีโออีกครั้ง'
                        : 'เล่นวิดีโอการเคลื่อนไหว',
                    onPressed: _start,
                    icon: Icon(
                      error ? Icons.refresh : Icons.play_arrow_rounded,
                    ),
                  ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          error
              ? 'ไม่สามารถเล่นวิดีโอได้ กรุณาลองอีกครั้ง'
              : _loading
              ? 'กำลังเตรียมวิดีโอ…'
              : 'พร้อมสำรวจการเคลื่อนไหวแล้วหรือยัง?',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: _green),
        ),
      ),
    ],
  );
}
