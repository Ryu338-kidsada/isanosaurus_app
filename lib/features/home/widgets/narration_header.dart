import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Small interface so playback controls can be tested without a native device.
abstract class NarrationAudio {
  Stream<Duration> get positions;
  Stream<Duration> get durations;
  Stream<void> get completed;
  Future<void> load();
  Future<void> resume();
  Future<void> pause();
  Future<void> stop();
  Future<void> dispose();
}

class _AssetNarrationAudio implements NarrationAudio {
  final _player = AudioPlayer();
  @override
  Stream<Duration> get positions => _player.onPositionChanged;
  @override
  Stream<Duration> get durations => _player.onDurationChanged;
  @override
  Stream<void> get completed => _player.onPlayerComplete;
  @override
  Future<void> load() => _player.setSource(AssetSource('sounds/sound2.wav'));
  @override
  Future<void> resume() => _player.resume();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> dispose() => _player.dispose();
}

class NarrationHeader extends StatefulWidget {
  const NarrationHeader({super.key, this.audioFactory});
  final NarrationAudio Function()? audioFactory;
  @override
  State<NarrationHeader> createState() => NarrationHeaderState();
}

class NarrationHeaderState extends State<NarrationHeader>
    with WidgetsBindingObserver {
  static const _green = Color(0xFF2E6A43);
  NarrationAudio? _audio;
  final _subscriptions = <StreamSubscription<dynamic>>[];
  Future<void> _pending = Future.value();
  bool _visible = false, _busy = false, _playing = false, _ready = false;
  bool _failed = false;
  int _generation = 0;
  Duration _position = Duration.zero, _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _enqueue(Future<void> Function() action) {
    _pending = _pending.then((_) => action()).catchError((Object error) {
      if (mounted && _visible) {
        setState(() {
          _failed = true;
          _busy = false;
          _playing = false;
          _ready = false;
        });
      }
    });
    return _pending;
  }

  void _update(VoidCallback update) {
    if (mounted) setState(update);
  }

  void _toggle() {
    if (_busy) return;
    if (_playing) {
      _pause();
      return;
    }
    final generation = ++_generation;
    setState(() {
      _visible = true;
      _busy = true;
      _failed = false;
    });
    _enqueue(() async {
      if (!mounted || generation != _generation) return;
      if (_audio == null) {
        final audio = _audio =
            widget.audioFactory?.call() ?? _AssetNarrationAudio();
        _subscriptions.addAll([
          audio.positions.listen((p) => _update(() => _position = p)),
          audio.durations.listen((d) => _update(() => _duration = d)),
          audio.completed.listen(
            (_) => _update(() {
              _playing = false;
              _ready = false;
              _position = _duration;
            }),
          ),
        ]);
      }
      if (!_ready) {
        await _audio!.load();
        _ready = true;
      }
      if (!mounted || generation != _generation) return;
      await _audio!.resume();
      if (mounted && generation == _generation) {
        setState(() {
          _playing = true;
          _busy = false;
        });
      }
    });
  }

  void _pause() {
    ++_generation;
    _update(() {
      _playing = false;
      _busy = false;
    });
    _enqueue(() async {
      await _audio?.pause();
    });
  }

  void close() {
    ++_generation;
    _update(() {
      _visible = false;
      _playing = false;
      _busy = false;
      _ready = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    _enqueue(() async {
      await _audio?.stop();
      _ready = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && (_playing || _busy)) _pause();
  }

  @override
  void dispose() {
    ++_generation;
    WidgetsBinding.instance.removeObserver(this);
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _enqueue(() async {
      await _audio?.dispose();
    });
    super.dispose();
  }

  String _time(Duration value) =>
      '${value.inMinutes}:${(value.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'ข้อมูลน่ารู้ในภาพรวม',
              style: TextStyle(
                color: Color(0xFF183022),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            tooltip: 'ฟังเสียงพากย์',
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFE3EDD9),
              foregroundColor: _green,
            ),
            onPressed: _busy
                ? null
                : () {
                    if (!_visible || !_playing) _toggle();
                  },
            icon: const Icon(Icons.headphones_rounded),
          ),
        ],
      ),
      if (_visible)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            key: const ValueKey('narration-bar'),
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3EDD9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    if (_busy)
                      const SizedBox(
                        width: 48,
                        height: 48,
                        child: Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _green,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        tooltip: _playing
                            ? 'พักเสียงพากย์'
                            : _failed
                            ? 'ลองเล่นเสียงอีกครั้ง'
                            : 'เล่นเสียงพากย์ต่อ',
                        onPressed: _toggle,
                        icon: Icon(
                          _playing
                              ? Icons.pause_circle_filled
                              : _failed
                              ? Icons.refresh
                              : Icons.play_circle_fill,
                          color: _green,
                          size: 32,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _failed
                                ? 'เล่นเสียงไม่ได้ กรุณาลองอีกครั้ง'
                                : _busy
                                ? 'กำลังโหลดเสียง…'
                                : 'เสียงพากย์ข้อมูลน่ารู้',
                            style: const TextStyle(
                              color: _green,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${_time(_position)} / ${_time(_duration)}',
                            style: const TextStyle(color: _green, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'ปิดเสียงพากย์',
                      onPressed: close,
                      icon: const Icon(Icons.close, color: _green),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: LinearProgressIndicator(
                    value: _duration.inMilliseconds > 0
                        ? (_position.inMilliseconds / _duration.inMilliseconds)
                              .clamp(0, 1)
                        : 0,
                    color: _green,
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    semanticsLabel: 'ความคืบหน้าเสียงพากย์',
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
