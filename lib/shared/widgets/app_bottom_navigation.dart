import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selectedLabel,
    required this.onSelected,
  });
  final String selectedLabel;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    child: Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 488),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFFDCE4DB)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                for (final item in const [
                  ('⌂', 'หน้าหลัก'),
                  ('◎', 'กายวิภาค'),
                  ('◷', 'ไทม์ไลน์'),
                  ('◈', 'เพิ่มเติม'),
                ])
                  Expanded(
                    child: Semantics(
                      selected: item.$2 == selectedLabel,
                      button: true,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => onSelected(item.$2),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: item.$2 == selectedLabel
                                ? const Color(0xFFE3EDD9)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 5,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ExcludeSemantics(
                                child: Text(
                                  item.$1,
                                  style: TextStyle(
                                    color: item.$2 == selectedLabel
                                        ? const Color(0xFF2E6A43)
                                        : const Color(0xFF7A8B80),
                                    fontSize: 18,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Text(
                                item.$2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: item.$2 == selectedLabel
                                      ? const Color(0xFF2E6A43)
                                      : const Color(0xFF7A8B80),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
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
          ),
        ),
      ),
    ),
  );
}
