import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/widget_previews.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'PETUALANGAN KEBUGARAN',
      'subtitle': 'Ubah latihan keras menjadi EXP',
      'description': 'Mulai petualangan kebugaran harian Anda. Catat setiap set latihan beban, lari pagi, atau workout untuk mendapatkan EXP, koin emas, dan menaikkan level pahlawan Anda!',
      'image': 'assets/images/onboarding_fitness.png',
    },
    {
      'title': 'RAMUAN & MAKANAN SEHAT',
      'subtitle': 'Pulihkan HP & Mana dengan Nutrisi',
      'description': 'Setiap makanan bergizi dan protein yang Anda catat adalah resep masakan legendaris. Penuhi target kalori dan makro harian Anda untuk menjaga vitalitas sang pahlawan!',
      'image': 'assets/images/onboarding_diet.png',
    },
    {
      'title': 'ARENA & LEADERBOARD',
      'subtitle': 'Tantang Petualang Lain Secara Global',
      'description': 'Buktikan kekuatan Anda di papan peringkat global. Kumpulkan trofi dari konsistensi latihan Anda dan jadilah petualang terkuat di server QuestLog!',
      'image': 'assets/images/onboarding_arena.png',
    },
  ];

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF150F2C), // Dark violet
              Color(0xFF0F0B1E), // Darker violet
              Color(0xFF07050E), // Pure dark RPG background
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600.0, // Batasan lebar adaptif untuk layar besar/tablet
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Header dengan tombol Lewati (Skip)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo mini RPG
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF00D4B2),
                              ),
                              child: const Icon(
                                Icons.shield,
                                size: 14,
                                color: Color(0xFF07050E),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'QUESTLOG',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // Tombol Lewati
                        TextButton(
                          onPressed: _navigateToLogin,
                          child: const Text(
                            'Lewati',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFFA099B0),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Slider halaman
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemCount: _onboardingData.length,
                        itemBuilder: (context, index) {
                          final data = _onboardingData[index];
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                // Container Gambar Ilustrasi RPG dengan efek Glow
                                Container(
                                  height: 280,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00D4B2).withValues(alpha: 0.15),
                                        blurRadius: 30,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.asset(
                                      data['image']!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: const Color(0xFF0F0B1E),
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 64,
                                            color: Color(0xFFA099B0),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ).animate(key: ValueKey('img_$index'))
                                 .fade(duration: 500.ms)
                                 .scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
                                
                                const SizedBox(height: 36),

                                // Subtitle RPG berwarna hijau neon
                                Text(
                                  data['subtitle']!.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                    color: Color(0xFF00D4B2), // Neon Emerald Green
                                  ),
                                ).animate(key: ValueKey('sub_$index'))
                                 .fade(delay: 200.ms)
                                 .slideX(begin: 0.2, end: 0.0, curve: Curves.easeOutQuad),

                                const SizedBox(height: 8),

                                // Judul Utama tebal gaya Outfit
                                Text(
                                  data['title']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ).animate(key: ValueKey('title_$index'))
                                 .fade(delay: 300.ms)
                                 .slideX(begin: -0.2, end: 0.0, curve: Curves.easeOutQuad),

                                const SizedBox(height: 16),

                                // Deskripsi Penjelas
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    data['description']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Color(0xFFA099B0),
                                    ),
                                  ),
                                ).animate(key: ValueKey('desc_$index'))
                                 .fade(delay: 450.ms, duration: 400.ms),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Bagian Kontrol Bawah (Dot indicator & Navigasi tombol)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Halaman Dot Indicator dengan animasi
                          Row(
                            children: List.generate(
                              _onboardingData.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                height: 8.0,
                                width: _currentPage == index ? 24.0 : 8.0, // dot memanjang saat aktif
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: _currentPage == index
                                      ? const Color(0xFF00D4B2) // Aktif: Neon Hijau
                                      : const Color(0xFF38354D), // Tidak aktif: Abu Gelap
                                ),
                              ),
                            ),
                          ),

                          // Tombol Lanjut / Mulai
                          _currentPage == _onboardingData.length - 1
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFE94057).withValues(alpha: 0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _navigateToLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE94057),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'Mulai Petualangan',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, size: 18),
                                      ],
                                    ),
                                  ),
                                ).animate().shimmer(delay: 500.ms, duration: 1500.ms)
                              : ElevatedButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F0B1E),
                                    foregroundColor: const Color(0xFF00D4B2),
                                    side: const BorderSide(
                                      color: Color(0xFF38354D),
                                      width: 1.5,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        'Lanjut',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.chevron_right, size: 18),
                                    ],
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
      ),
    );
  }
}

// Widget Preview untuk proses pengembangan
@Preview(name: 'Onboarding Screen Dark Mode', group: 'Screens')
Widget previewOnboardingScreen() {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnboardingScreen(),
  );
}
