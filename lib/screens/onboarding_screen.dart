import 'package:flutter/material.dart';

import '../theme/betah_colors.dart';
import '../widgets/listing_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinish});

  final Future<void> Function() onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;
  bool _isFinishing = false;

  static const _pages = [
    _OnboardingPageData(
      eyebrow: 'BETAH APP',
      title: 'Cari kos senyaman rumah',
      description:
          'Temukan hunian pilihan di Surabaya, lengkap dengan foto dan info yang kamu butuhkan.',
      icon: Icons.home_work_outlined,
    ),
    _OnboardingPageData(
      eyebrow: 'PILIH LOKASI',
      title: 'Dekat dengan tujuanmu',
      description:
          'Jelajahi kos di sekitar kampus, kantor, dan area favorit langsung dari peta.',
      icon: Icons.map_outlined,
    ),
    _OnboardingPageData(
      eyebrow: 'MULAI DARI SINI',
      title: 'Temukan tempat pulangmu',
      description:
          'Simpan kos yang kamu suka, bandingkan pilihan, lalu temukan yang paling pas.',
      icon: Icons.favorite_border_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_page < _pages.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    await widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(23, 15, 23, 17),
          child: Column(
            children: [
              Row(
                children: [
                  const BetahMark(size: 40),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BETAH',
                        style: TextStyle(
                          color: BetahColors.green,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'CARI KOS, RASA RUMAH',
                        style: TextStyle(
                          color: BetahColors.muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _isFinishing ? null : _finish,
                    child: const Text(
                      'Lewati',
                      style: TextStyle(color: BetahColors.muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 19),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) =>
                      _OnboardingPage(data: _pages[index]),
                ),
              ),
              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < _pages.length; index++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: _page == index ? 22 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _page == index
                            ? BetahColors.orange
                            : const Color(0xFFDCCBAA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isFinishing ? null : _continue,
                  style: FilledButton.styleFrom(
                    backgroundColor: BetahColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: _isFinishing
                      ? const SizedBox.square(
                          dimension: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _page == _pages.length - 1
                              ? 'Mulai Cari Kos'
                              : 'Lanjut',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Temukan hunian yang terasa seperti rumah.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: BetahColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: BetahColors.green,
              borderRadius: BorderRadius.circular(23),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -47,
                  right: -24,
                  child: Container(
                    width: 148,
                    height: 148,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E6956),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -77,
                  left: -31,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0E473A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 174,
                  height: 174,
                  decoration: BoxDecoration(
                    color: BetahColors.greenDeep,
                    borderRadius: BorderRadius.circular(48),
                    border: Border.all(
                      color: const Color(0xFF6E9B87),
                      width: 1.4,
                    ),
                  ),
                  child: Icon(data.icon, color: BetahColors.paper, size: 86),
                ),
                Positioned(
                  top: 25,
                  right: 25,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: BetahColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  right: 22,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: BetahColors.paper,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: BetahColors.gold,
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Pilihan nyaman',
                            style: TextStyle(
                              color: BetahColors.greenDeep,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(flex: 1),
        Text(
          data.eyebrow,
          style: const TextStyle(
            color: BetahColors.orange,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          data.title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 26, height: 1.13),
        ),
        const SizedBox(height: 10),
        Text(
          data.description,
          style: const TextStyle(
            color: BetahColors.muted,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
