class WorkoutLog {
  final int? id;
  final int userId;
  final String exerciseName;
  final int sets;
  final int reps;
  final double weight;
  final String? logDate;

  WorkoutLog({
    this.id,
    required this.userId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
    this.logDate,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      id: json['id'],
      userId: json['userId'] ?? 0,
      exerciseName: json['exerciseName'] ?? '',
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      weight: (json['weight'] ?? 0.0).toDouble(),
      logDate: json['logDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'exerciseName': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'logDate': logDate,
    };
  }
}
