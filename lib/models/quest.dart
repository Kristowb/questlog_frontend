class Quest {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String type; // STRENGTH or VITALITY
  final bool isCompleted;
  final int xpReward;
  final String questDate;

  Quest({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.isCompleted,
    required this.xpReward,
    required this.questDate,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'STRENGTH',
      isCompleted: json['isCompleted'] ?? false,
      xpReward: json['xpReward'] ?? 0,
      questDate: json['questDate'] ?? '',
    );
  }
}
