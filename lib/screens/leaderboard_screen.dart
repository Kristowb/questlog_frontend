import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/questlog_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestLogProvider>(context, listen: false).fetchLeaderboard();
    });
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
            'DEWAN PAHLAWAN',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Para petualang terkuat di dunia QuestLog.',
            style: TextStyle(color: Color(0xFFA099B0), fontSize: 12),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: provider.leaderboard.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00D4B2)),
                  )
                : ListView.builder(
                    itemCount: provider.leaderboard.length,
                    itemBuilder: (context, index) {
                      final item = provider.leaderboard[index];
                      final isWarrior = item.classType == 'WARRIOR';
                      final classColor = isWarrior ? const Color(0xFFE94057) : const Color(0xFF00D4B2);
                      
                      // Pangkat khusus untuk 3 besar
                      Widget rankWidget;
                      if (index == 0) {
                        rankWidget = const Icon(Icons.workspace_premium, color: Colors.amber, size: 28);
                      } else if (index == 1) {
                        rankWidget = const Icon(Icons.workspace_premium, color: Colors.grey, size: 26);
                      } else if (index == 2) {
                        rankWidget = const Icon(Icons.workspace_premium, color: Colors.brown, size: 24);
                      } else {
                        rankWidget = Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Color(0xFFA099B0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0B1E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: item.isPremium ? Colors.amber.withOpacity(0.3) : const Color(0xFF1E1C2C),
                            width: item.isPremium ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Rank Number/Badge
                            Container(
                              width: 36,
                              alignment: Alignment.centerLeft,
                              child: rankWidget,
                            ),
                            // Class Avatar icon mini
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: classColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isWarrior ? Icons.shield : Icons.double_arrow,
                                color: classColor,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // User Name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          shadows: item.isPremium
                                              ? [const Shadow(color: Colors.amber, blurRadius: 4)]
                                              : null,
                                        ),
                                      ),
                                      if (item.isPremium) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    isWarrior ? 'Warrior' : 'Archer',
                                    style: const TextStyle(color: Color(0xFFA099B0), fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            // Level info
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1C2C),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'LVL ${item.level}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
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
