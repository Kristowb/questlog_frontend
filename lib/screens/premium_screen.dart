import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/questlog_provider.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context);
    final user = provider.currentUser;

    if (user == null) {
      return const Center(child: Text('Silakan login terlebih dahulu.', style: TextStyle(color: Colors.white)));
    }

    final isWarrior = user.classType == 'WARRIOR';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          // Icon premium glow dengan pulsing animation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 72,
              color: Colors.amber,
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.08, 1.08), duration: 1500.ms, curve: Curves.easeInOut),
          const SizedBox(height: 20),
          const Text(
            'PRO ADVENTURER PACK',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ).animate().fade(duration: 400.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 8),
          const Text(
            'Buka kekuatan penuh pahlawan Anda selamanya.',
            style: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
            textAlign: TextAlign.center,
          ).animate().fade(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 28),

          // Kondisi jika sudah premium
          if (user.isPremium) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C2C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.1),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ]
              ),
              child: Column(
                children: [
                  const Icon(Icons.verified, color: Colors.amber, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'STATUS AKUN: PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selamat! Anda telah mengaktifkan Pro Adventurer Pack. Fitur analitik daging & penjadwalan latihan otomatis telah terbuka.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFA099B0), fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  // Premium advanced feature (simulasi)
                  ElevatedButton(
                    onPressed: () {
                      _showPremiumFeatureDialog(context, isWarrior);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('GENERATE JADWAL LATIHAN INTENSIF', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ).animate().fade(duration: 450.ms, delay: 200.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
          ] else ...[
            // Manfaat Premium dengan staggered entrance
            _buildFeatureBenefit(
              icon: Icons.auto_awesome,
              title: 'Auto-Generate Jadwal Latihan',
              desc: 'Hasilkan rancangan program latihan intensif berminggu-minggu yang disesuaikan secara otomatis.',
            ).animate().fade(duration: 400.ms, delay: 150.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            
            _buildFeatureBenefit(
              icon: Icons.analytics,
              title: 'Analitik Diet Meat-Heavy',
              desc: 'Analisis asupan protein & makronutrisi daging tingkat lanjut untuk efisiensi pertumbuhan otot maksimal.',
            ).animate().fade(duration: 400.ms, delay: 250.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            
            _buildFeatureBenefit(
              icon: Icons.star,
              title: 'Lambang Emas Leaderboard',
              desc: 'Beri tanda bintang emas premium eksklusif untuk nama pahlawan Anda di papan peringkat global.',
            ).animate().fade(duration: 400.ms, delay: 350.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            
            const SizedBox(height: 36),

            // Harga dan Tombol Beli
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0B1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E1C2C)),
              ),
              child: Column(
                children: [
                  const Text(
                    'ONE-TIME PAYMENT',
                    style: TextStyle(color: Color(0xFFA099B0), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '15.00 ',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'USDC',
                        style: TextStyle(color: Color(0xFF00D4B2), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            bool success = await provider.buyPremium();
                            if (!context.mounted) return;
                            if (success) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Selamat! Akun Anda sekarang menjadi Premium Adventurer.'),
                                ),
                              );
                            } else if (provider.errorMessage != null) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(provider.errorMessage!),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                      shadowColor: Colors.amber.withValues(alpha: 0.3),
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'AKTIFKAN PRO ADVENTURER',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                   .shimmer(delay: 2500.ms, duration: 1800.ms),
                ],
              ),
            ).animate().fade(duration: 450.ms, delay: 450.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureBenefit({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.amber, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: Color(0xFFA099B0), fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumFeatureDialog(BuildContext context, bool isWarrior) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1C2C),
          title: const Text('Rekomendasi Program Latihan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(
            isWarrior 
                ? 'Berdasarkan status Warrior Anda, program latihan 5 minggu yang direkomendasikan:\n\n'
                  '• Senin: Push Day (Dada, Bahu, Trisep) - Intensitas Tinggi\n'
                  '• Rabu: Pull Day (Punggung, Bisep) - Volume Sedang\n'
                  '• Jumat: Leg Day (Squat & Hamstring) - Fokus Kekuatan\n\n'
                  'Target protein disesuaikan otomatis menjadi 160g/hari.'
                : 'Berdasarkan status Archer Anda, program latihan 5 minggu yang direkomendasikan:\n\n'
                  '• Senin: Cardio Stamina (Run 5K + Abs)\n'
                  '• Rabu: HIIT Circuit (Ketahanan Paru-Paru)\n'
                  '• Jumat: Active Recovery & Cardio Rendah\n\n'
                  'Target protein disesuaikan otomatis menjadi 140g/hari.',
            style: const TextStyle(color: Color(0xFFA099B0), fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      },
    );
  }
}
