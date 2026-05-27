import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/questlog_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

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
          ).animate().fade(duration: 350.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 4),
          const Text(
            'Para petualang terkuat di dunia QuestLog.',
            style: TextStyle(color: Color(0xFFA099B0), fontSize: 12),
          ).animate().fade(duration: 350.ms, delay: 50.ms),
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
                      
                      // Rank Badge
                      Widget rankWidget;
                      Color borderColor;
                      double borderWidth = 1.0;
                      List<BoxShadow>? shadows;
                      
                      if (index == 0) {
                        rankWidget = const Icon(Icons.workspace_premium, color: Colors.amber, size: 28);
                        borderColor = Colors.amber;
                        borderWidth = 1.5;
                        shadows = [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.12),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          )
                        ];
                      } else if (index == 1) {
                        rankWidget = const Icon(Icons.workspace_premium, color: Color(0xFFC0C0C0), size: 26);
                        borderColor = const Color(0xFFC0C0C0);
                        borderWidth = 1.2;
                        shadows = [
                          BoxShadow(
                            color: const Color(0xFFC0C0C0).withValues(alpha: 0.08),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          )
                        ];
                      } else if (index == 2) {
                        rankWidget = const Icon(Icons.workspace_premium, color: Color(0xFFCD7F32), size: 24);
                        borderColor = const Color(0xFFCD7F32);
                        borderWidth = 1.2;
                        shadows = [
                          BoxShadow(
                            color: const Color(0xFFCD7F32).withValues(alpha: 0.08),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          )
                        ];
                      } else {
                        rankWidget = Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Color(0xFFA099B0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                        borderColor = item.isPremium ? Colors.amber.withValues(alpha: 0.5) : const Color(0xFF1E1C2C);
                        borderWidth = item.isPremium ? 1.5 : 1.0;
                        if (item.isPremium) {
                          shadows = [
                            BoxShadow(
                              color: Colors.amber.withValues(alpha: 0.08),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            )
                          ];
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0B1E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: borderWidth,
                          ),
                          boxShadow: shadows,
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
                                color: classColor.withValues(alpha: 0.1),
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
                      ).animate()
                       .fade(duration: 300.ms, delay: (100 + index * 50).ms)
                       .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
