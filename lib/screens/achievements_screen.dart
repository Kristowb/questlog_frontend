import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/questlog_provider.dart';
import '../models/achievement.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context);
    final user = provider.currentUser;
    final achievements = provider.achievements;

    final isWarrior = user?.classType == 'WARRIOR';
    final classColor = isWarrior ? const Color(0xFFE94057) : const Color(0xFF00D4B2);

    return Scaffold(
      backgroundColor: const Color(0xFF07050E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0B1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TROPHY ROOM',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.fetchAchievements();
        },
        child: achievements.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada pencapaian yang ditemukan.',
                  style: TextStyle(color: Color(0xFFA099B0), fontFamily: 'Inter'),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final ach = achievements[index];
                  return _buildAchievementCard(ach, classColor);
                },
              ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement ach, Color classColor) {
    final Color cardBg = ach.isUnlocked ? const Color(0xFF0F0B1E) : const Color(0xFF131120).withOpacity(0.5);
    final Color borderColor = ach.isUnlocked ? const Color(0xFF2D2A42) : const Color(0xFF1E1C2C);
    final double opacity = ach.isUnlocked ? 1.0 : 0.4;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ach.isUnlocked ? classColor.withOpacity(0.4) : borderColor, width: ach.isUnlocked ? 1.5 : 1.0),
        boxShadow: ach.isUnlocked
            ? [
                BoxShadow(
                  color: classColor.withOpacity(0.08),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ach.isUnlocked ? classColor.withOpacity(0.12) : const Color(0xFF1E1C2C),
              shape: BoxShape.circle,
              border: Border.all(
                color: ach.isUnlocked ? classColor : const Color(0xFF2D2A42),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                ach.icon,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white.withOpacity(opacity),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ach.title,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white.withOpacity(opacity),
                        ),
                      ),
                    ),
                    if (ach.isUnlocked) ...[
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    ] else ...[
                      Icon(Icons.lock, color: const Color(0xFFA099B0).withOpacity(0.5), size: 16),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ach.description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: const Color(0xFFA099B0).withOpacity(opacity),
                  ),
                ),
                if (ach.isUnlocked && ach.unlockedAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Terbuka pada: ${ach.unlockedAt!.day}-${ach.unlockedAt!.month}-${ach.unlockedAt!.year}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: classColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
