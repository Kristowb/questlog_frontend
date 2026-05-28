import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RaidBossCodexDialog extends StatefulWidget {
  const RaidBossCodexDialog({super.key});

  @override
  State<RaidBossCodexDialog> createState() => _RaidBossCodexDialogState();
}

class _RaidBossCodexDialogState extends State<RaidBossCodexDialog> {
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '10');
  final _weightController = TextEditingController(text: '60');
  double _simulatedDamage = 1800.0;

  @override
  void initState() {
    super.initState();
    _setsController.addListener(_calculateSimulation);
    _repsController.addListener(_calculateSimulation);
    _weightController.addListener(_calculateSimulation);
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateSimulation() {
    final int sets = int.tryParse(_setsController.text) ?? 0;
    final int reps = int.tryParse(_repsController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0.0;

    setState(() {
      _simulatedDamage = sets * reps * weight;
    });
  }

  Widget _buildStepItem({required String stepNumber, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4B2).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00D4B2), width: 1.5),
            ),
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Color(0xFF00D4B2),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFFA099B0),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFA099B0), fontSize: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      filled: true,
      fillColor: const Color(0xFF07050E),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2D2A42)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.amber, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F1235), // Dark purple
              Color(0xFF0F0B1E), // Darker violet
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: Colors.amber,
                  size: 32,
                ),
              ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 16),

              // Title
              const Text(
                'RAID BOSS CODEX',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'Panduan Pertempuran Bos Harian',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 24),

              // Steps
              _buildStepItem(
                stepNumber: '1',
                title: 'Kumpulkan Daya Serang (DMG)',
                description: 'Setiap latihan fisik yang Anda catat di tab Workout otomatis dikonversi menjadi damage nyata.\nFormula: Set x Reps x Beban (kg) = DMG.',
              ),
              _buildStepItem(
                stepNumber: '2',
                title: 'Serang & Kurangi HP Bos',
                description: 'Setiap bos memiliki HP dasar berskala level karakter Anda. Laporkan workout Anda hingga HP bos berkurang menjadi 0.',
              ),
              _buildStepItem(
                stepNumber: '3',
                title: 'Klaim Koin & XP Tambahan',
                description: 'Saat bos harian K.O., tombol klaim hadiah akan terbuka di dashboard. Ketuk untuk mengklaim +50 Koin & +50 STR XP!',
              ),

              const Divider(color: Color(0xFF2D2A42)),
              const SizedBox(height: 12),

              // Simulator Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SIMULATOR SERANGAN FISIK:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Simulator Form
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _setsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: _buildInputDecoration('Set'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: _buildInputDecoration('Reps'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: _buildInputDecoration('Beban (kg)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Simulator Result Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF07050E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D2A42)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ESTIMASI KERUSAKAN HANTAMAN:',
                      style: TextStyle(color: Color(0xFFA099B0), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${_simulatedDamage.toStringAsFixed(0)} DMG',
                      style: const TextStyle(
                        color: Color(0xFF00D4B2),
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Close Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1C2C),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF2D2A42)),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'TUTUP CODEX',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
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
