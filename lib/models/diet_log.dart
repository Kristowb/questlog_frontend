class DietLog {
  final int? id;
  final int userId;
  final String foodName;
  final double protein;
  final double carbs;
  final double fat;
  final double calories;
  final String? logDate;

  DietLog({
    this.id,
    required this.userId,
    required this.foodName,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.calories,
    this.logDate,
  });

  factory DietLog.fromJson(Map<String, dynamic> json) {
    return DietLog(
      id: json['id'],
      userId: json['userId'] ?? 0,
      foodName: json['foodName'] ?? '',
      protein: (json['protein'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      calories: (json['calories'] ?? 0.0).toDouble(),
      logDate: json['logDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'foodName': foodName,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'calories': calories,
      'logDate': logDate,
    };
  }
}
