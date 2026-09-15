import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/widgets/app_bottom_navigation.dart';
import '../anatomy/anatomy_page.dart';
import '../timeline/timeline_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  static const _leaf = Color(0xFF2E6A43);
  static const _ink = Color(0xFF183022);
  static const _bone = Color(0xFFF7F6F0);
  static const _muted = Color(0xFF65766C);
  // Mock catalog and quantities exist only while this page is open.
  static const _products = [
    (
      name: 'เสื้อเด็ก ISANOSAURUS',
      category: 'เสื้อ',
      price: 299,
      unit: 'ตัว',
      image: 'assets/products/product_dino.png',
      color: Color(0xFFDDE9D2),
    ),
    (
      name: 'ชุดแปรงสีฟันและยาสีฟันเด็ก',
      category: 'ของใช้',
      price: 199,
      unit: 'ชุด',
      image: 'assets/products/product_dino2.png',
      color: Color(0xFFE8E2D1),
    ),
  ];
  String _category = 'ทั้งหมด';
  final _quantities = <String, int>{};

  void _navigate(String label) {
    if (label == 'หน้าหลัก') {
      Navigator.of(context).maybePop();
    } else if (label == 'กายวิภาค' || label == 'ไทม์ไลน์') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              label == 'กายวิภาค' ? const AnatomyPage() : const TimelinePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _products
        .where((p) => _category == 'ทั้งหมด' || p.category == _category)
        .toList();
    final count = _quantities.values.fold(0, (a, b) => a + b);
    final total = _products.fold(
      0,
      (sum, p) => sum + p.price * (_quantities[p.name] ?? 0),
    );
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
                    const Text(
                      'ของที่ระลึก',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'หน้าตัวอย่างร้านค้า • แสดงสินค้าแบบข้อมูลจำลอง',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final category in const [
                          'ทั้งหมด',
                          'เสื้อ',
                          'ของใช้',
                        ])
                          ChoiceChip(
                            label: Text(category),
                            selected: _category == category,
                            onSelected: (_) =>
                                setState(() => _category = category),
                            showCheckmark: false,
                            selectedColor: _leaf,
                            backgroundColor: const Color(0xFFEEF2EC),
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                            labelStyle: TextStyle(
                              color: _category == category
                                  ? Colors.white
                                  : _muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final single =
                            constraints.maxWidth < 300 ||
                            MediaQuery.textScalerOf(context).scale(13) > 18;
                        final width = single
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 14) / 2;
                        return Wrap(
                          spacing: 14,
                          runSpacing: 24,
                          children: [
                            for (final product in products)
                              SizedBox(
                                width: width,
                                child: Container(
                                  key: ValueKey('product-${product.name}'),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFDCE4DB),
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          child: ColoredBox(
                                            color: product.color,
                                            child: Image.asset(
                                              product.image,
                                              fit: BoxFit.contain,
                                              semanticLabel: product.name,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          color: _ink,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '฿${product.price} / ${product.unit}',
                                              style: const TextStyle(
                                                color: _leaf,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          IconButton.filled(
                                            tooltip: 'เพิ่ม ${product.name}',
                                            style: IconButton.styleFrom(
                                              backgroundColor: _leaf,
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed: () => setState(
                                              () => _quantities[product.name] =
                                                  (_quantities[product.name] ??
                                                      0) +
                                                  1,
                                            ),
                                            icon: const Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if ((_quantities[product.name] ?? 0) > 0)
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'เลือก ${_quantities[product.name]} ชิ้น',
                                                style: const TextStyle(
                                                  color: _muted,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'ลด ${product.name}',
                                              onPressed: () => setState(
                                                () =>
                                                    _quantities[product.name] =
                                                        _quantities[product
                                                            .name]! -
                                                        1,
                                              ),
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: _leaf,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    if (count > 0)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EDD9),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                'เลือกทั้งหมด $count ชิ้น • ฿$total',
                                key: const ValueKey('selection-summary'),
                                style: const TextStyle(
                                  color: _leaf,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => setState(_quantities.clear),
                              child: const Text('ล้างรายการที่เลือก'),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'สินค้าและราคาเป็นตัวอย่าง ไม่มีการสั่งซื้อหรือชำระเงิน\nรายการที่เลือกจะถูกล้างเมื่อออกจากหน้านี้',
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
          selectedLabel: 'เพิ่มเติม',
          onSelected: _navigate,
        ),
      ),
    );
  }
}
