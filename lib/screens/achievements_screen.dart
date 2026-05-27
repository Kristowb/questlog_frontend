import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/questlog_provider.dart';
import '../models/achievement.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context);
    final user = provider.currentUser;
    final achievements = provider.achievements;

    final isWarrior = user?.classType == 'WARRIOR';
    final classColor = isWarrior ? const Color(0xFFE94057) : const Color(0xFF00D4B2);

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
                    return _buildAchievementCard(ach, classColor)
                        .animate()
                        .fade(duration: 300.ms, delay: (index * 80).ms)
                        .slideX(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement ach, Color classColor) {
    final Color cardBg = ach.isUnlocked ? const Color(0xFF0F0B1E) : const Color(0xFF131120).withValues(alpha: 0.5);
    final Color borderColor = ach.isUnlocked ? const Color(0xFF2D2A42) : const Color(0xFF1E1C2C);
    final double opacity = ach.isUnlocked ? 1.0 : 0.4;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ach.isUnlocked ? classColor.withValues(alpha: 0.5) : borderColor,
          width: ach.isUnlocked ? 1.5 : 1.0,
        ),
        boxShadow: ach.isUnlocked
            ? [
                BoxShadow(
                  color: classColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
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
              color: ach.isUnlocked ? classColor.withValues(alpha: 0.12) : const Color(0xFF1E1C2C),
              shape: BoxShape.circle,
              border: Border.all(
                color: ach.isUnlocked ? classColor : const Color(0xFF2D2A42),
                width: 1.5,
              ),
            ),
            child: Center(
              child: _getAchievementIcon(ach.icon, classColor, opacity),
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
                          color: Colors.white.withValues(alpha: opacity),
                        ),
                      ),
                    ),
                    if (ach.isUnlocked) ...[
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    ] else ...[
                      Icon(Icons.lock, color: const Color(0xFFA099B0).withValues(alpha: 0.5), size: 16),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ach.description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: const Color(0xFFA099B0).withValues(alpha: opacity),
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
                      color: classColor.withValues(alpha: 0.7),
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

  Widget _getAchievementIcon(String iconEmoji, Color classColor, double opacity) {
    String? assetPath;
    switch (iconEmoji) {
      case '🏆':
        assetPath = 'assets/images/achievements/iron_warrior.png';
        break;
      case '🥩':
        assetPath = 'assets/images/achievements/carnivore_king.png';
        break;
      case '👑':
        assetPath = 'assets/images/achievements/quest_champion.png';
        break;
      case '💧':
        assetPath = 'assets/images/achievements/hydration_devotee.png';
        break;
    }

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        width: 32,
        height: 32,
        color: opacity < 1.0 ? Colors.white.withValues(alpha: 0.3) : null,
        colorBlendMode: opacity < 1.0 ? BlendMode.modulate : null,
        errorBuilder: (context, error, stackTrace) {
          return Text(
            iconEmoji,
            style: TextStyle(
              fontSize: 28,
              color: Colors.white.withValues(alpha: opacity),
            ),
          );
        },
      );
    }

    return Text(
      iconEmoji,
      style: TextStyle(
        fontSize: 28,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
