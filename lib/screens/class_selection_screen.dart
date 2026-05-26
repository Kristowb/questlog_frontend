import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/questlog_provider.dart';
import 'home_screen.dart';

class ClassSelectionScreen extends StatefulWidget {
  const ClassSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  String? _selectedClass;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1F1235), // Dark purple
            Color(0xFF0F0B1E), // Darker violet
            Color(0xFF07050E), // Pure dark
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'PILIH KELAS RPG ANDA',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ).animate().fade(duration: 400.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 8),
                const Text(
                  'Tentukan jalan kebugaran fisik Anda. Pilihan kelas akan menyesuaikan quest harian dan statistik karakter Anda.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xFFA099B0),
                    height: 1.5,
                  ),
                ).animate().fade(duration: 400.ms, delay: 100.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 36),
                
                // Kartu Class Selection
                Expanded(
                  child: Row(
                    children: [
                      // Warrior
                      Expanded(
                        child: _buildClassCard(
                          classId: 'WARRIOR',
                          title: 'WARRIOR',
                          icon: Icons.shield,
                          accentColor: const Color(0xFFE94057),
                          description: 'Fokus pada angkat beban & pembentukan otot (Bodybuilding).',
                          stats: {
                            'Strength (STR)': 90,
                            'Stamina (STM)': 50,
                            'Vitality (VIT)': 70,
                          },
                        ).animate().fade(duration: 450.ms, delay: 200.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
                      ),
                      const SizedBox(width: 16),
                      // Archer
                      Expanded(
                        child: _buildClassCard(
                          classId: 'ARCHER',
                          title: 'ARCHER',
                          icon: Icons.double_arrow,
                          accentColor: const Color(0xFF00D4B2),
                          description: 'Fokus pada latihan ketahanan kardio & pembakaran lemak.',
                          stats: {
                            'Strength (STR)': 60,
                            'Stamina (STM)': 90,
                            'Vitality (VIT)': 80,
                          },
                        ).animate().fade(duration: 450.ms, delay: 300.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Button Mulai Petualangan
                ElevatedButton(
                  onPressed: _selectedClass == null || provider.isLoading
                      ? null
                      : () async {
                          bool success = await provider.chooseClass(_selectedClass!);
                          if (success && mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedClass == 'WARRIOR' 
                        ? const Color(0xFFE94057) 
                        : const Color(0xFF00D4B2),
                    disabledBackgroundColor: const Color(0xFF1E1C2C),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: _selectedClass == 'WARRIOR' 
                        ? const Color(0xFFE94057).withOpacity(0.5) 
                        : const Color(0xFF00D4B2).withOpacity(0.5),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'MULAI PETUALANGAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                ).animate().fade(duration: 400.ms, delay: 400.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard({
    required String classId,
    required String title,
    required IconData icon,
    required Color accentColor,
    required String description,
    required Map<String, int> stats,
  }) {
    final isSelected = _selectedClass == classId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedClass = classId;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF161327) : const Color(0xFF0F0B1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFF1E1C2C),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.35),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 30),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : Colors.white60,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFFA099B0),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFF1E1C2C)),
            const SizedBox(height: 10),
            // Stats bars
            ...stats.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                        Text(
                          '${entry.value}%',
                          style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Progress indicator
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: entry.value / 100,
                        backgroundColor: const Color(0xFF1E1C2C),
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
