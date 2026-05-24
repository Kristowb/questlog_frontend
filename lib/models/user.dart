class User {
  final int? id;
  final String email;
  final String name;
  final String? classType;
  final int level;
  final int strengthXp;
  final int vitalityXp;
  final int xpToNextLevel;
  final int coins;
  final bool isPremium;
  final String? googleSubId;

  User({
    this.id,
    required this.email,
    required this.name,
    this.classType,
    required this.level,
    required this.strengthXp,
    required this.vitalityXp,
    required this.xpToNextLevel,
    required this.coins,
    required this.isPremium,
    this.googleSubId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      classType: json['classType'],
      level: json['level'] ?? 1,
      strengthXp: json['strengthXp'] ?? 0,
      vitalityXp: json['vitalityXp'] ?? 0,
      xpToNextLevel: json['xpToNextLevel'] ?? 100,
      coins: json['coins'] ?? 0,
      isPremium: json['isPremium'] ?? false,
      googleSubId: json['googleSubId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'classType': classType,
      'level': level,
      'strengthXp': strengthXp,
      'vitalityXp': vitalityXp,
      'xpToNextLevel': xpToNextLevel,
      'coins': coins,
      'isPremium': isPremium,
      'googleSubId': googleSubId,
    };
  }

  // Helper untuk mendapatkan persentase total XP saat ini untuk level up
  double get xpPercentage {
    int totalXp = strengthXp + vitalityXp;
    if (xpToNextLevel <= 0) return 0.0;
    double percentage = totalXp / xpToNextLevel;
    return percentage.clamp(0.0, 1.0);
  }
}
