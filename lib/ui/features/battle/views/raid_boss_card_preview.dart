import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:provider/provider.dart';
import '../../../../models/daily_boss.dart';
import '../../../../providers/questlog_provider.dart';
import 'raid_boss_card.dart';

Widget _buildPreviewWrapper(DailyBoss boss) {
  // Inisialisasi provider kosong untuk melayani pembacaan data kelas
  final provider = QuestLogProvider();

  return ChangeNotifierProvider<QuestLogProvider>.value(
    value: provider,
    child: Scaffold(
      backgroundColor: const Color(0xFF07050E),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: RaidBossCard(boss: boss),
        ),
      ),
    ),
  );
}

@Preview(name: 'Boss Active Battle', group: 'Raid Boss Features')
Widget previewBossActive() {
  return _buildPreviewWrapper(
    DailyBoss(
      bossId: 1,
      name: 'Iron Golem of the Depths',
      maxHp: 5000.0,
      currentHp: 3400.0,
      damageDealtToday: 1600.0,
      isDefeated: false,
      isRewardClaimed: false,
      imageUrl: 'iron_golem.png',
    ),
  );
}

@Preview(name: 'Boss Defeated - Ready to Claim', group: 'Raid Boss Features')
Widget previewBossDefeated() {
  return _buildPreviewWrapper(
    DailyBoss(
      bossId: 1,
      name: 'Spectral Shadow Wyrm',
      maxHp: 6000.0,
      currentHp: 0.0,
      damageDealtToday: 6000.0,
      isDefeated: true,
      isRewardClaimed: false,
      imageUrl: 'spectral_wyrm.png',
    ),
  );
}

@Preview(name: 'Boss Defeated - Reward Claimed', group: 'Raid Boss Features')
Widget previewBossClaimed() {
  return _buildPreviewWrapper(
    DailyBoss(
      bossId: 1,
      name: 'Undead Gladiator Champion',
      maxHp: 4500.0,
      currentHp: 0.0,
      damageDealtToday: 4500.0,
      isDefeated: true,
      isRewardClaimed: true,
      imageUrl: 'undead_gladiator.png',
    ),
  );
}
