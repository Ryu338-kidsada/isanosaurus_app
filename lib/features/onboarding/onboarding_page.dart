import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, this.onStartExploring});

  static const _forest = Color(0xFF143F2C);
  static const _leaf = Color(0xFF2F7448);
  static const _bone = Color(0xFFF7F6EF);
  static const _ink = Color(0xFF1C3828);
  static const _mutedInk = Color(0xFF718076);

  final VoidCallback? onStartExploring;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _bone,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _bone,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final heroHeight = (constraints.maxHeight * 0.592).clamp(
              390.0,
              500.0,
            );

            return Column(
              children: [
                _HeroSection(height: heroHeight),
                Expanded(
                  child: _IntroductionSection(
                    onStartExploring: onStartExploring ?? () {},
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ColoredBox(
        color: OnboardingPage._forest,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                top: 18,
                left: 26,
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: OnboardingPage._leaf,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'ISANOSAURUS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
              Center(
                child: Semantics(
                  image: true,
                  label: 'โลโก้ไดโนเสาร์อีสานโนซอรัส',
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      color: OnboardingPage._leaf,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/logo_trexy.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroductionSection extends StatelessWidget {
  const _IntroductionSection({required this.onStartExploring});

  final VoidCallback onStartExploring;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ย้อนเวลาสู่โลก\nของอีสานโนซอรัส',
                      style: TextStyle(
                        color: OnboardingPage._ink,
                        fontSize: 30,
                        height: 1.32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'สำรวจเรื่องราว กายวิภาค\nและช่วงเวลาที่ไดโนเสาร์ไทยสายพันธุ์นี้เคยมีชีวิตอยู่',
                      style: TextStyle(
                        color: OnboardingPage._mutedInk,
                        fontSize: 15,
                        height: 1.55,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: FilledButton(
                        onPressed: onStartExploring,
                        style: FilledButton.styleFrom(
                          backgroundColor: OnboardingPage._leaf,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('เริ่มสำรวจ'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'เรียนรู้แบบเจาะลึก • ใช้งานแบบข้อมูลจำลอง',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF91A097),
                          fontSize: 11,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
