import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../models/daily_boss.dart';
import '../../../../providers/questlog_provider.dart';
import '../../../../services/toast_service.dart';

class RaidBossCard extends StatelessWidget {
  final DailyBoss boss;

  const RaidBossCard({super.key, required this.boss});

  Color _getHpColor(double percent) {
    if (percent > 0.5) return const Color(0xFF00D4B2); // Cyan/Green
    if (percent > 0.2) return Colors.orangeAccent;
    return const Color(0xFFE94057); // Red
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context, listen: false);
    final percent = boss.hpPercentage;
    final isWarrior = provider.currentUser?.classType == 'WARRIOR';
    final themeColor = isWarrior ? const Color(0xFFE94057) : const Color(0xFF00D4B2);

    // Hitung warna border luar kartu
    Color borderColor = const Color(0xFF1E1C2C);
    if (boss.isDefeated) {
      borderColor = boss.isRewardClaimed ? Colors.green.withValues(alpha: 0.5) : Colors.amber;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0B1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: boss.isDefeated ? 2 : 1.5),
        boxShadow: boss.isDefeated && !boss.isRewardClaimed
            ? [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.25),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    boss.isDefeated ? Icons.workspace_premium : Icons.security,
                    color: boss.isDefeated ? Colors.amber : themeColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    boss.isDefeated ? 'DAILY RAID DEFEATED' : 'DAILY RAID BOSS ENCOUNTER',
                    style: TextStyle(
                      color: boss.isDefeated ? Colors.amber : Colors.white,
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              if (boss.isDefeated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: boss.isRewardClaimed ? Colors.green.withValues(alpha: 0.15) : Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: boss.isRewardClaimed ? Colors.green : Colors.amber),
                  ),
                  child: Text(
                    boss.isRewardClaimed ? 'CLEARED' : 'VICTORY',
                    style: TextStyle(
                      color: boss.isRewardClaimed ? Colors.green : Colors.amber,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Baris Konten Utama
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gambar Boss Lingkaran dengan Efek Cahaya
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1C2C),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: boss.isDefeated ? Colors.grey : _getHpColor(percent),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (boss.isDefeated ? Colors.grey : _getHpColor(percent)).withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/${boss.imageUrl}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.dangerous,
                        color: themeColor,
                        size: 32,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Detail Status HP dan Nama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boss.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // HP Progress Bar
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: percent,
                      backgroundColor: const Color(0xFF1E1C2C),
                      progressColor: _getHpColor(percent),
                      barRadius: const Radius.circular(4),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          boss.isDefeated 
                              ? 'K.O. - HP: 0 / ${boss.maxHp.toStringAsFixed(0)}'
                              : 'HP: ${boss.currentHp.toStringAsFixed(0)} / ${boss.maxHp.toStringAsFixed(0)}',
                          style: const TextStyle(color: Color(0xFFA099B0), fontSize: 10),
                        ),
                        Text(
                          '${(percent * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: _getHpColor(percent),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Footer Status Damage / Tombol Reward
          const Divider(color: Color(0xFF1E1C2C)),
          const SizedBox(height: 6),
          if (!boss.isDefeated) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Serangan Anda Hari Ini:',
                  style: TextStyle(color: Color(0xFFA099B0), fontSize: 11),
                ),
                Text(
                  '+${boss.damageDealtToday.toStringAsFixed(0)} DMG',
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ] else if (boss.isDefeated && !boss.isRewardClaimed) ...[
            // Tombol Klaim Reward Bersinar
            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      bool success = await provider.claimBossReward();
                      if (success && context.mounted) {
                        QuestLogToast.showSuccess(
                          context,
                          'Hadiah Diklaim! +50 Koin & +50 STR XP ditambahkan ke pahlawan!',
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                shadowColor: Colors.amber.withValues(alpha: 0.4),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : const Text(
                      'KLAIM HADIAH KEMENANGAN (+50 KOIN / XP)',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
                    ),
            ).animate(onPlay: (controller) => controller.repeat())
             .shimmer(delay: 1.seconds, duration: 1.5.seconds, color: Colors.white30),
          ] else ...[
            // Status Hadiah Sudah Diklaim
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Kemenangan hari ini diraih! Hadiah telah ditransfer.',
                  style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ],
      ),
    )
    .animate(target: boss.damageDealtToday > 0 && !boss.isDefeated ? 1 : 0)
    .shake(hz: 5, curve: Curves.easeInOut, duration: 300.ms);
  }
}
