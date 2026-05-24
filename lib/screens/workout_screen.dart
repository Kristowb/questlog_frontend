import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          ),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nama Latihan (misal: Bench Press, Squat)',
                      labelStyle: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1E1C2C))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE94057))),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Masukkan nama latihan' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _setsController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Set',
                            labelStyle: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1E1C2C))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE94057))),
                          ),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _repsController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Repetisi',
                            labelStyle: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1E1C2C))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE94057))),
                          ),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Beban (kg)',
                            labelStyle: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF1E1C2C))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE94057))),
                          ),
                          validator: (v) => v == null || v.isEmpty ? 'Wajib' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('CATAT LATIHAN (KLAIM +10 STR XP)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
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
          ),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
