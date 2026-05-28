class DailyBoss {
  final int bossId;
  final String name;
  final double maxHp;
  final double currentHp;
  final double damageDealtToday;
  final bool isDefeated;
  final bool isRewardClaimed;
  final String imageUrl;

  DailyBoss({
    required this.bossId,
    required this.name,
    required this.maxHp,
    required this.currentHp,
    required this.damageDealtToday,
    required this.isDefeated,
    required this.isRewardClaimed,
    required this.imageUrl,
  });

  factory DailyBoss.fromJson(Map<String, dynamic> json) {
    return DailyBoss(
      bossId: json['bossId'] ?? 0,
      name: json['name'] ?? '',
      maxHp: (json['maxHp'] as num?)?.toDouble() ?? 100.0,
      currentHp: (json['currentHp'] as num?)?.toDouble() ?? 100.0,
      damageDealtToday: (json['damageDealtToday'] as num?)?.toDouble() ?? 0.0,
      isDefeated: json['isDefeated'] ?? false,
      isRewardClaimed: json['isRewardClaimed'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  double get hpPercentage {
    if (maxHp <= 0) return 0.0;
    return (currentHp / maxHp).clamp(0.0, 1.0);
  }
}
