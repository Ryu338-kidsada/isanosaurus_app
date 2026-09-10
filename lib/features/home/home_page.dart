import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../anatomy/anatomy_page.dart';
import '../timeline/timeline_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Replace this asset when the final dinosaur illustration is ready.
  static const dinosaurImageAsset = 'assets/images/logo_trexy.png';
  static const _bone = Color(0xFFF7F6F0);
  static const _leaf = Color(0xFF2E6A43);
  static const _ink = Color(0xFF183022);
  static const _muted = Color(0xFF627268);
  static const _border = Color(0xFFDCE4DB);

  void _openAnatomy(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AnatomyPage()));
  }

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$title จะเปิดให้ใช้งานเร็ว ๆ นี้')),
      );
  }

  void _openTimeline(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const TimelinePage()));
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
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ISANOSAURUS',
                            style: TextStyle(
                              color: _leaf,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'รู้จักอีสานโนซอรัส',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            'ไดโนเสาร์ซอโรพอดจากประเทศไทย\nสำรวจข้อมูลสำคัญแบบเข้าใจง่ายในแอปเดียว',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 230),
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF163B28),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CRETACEOUS • THAILAND',
                            style: TextStyle(
                              color: Color(0xFFC7DBA7),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: ClipOval(
                              child: Image.asset(
                                dinosaurImageAsset,
                                width: 132,
                                height: 132,
                                fit: BoxFit.cover,
                                semanticLabel: 'โลโก้ไดโนเสาร์อีสานโนซอรัส',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Isanosaurus attavipachi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _DinosaurFacts(),
                    const SizedBox(height: 26),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'สำรวจแบบเจาะลึก',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked =
                            constraints.maxWidth < 300 ||
                            MediaQuery.textScalerOf(context).scale(16) > 22;
                        final anatomy = _ExploreCard(
                          title: 'กายวิภาค',
                          description: 'เรียนรู้ส่วนต่าง ๆ\nของร่างกาย',
                          onTap: () => _openAnatomy(context),
                        );
                        final timeline = _ExploreCard(
                          title: 'ไทม์ไลน์',
                          description: 'จัดลำดับช่วงเวลา\nอย่างเป็นระบบ',
                          onTap: () => _openTimeline(context),
                        );
                        if (stacked) {
                          return Column(
                            children: [
                              anatomy,
                              const SizedBox(height: 14),
                              timeline,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: anatomy),
                            const SizedBox(width: 14),
                            Expanded(child: timeline),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 130),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: _border),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เรื่องน่ารู้',
                            style: TextStyle(
                              color: _leaf,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'ชื่อ “Isanosaurus” สื่อถึงภูมิภาคอีสาน\nพื้นที่สำคัญของการค้นพบไดโนเสาร์ไทย',
                            style: TextStyle(
                              color: Color(0xFF42564A),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          selectedLabel: 'หน้าหลัก',
          onSelected: (label) {
            if (label == 'กายวิภาค') {
              _openAnatomy(context);
            } else if (label == 'ไทม์ไลน์') {
              _openTimeline(context);
            } else if (label != 'หน้าหลัก') {
              _comingSoon(context, label);
            }
          },
        ),
      ),
    );
  }
}

class _DinosaurFacts extends StatelessWidget {
  const _DinosaurFacts();

  // Specimen length: https://en.wikipedia.org/wiki/Isanosaurus
  // Discovery: https://abcnews.com/Technology/story?id=119976&page=1
  // Original description: https://doi.org/10.1038/35024060
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'ข้อมูลน่ารู้ในภาพรวม',
            style: TextStyle(
              color: HomePage._ink,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final singleColumn =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(14) > 21;
            final width = singleColumn
                ? constraints.maxWidth
                : (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: width,
                  child: const _FactCard(
                    icon: Icons.monitor_weight_outlined,
                    label: 'น้ำหนัก',
                    value: 'ยังไม่ยืนยัน',
                    detail: 'ยังไม่มีค่าที่ใช้ยืนยันในแอป',
                  ),
                ),
                SizedBox(
                  width: width,
                  child: const _FactCard(
                    icon: Icons.height,
                    label: 'ส่วนสูง',
                    value: 'ยังไม่ยืนยัน',
                    detail: 'ซากที่พบไม่ใช่โครงกระดูกครบตัว',
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  child: const _FactCard(
                    icon: Icons.straighten,
                    label: 'ความยาวโดยประมาณ',
                    value: '6.5 เมตร',
                    detail:
                        'ประมาณจากตัวอย่างที่ยังไม่โตเต็มวัย ไม่ใช่ขนาดสูงสุดของสายพันธุ์',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFE3EDD9),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: HomePage._leaf,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'พบซากครั้งแรก',
                      style: TextStyle(
                        color: HomePage._leaf,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'พ.ศ. 2541 (ค.ศ. 1998)',
                style: TextStyle(
                  color: HomePage._ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'จังหวัดชัยภูมิ ประเทศไทย',
                style: TextStyle(
                  color: HomePage._ink,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'ค้นพบในชั้นหินของหมวดหินน้ำพอง ก่อนตีพิมพ์ตั้งชื่อในปี พ.ศ. 2543',
                style: TextStyle(
                  color: HomePage._muted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'ขนาดร่างกายเป็นค่าประมาณจากซากดึกดำบรรพ์ และอาจเปลี่ยนแปลงเมื่อมีหลักฐานเพิ่มเติม',
            style: TextStyle(color: HomePage._muted, fontSize: 11, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
  });
  final IconData icon;
  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: HomePage._border),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: HomePage._leaf, size: 22),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(color: HomePage._muted, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: HomePage._ink,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          detail,
          style: const TextStyle(
            color: HomePage._muted,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({
    required this.title,
    required this.description,
    required this.onTap,
  });
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: HomePage._border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 118),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: HomePage._leaf,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: HomePage._muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
