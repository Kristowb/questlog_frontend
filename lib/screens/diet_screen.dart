import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/questlog_provider.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final _formKey = GlobalKey<FormState>();
  final _foodController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _caloriesController = TextEditingController();

  // Preset Makanan Daging (Meat-Heavy Diet)
  final List<Map<String, dynamic>> _foodPresets = [
    {
      'name': 'Ribeye Steak (250g)',
      'protein': 60.0,
      'fat': 45.0,
      'carbs': 0.0,
      'calories': 645.0,
    },
    {
      'name': 'Dada Ayam Panggang (150g)',
      'protein': 46.0,
      'fat': 4.0,
      'carbs': 0.0,
      'calories': 220.0,
    },
    {
      'name': 'Salmon Fillet (150g)',
      'protein': 30.0,
      'fat': 18.0,
      'carbs': 0.0,
      'calories': 280.0,
    },
    {
      'name': 'Telur Rebus (3 Butir)',
      'protein': 18.0,
      'fat': 15.0,
      'carbs': 1.0,
      'calories': 210.0,
    },
  ];

  void _applyPreset(Map<String, dynamic> preset) {
    setState(() {
      _foodController.text = preset['name'];
      _proteinController.text = preset['protein'].toString();
      _fatController.text = preset['fat'].toString();
      _carbsController.text = preset['carbs'].toString();
      _caloriesController.text = preset['calories'].toString();
    });
  }

  InputDecoration _buildInputDecoration({required String labelText, required double labelFontSize}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: const Color(0xFFA099B0), fontSize: labelFontSize),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: const Color(0xFF1E1C2C).withValues(alpha: 0.3),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2D2A42)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00D4B2), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LOG NUTRISI (FEAST)',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ).animate().fade(duration: 350.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 12),

          // Pilihan Preset Daging Cepat (RPG Feast templates)
          const Text(
            'PRESET MAKANAN PROTEIN TINGGI:',
            style: TextStyle(color: Color(0xFFA099B0), fontSize: 10, fontWeight: FontWeight.bold),
          ).animate().fade(duration: 350.ms, delay: 50.ms),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _foodPresets.length,
              itemBuilder: (context, index) {
                final preset = _foodPresets[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    backgroundColor: const Color(0xFF1E1C2C),
                    side: const BorderSide(color: Color(0xFF2D2A42)),
                    label: Text(
                      preset['name'],
                      style: const TextStyle(color: Color(0xFF00D4B2), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _applyPreset(preset),
                  ),
                );
              },
            ),
          ).animate().fade(duration: 400.ms, delay: 80.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 16),

          // Form Log Nutrisi
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0B1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E1C2C)),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _foodController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _buildInputDecoration(labelText: 'Nama Makanan / Hidangan', labelFontSize: 13),
                    validator: (v) => v == null || v.isEmpty ? 'Masukkan nama makanan' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _proteinController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _buildInputDecoration(labelText: 'P (g)', labelFontSize: 11),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _fatController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _buildInputDecoration(labelText: 'L (g)', labelFontSize: 11),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _carbsController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _buildInputDecoration(labelText: 'K (g)', labelFontSize: 11),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _caloriesController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _buildInputDecoration(labelText: 'Kkal', labelFontSize: 11),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              bool success = await provider.addDietLog(
                                _foodController.text.trim(),
                                double.parse(_proteinController.text),
                                double.parse(_carbsController.text),
                                double.parse(_fatController.text),
                                double.parse(_caloriesController.text),
                              );
                              if (success && mounted) {
                                _foodController.clear();
                                _proteinController.clear();
                                _carbsController.clear();
                                _fatController.clear();
                                _caloriesController.clear();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xFF00D4B2),
                                    content: Text('Log Makanan Disimpan! (+10 Vitality XP)'),
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D4B2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: const Color(0xFF00D4B2).withValues(alpha: 0.3),
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'CATAT FEAST (KLAIM +10 VIT XP)',
                            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 450.ms, delay: 150.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 24),

          // Riwayat Makan Hari Ini
          const Text(
            'RIWAYAT MAKAN HARI INI',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ).animate().fade(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 12),

          Expanded(
            child: provider.dailyDiet.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada asupan makanan dicatat hari ini.',
                      style: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.dailyDiet.length,
                    itemBuilder: (context, index) {
                      final log = provider.dailyDiet[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161327),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2D2A42)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.foodName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'P: ${log.protein}g | L: ${log.fat}g | K: ${log.carbs}g',
                                  style: const TextStyle(color: Color(0xFFA099B0), fontSize: 11),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D4B2).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${log.calories.toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  color: Color(0xFF00D4B2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate()
                       .fade(duration: 300.ms, delay: (250 + index * 60).ms)
                       .slideX(begin: 0.15, end: 0, curve: Curves.easeOutQuad);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
