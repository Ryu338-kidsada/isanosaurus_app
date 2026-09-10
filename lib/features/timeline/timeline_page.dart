import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/widgets/app_bottom_navigation.dart';
import '../anatomy/anatomy_page.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  static const _bone = Color(0xFFF7F6F0);
  static const _ink = Color(0xFF183022);
  static const _leaf = Color(0xFF2E6A43);
  static const _muted = Color(0xFF627268);

  // Local educational content. The ancient date reflects the original
  // interpretation in the design, not a precise or settled fossil age.
  static const _events = [
    (
      date: 'ประมาณ 210 ล้านปีก่อน',
      title: 'ช่วงเวลาที่อีสานโนซอรัสมีชีวิตอยู่',
      description:
          'เดิมอธิบายว่าอยู่ในปลายยุคไทรแอสซิก อายุของชั้นหินยังมีการศึกษาเพิ่มเติม',
    ),
    (
      date: 'พ.ศ. 2541',
      title: 'ค้นพบซากดึกดำบรรพ์',
      description: 'พบซากในจังหวัดชัยภูมิ ประเทศไทย และนำมาศึกษาในเชิงวิชาการ',
    ),
    (
      date: 'พ.ศ. 2543',
      title: 'ได้รับการตั้งชื่อ Isanosaurus attavipachi',
      description: 'ชื่อสกุลสะท้อนถึงภูมิภาคอีสานของไทย',
    ),
    (
      date: 'ปัจจุบัน',
      title: 'เป็นส่วนหนึ่งของการเรียนรู้ไดโนเสาร์ไทย',
      description:
          'เชื่อมโยงวิทยาศาสตร์กับท้องถิ่น และเปิดประตูสู่การเรียนรู้เรื่องซากดึกดำบรรพ์',
    ),
  ];

  void _navigate(BuildContext context, String label) {
    if (label == 'หน้าหลัก') {
      Navigator.of(context).maybePop();
    } else if (label == 'กายวิภาค') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AnatomyPage()),
      );
    } else if (label == 'เพิ่มเติม') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('เพิ่มเติม จะเปิดให้ใช้งานเร็ว ๆ นี้')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _bone,
      ),
      child: Scaffold(
        backgroundColor: _bone,
        body: SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ไทม์ไลน์',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'เรียงเหตุการณ์สำคัญให้เห็นภาพตั้งแต่ยุคโบราณถึงการค้นพบ',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    for (var i = 0; i < _events.length; i++)
                      _TimelineEntry(
                        date: _events[i].date,
                        title: _events[i].title,
                        description: _events[i].description,
                        first: i == 0,
                        last: i == _events.length - 1,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          selectedLabel: 'ไทม์ไลน์',
          onSelected: (label) => _navigate(context, label),
        ),
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.date,
    required this.title,
    required this.description,
    required this.first,
    required this.last,
  });

  final String date;
  final String title;
  final String description;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: first ? 10 : 0,
                  bottom: last ? 18 : 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8D0A5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Positioned(
                  top: 18,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: first
                          ? TimelinePage._leaf
                          : const Color(0xFF80A768),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Semantics(
              container: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 138),
                child: Padding(
                  padding: EdgeInsets.only(bottom: last ? 24 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          color: TimelinePage._leaf,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: TimelinePage._ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        description,
                        style: const TextStyle(
                          color: TimelinePage._muted,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
