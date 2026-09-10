import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/widgets/app_bottom_navigation.dart';

class AnatomyPage extends StatefulWidget {
  const AnatomyPage({super.key});

  static const imageAsset = 'assets/images/logo_trexy.png';

  @override
  State<AnatomyPage> createState() => _AnatomyPageState();
}

class _AnatomyPart {
  const _AnatomyPart(this.label, this.title, this.description, this.position);
  final String label;
  final String title;
  final String description;
  // Normalized positions within the illustration area; update with the final art.
  final Offset position;
}

class _AnatomyPageState extends State<AnatomyPage> {
  static const _leaf = Color(0xFF2E6A43);
  static const _ink = Color(0xFF183022);
  static const _bone = Color(0xFFF7F6F0);
  static const _muted = Color(0xFF627268);
  // Introductory, general sauropod descriptions, not specimen reconstructions.
  static const _parts = [
    _AnatomyPart(
      'หัว',
      'ศีรษะ',
      'ศีรษะเป็นที่อยู่ของสมอง ตา และปาก ส่วนปากและฟันเกี่ยวข้องกับการกินอาหาร '
          'ภาพโลโก้นี้ใช้แทนภาพชั่วคราว จึงไม่ใช่รูปร่างศีรษะจริงของอีสานโนซอรัส',
      Offset(0.80, 0.20),
    ),
    _AnatomyPart(
      'คอ',
      'คอ',
      'คอเชื่อมศีรษะเข้ากับลำตัว คอยาวเป็นลักษณะเด่นของซอโรพอด '
          'ช่วยให้ศีรษะเข้าถึงพืชได้ในระยะที่กว้างขึ้น',
      Offset(0.82, 0.48),
    ),
    _AnatomyPart(
      'ลำตัว',
      'ลำตัว',
      'ลำตัวเป็นส่วนกลางของร่างกาย มีแนวกระดูกสันหลังและซี่โครง '
          'ช่วยพยุงร่างกายและปกป้องอวัยวะภายใน',
      Offset(0.50, 0.48),
    ),
    _AnatomyPart(
      'หาง',
      'หาง',
      'หางต่อเนื่องจากแนวกระดูกสันหลังทางด้านท้ายลำตัว '
          'เป็นส่วนหนึ่งที่ช่วยรักษาสมดุลของร่างกายขณะยืนและเคลื่อนที่',
      Offset(0.16, 0.57),
    ),
    _AnatomyPart(
      'ขา',
      'ขา',
      'ซอโรพอดเดินด้วยขาทั้งสี่ ขาทำหน้าที่รับน้ำหนักและพาร่างกายเคลื่อนที่ '
          'กระดูกขาจึงเป็นหลักฐานสำคัญในการศึกษาท่าทางและการรองรับน้ำหนัก',
      Offset(0.53, 0.83),
    ),
  ];
  int _selected = 0;

  void _navigate(String label) {
    if (label == 'หน้าหลัก') {
      Navigator.of(context).maybePop();
    } else if (label != 'กายวิภาค') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('$label จะเปิดให้ใช้งานเร็ว ๆ นี้')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final part = _parts[_selected];
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
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'กายวิภาค',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'แตะจุดบนภาพเพื่ออ่านรายละเอียดแต่ละส่วน',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF0E3),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 350 / 270,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    Center(
                                      child: FractionallySizedBox(
                                        widthFactor: 0.70,
                                        heightFactor: 0.85,
                                        child: Center(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: ClipOval(
                                              child: Image.asset(
                                                AnatomyPage.imageAsset,
                                                fit: BoxFit.cover,
                                                semanticLabel:
                                                    'โลโก้จำลอง ไม่ใช่ภาพกายวิภาคจริง',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    for (var i = 0; i < _parts.length; i++)
                                      Positioned(
                                        left:
                                            (constraints.maxWidth - 48) *
                                            _parts[i].position.dx,
                                        top:
                                            (constraints.maxHeight - 48) *
                                            _parts[i].position.dy,
                                        child: Semantics(
                                          selected: _selected == i,
                                          child: SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: IconButton(
                                              tooltip:
                                                  'จุด ${i + 1}: ${_parts[i].label}',
                                              onPressed: () =>
                                                  setState(() => _selected = i),
                                              icon: Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: _selected == i
                                                      ? _leaf
                                                      : Colors.white,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: _leaf,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Text(
                                                  '${i + 1}',
                                                  style: TextStyle(
                                                    color: _selected == i
                                                        ? Colors.white
                                                        : _leaf,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const Text(
                            'ภาพและตำแหน่งจุดเลือกเป็นภาพจำลอง',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _muted,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFDCE4DB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              '${(_selected + 1).toString().padLeft(2, '0')}  ${part.title}',
                              key: const ValueKey('anatomy-detail-title'),
                              style: const TextStyle(
                                color: _leaf,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            part.description,
                            style: const TextStyle(
                              color: Color(0xFF42564A),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (var i = 0; i < _parts.length; i++)
                                ChoiceChip(
                                  label: Text(_parts[i].label),
                                  selected: _selected == i,
                                  onSelected: (_) =>
                                      setState(() => _selected = i),
                                  showCheckmark: false,
                                  selectedColor: _leaf,
                                  backgroundColor: const Color(0xFFEEF2EC),
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                  labelStyle: TextStyle(
                                    color: _selected == i
                                        ? Colors.white
                                        : _muted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'คำอธิบายเบื้องต้นของส่วนร่างกายซอโรพอด ไม่ใช่การจำลองจากโครงกระดูกที่พบครบทุกส่วน',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          selectedLabel: 'กายวิภาค',
          onSelected: _navigate,
        ),
      ),
    );
  }
}
