import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/questlog_provider.dart';
import '../services/update_manager.dart';
import '../services/toast_service.dart';
import '../models/quest.dart';
import 'workout_screen.dart';
import 'diet_screen.dart';
import 'leaderboard_screen.dart';
import 'premium_screen.dart';
import 'login_screen.dart';
import 'achievements_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Tarik data awal saat masuk home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestLogProvider>(context, listen: false).refreshAllData();
      UpdateManager.checkForUpdate(context);
    });
  }

  // Hitung makro kumulatif hari ini
  Map<String, double> _calculateMacros(QuestLogProvider provider) {
    double protein = 0;
    double carbs = 0;
    double fat = 0;
    double calories = 0;

    for (var log in provider.dailyDiet) {
      protein += log.protein;
      carbs += log.carbs;
      fat += log.fat;
      calories += log.calories;
    }

    return {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'calories': calories,
    };
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context);
    final user = provider.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final macros = _calculateMacros(provider);
    final isWarrior = user.classType == 'WARRIOR';
    final classColor = isWarrior ? const Color(0xFFE94057) : const Color(0xFF00D4B2);

    // List Page/Screen untuk BottomNavigationBar
    final List<Widget> pages = [
      _buildDashboard(provider, user, macros, classColor, isWarrior),
      const WorkoutScreen(),
      const DietScreen(),
      const LeaderboardScreen(),
      const PremiumScreen(),
    ];

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
          title: Row(
            children: [
              Icon(isWarrior ? Icons.shield : Icons.double_arrow, color: classColor),
              const SizedBox(width: 10),
              Text(
                isWarrior ? 'WARRIOR DASHBOARD' : 'ARCHER DASHBOARD',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            // Coins Indicator
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${user.coins}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.emoji_events, color: Colors.amber),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white70),
              onPressed: () {
                provider.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await provider.refreshAllData();
          },
          child: pages[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF07050E),
          selectedItemColor: classColor,
          unselectedItemColor: const Color(0xFFA099B0),
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: 'Status'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Diet'),
            BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Rank'),
            BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Store'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(
    QuestLogProvider provider,
    dynamic user,
    Map<String, double> macros,
    Color classColor,
    bool isWarrior,
  ) {
    // Target Nutrisi Meat-Heavy
    double targetProtein = 150.0;
    double targetCarbs = 50.0;
    double targetFat = 80.0;

    double pPct = (macros['protein']! / targetProtein).clamp(0.0, 1.0);
    double cPct = (macros['carbs']! / targetCarbs).clamp(0.0, 1.0);
    double fPct = (macros['fat']! / targetFat).clamp(0.0, 1.0);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Kartu Profil Avatar RPG
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1C2C), Color(0xFF131120)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2D2A42)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: classColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: classColor, width: 2),
                      ),
                      child: Icon(
                        isWarrior ? Icons.sports_martial_arts : Icons.directions_run,
                        color: classColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name & Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              if (user.isPremium) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'PRO',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.isPremium ? 'Legendary Adventurer' : 'Beginner Adventurer',
                            style: const TextStyle(
                              color: Color(0xFFA099B0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Level Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: classColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: classColor),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'LEVEL',
                            style: TextStyle(
                              color: Color(0xFFA099B0),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${user.level}',
                            style: TextStyle(
                              color: classColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // XP Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Experience (XP): ${user.strengthXp + user.vitalityXp} / ${user.xpToNextLevel}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          '${((user.strengthXp + user.vitalityXp) / user.xpToNextLevel * 100).toStringAsFixed(0)}%',
                          style: TextStyle(color: classColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearPercentIndicator(
                      lineHeight: 10.0,
                      percent: user.xpPercentage,
                      backgroundColor: const Color(0xFF0F0B1E),
                      progressColor: classColor,
                      barRadius: const Radius.circular(5),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats Breakdown
                Row(
                  children: [
                    Expanded(
                      child: _buildStatMiniCard(
                        title: 'STRENGTH (Workout)',
                        value: '${user.strengthXp} XP',
                        color: const Color(0xFFE94057),
                        icon: Icons.fitness_center,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatMiniCard(
                        title: 'VITALITY (Nutrisi)',
                        value: '${user.vitalityXp} XP',
                        color: const Color(0xFF00D4B2),
                        icon: Icons.restaurant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 28),

          // 2. Nutrisi Makro (Diet Meat-Heavy)
          const Text(
            'LOG FEAST HARI INI',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ).animate().fade(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0B1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1E1C2C)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Protein indicator (Circular)
                    _buildCircularMacro(
                      label: 'PROTEIN',
                      current: macros['protein']!,
                      target: targetProtein,
                      percent: pPct,
                      color: const Color(0xFFE94057),
                      unit: 'g',
                    ),
                    // Fat indicator
                    _buildCircularMacro(
                      label: 'LEMAK',
                      current: macros['fat']!,
                      target: targetFat,
                      percent: fPct,
                      color: Colors.orangeAccent,
                      unit: 'g',
                    ),
                    // Carbs indicator
                    _buildCircularMacro(
                      label: 'KARBO',
                      current: macros['carbs']!,
                      target: targetCarbs,
                      percent: cPct,
                      color: const Color(0xFF00D4B2),
                      unit: 'g',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFF1E1C2C)),
                const SizedBox(height: 10),
                // Calories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Energi Kumulatif:',
                      style: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                    ),
                    Text(
                      '${macros['calories']!.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fade(duration: 450.ms, delay: 150.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 28),

          // 3. Quest Harian
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DAILY QUESTS',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${provider.dailyQuests.where((q) => q.isCompleted).length}/${provider.dailyQuests.length} Selesai',
                style: TextStyle(
                  color: classColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate().fade(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 12),

          // List Quest
          if (provider.dailyQuests.isEmpty) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Memuat quest harian...',
                  style: TextStyle(color: Color(0xFFA099B0)),
                ),
              ),
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.dailyQuests.length,
              itemBuilder: (context, index) {
                final quest = provider.dailyQuests[index];
                return _buildQuestItem(context, quest, provider, classColor)
                    .animate()
                    .fade(duration: 300.ms, delay: (250 + index * 60).ms)
                    .slideX(begin: 0.15, end: 0, curve: Curves.easeOutQuad);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatMiniCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0B1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2D2A42)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Color(0xFFA099B0), fontSize: 8),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularMacro({
    required String label,
    required double current,
    required double target,
    required double percent,
    required Color color,
    required String unit,
  }) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 34.0,
          lineWidth: 5.0,
          percent: percent,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                current.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '/$target$unit',
                style: const TextStyle(
                  color: Color(0xFFA099B0),
                  fontSize: 8,
                ),
              ),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: const Color(0xFF1E1C2C),
          progressColor: color,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestItem(
    BuildContext context,
    Quest quest,
    QuestLogProvider provider,
    Color classColor,
  ) {
    final isStrength = quest.type == 'STRENGTH';
    final questColor = isStrength ? const Color(0xFFE94057) : const Color(0xFF00D4B2);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0B1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: quest.isCompleted ? questColor.withValues(alpha: 0.3) : const Color(0xFF1E1C2C),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: questColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isStrength ? Icons.fitness_center : Icons.restaurant,
            color: questColor,
            size: 20,
          ),
        ),
        title: Text(
          quest.title,
          style: TextStyle(
            color: quest.isCompleted ? Colors.white54 : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          quest.description,
          style: const TextStyle(
            color: Color(0xFFA099B0),
            fontSize: 11,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: quest.isCompleted ? Colors.transparent : questColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: quest.isCompleted ? Colors.transparent : questColor,
            ),
          ),
          child: quest.isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
              : InkWell(
                  onTap: () async {
                    bool success = await provider.completeQuest(quest.id);
                    if (success && context.mounted) {
                      QuestLogToast.showSuccess(
                        context,
                        'Quest Selesai! Reward +${quest.xpReward} XP diperoleh!',
                      );
                    }
                  },
                  child: Text(
                    '+${quest.xpReward} XP',
                    style: TextStyle(
                      color: questColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
