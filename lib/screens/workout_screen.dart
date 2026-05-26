import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/questlog_provider.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  InputDecoration _buildInputDecoration({required String labelText, required double labelFontSize}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: const Color(0xFFA099B0), fontSize: labelFontSize),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: const Color(0xFF1E1C2C).withOpacity(0.3),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2D2A42)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE94057), width: 1.5),
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
            'LOG LATIHAN FISIK',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ).animate().fade(duration: 350.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 16),

          // Form Input Latihan
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
                    controller: _exerciseController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _buildInputDecoration(
                      labelText: 'Nama Latihan (misal: Bench Press, Squat)',
                      labelFontSize: 13,
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Masukkan nama latihan' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _setsController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _buildInputDecoration(labelText: 'Set', labelFontSize: 12),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _repsController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _buildInputDecoration(labelText: 'Reps', labelFontSize: 12),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _buildInputDecoration(labelText: 'Beban (kg)', labelFontSize: 12),
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
                              bool success = await provider.addWorkoutLog(
                                _exerciseController.text.trim(),
                                int.parse(_setsController.text),
                                int.parse(_repsController.text),
                                double.parse(_weightController.text),
                              );
                              if (success && mounted) {
                                _exerciseController.clear();
                                _setsController.clear();
                                _repsController.clear();
                                _weightController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xFFE94057),
                                    content: Text('Log Latihan Disimpan! (+10 Strength XP)'),
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE94057),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: const Color(0xFFE94057).withOpacity(0.3),
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'CATAT LATIHAN (KLAIM +10 STR XP)',
                            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 450.ms, delay: 100.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 24),

          // Riwayat Latihan Hari Ini
          const Text(
            'RIWAYAT LATIHAN HARI INI',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ).animate().fade(duration: 400.ms, delay: 180.ms),
          const SizedBox(height: 12),
          
          Expanded(
            child: provider.dailyWorkouts.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada latihan dicatat hari ini.',
                      style: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.dailyWorkouts.length,
                    itemBuilder: (context, index) {
                      final log = provider.dailyWorkouts[index];
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
                                  log.exerciseName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${log.sets} Set x ${log.reps} Reps',
                                  style: const TextStyle(color: Color(0xFFA099B0), fontSize: 12),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE94057).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${log.weight} kg',
                                style: const TextStyle(
                                  color: Color(0xFFE94057),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate()
                       .fade(duration: 300.ms, delay: (220 + index * 60).ms)
                       .slideX(begin: 0.15, end: 0, curve: Curves.easeOutQuad);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
