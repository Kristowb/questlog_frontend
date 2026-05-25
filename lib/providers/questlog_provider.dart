import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../models/quest.dart';
import '../models/workout_log.dart';
import '../models/diet_log.dart';
import '../models/achievement.dart';

class QuestLogProvider with ChangeNotifier {
  // Gunakan IP 10.0.2.2 untuk Android Emulator, localhost untuk Desktop/Web
  // Kita buat deteksi otomatis sederhana
  String _baseUrl = 'http://localhost:8080/api/v1';
  
  User? _currentUser;
  String? _token;
  List<Quest> _dailyQuests = [];
  List<WorkoutLog> _dailyWorkouts = [];
  List<DietLog> _dailyDiet = [];
  List<User> _leaderboard = [];
  List<Achievement> _achievements = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  String? get token => _token;
  List<Quest> get dailyQuests => _dailyQuests;
  List<WorkoutLog> get dailyWorkouts => _dailyWorkouts;
  List<DietLog> get dailyDiet => _dailyDiet;
  List<User> get leaderboard => _leaderboard;
  List<Achievement> get achievements => _achievements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setBaseUrl(String url) {
    _baseUrl = url;
    notifyListeners();
  }

  Map<String, String> _getHeaders({bool includeJson = false}) {
    final Map<String, String> headers = {};
    if (includeJson) {
      headers['Content-Type'] = 'application/json';
    }
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Helper loader state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Google OAuth / Mock Login
  Future<bool> login(String idToken) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        _token = idToken; // Simpan token untuk request berikutnya
        _currentUser = User.fromJson(json.decode(response.body));
        await refreshAllData();
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Gagal masuk: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Kesalahan koneksi server: $e';
    }
    _setLoading(false);
    return false;
  }

  // Memilih class (Warrior / Archer)
  Future<bool> chooseClass(String classType) async {
    if (_currentUser == null) return false;
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users/${_currentUser!.id}/class'),
        headers: _getHeaders(includeJson: true),
        body: json.encode({'classType': classType.toUpperCase()}),
      );

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(json.decode(response.body));
        await refreshAllData();
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _errorMessage = 'Gagal memilih kelas: $e';
    }
    _setLoading(false);
    return false;
  }

  // Refresh profile
  Future<void> refreshProfile() async {
    if (_currentUser == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/${_currentUser!.id}'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        _currentUser = User.fromJson(json.decode(response.body));
        notifyListeners();
      }
    } catch (e) {
      print('Gagal refresh profil: $e');
    }
  }

  // Fetch Daily Quests
  Future<void> fetchDailyQuests() async {
    if (_currentUser == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/quests/daily/${_currentUser!.id}'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _dailyQuests = data.map((q) => Quest.fromJson(q)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Gagal mengambil quest harian: $e');
    }
  }

  // Complete Quest
  Future<bool> completeQuest(int questId) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/quests/$questId/complete'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        await refreshProfile();
        await fetchDailyQuests();
        await fetchAchievements(); // Refresh pencapaian jika ada yang terbuka
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _errorMessage = 'Gagal menyelesaikan quest: $e';
    }
    _setLoading(false);
    return false;
  }

  // Fetch Daily Workouts
  Future<void> fetchDailyWorkouts() async {
    if (_currentUser == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/workouts/daily/${_currentUser!.id}'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _dailyWorkouts = data.map((w) => WorkoutLog.fromJson(w)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Gagal mengambil latihan harian: $e');
    }
  }

  // Add Workout Log
  Future<bool> addWorkoutLog(String exerciseName, int sets, int reps, double weight) async {
    if (_currentUser == null) return false;
    _setLoading(true);
    try {
      final log = WorkoutLog(
        userId: _currentUser!.id!,
        exerciseName: exerciseName,
        sets: sets,
        reps: reps,
        weight: weight,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/workouts'),
        headers: _getHeaders(includeJson: true),
        body: json.encode(log.toJson()),
      );

      if (response.statusCode == 200) {
        await refreshProfile();
        await fetchDailyWorkouts();
        await fetchDailyQuests(); // Update status quest jika ada kecocokan
        await fetchAchievements(); // Refresh pencapaian jika terbuka
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _errorMessage = 'Gagal mencatat latihan: $e';
    }
    _setLoading(false);
    return false;
  }

  // Fetch Daily Diet
  Future<void> fetchDailyDiet() async {
    if (_currentUser == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/diet/daily/${_currentUser!.id}'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _dailyDiet = data.map((d) => DietLog.fromJson(d)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Gagal mengambil data diet harian: $e');
    }
  }

  // Add Diet Log
  Future<bool> addDietLog(String foodName, double protein, double carbs, double fat, double calories) async {
    if (_currentUser == null) return false;
    _setLoading(true);
    try {
      final log = DietLog(
        userId: _currentUser!.id!,
        foodName: foodName,
        protein: protein,
        carbs: carbs,
        fat: fat,
        calories: calories,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/diet'),
        headers: _getHeaders(includeJson: true),
        body: json.encode(log.toJson()),
      );

      if (response.statusCode == 200) {
        await refreshProfile();
        await fetchDailyDiet();
        await fetchDailyQuests(); // Update status quest jika ada kecocokan
        await fetchAchievements(); // Refresh pencapaian jika terbuka
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _errorMessage = 'Gagal mencatat diet: $e';
    }
    _setLoading(false);
    return false;
  }

  // Fetch Leaderboard
  Future<void> fetchLeaderboard() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/leaderboard'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _leaderboard = data.map((u) => User.fromJson(u)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Gagal mengambil leaderboard: $e');
    }
  }

  // Fetch Achievements
  Future<void> fetchAchievements() async {
    if (_currentUser == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/achievements/user/${_currentUser!.id}'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _achievements = data.map((a) => Achievement.fromJson(a)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Gagal mengambil pencapaian pahlawan: $e');
    }
  }

  // Buy Premium (Redirect ke Stripe Checkout Session)
  Future<bool> buyPremium() async {
    if (_currentUser == null) return false;
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/premium/checkout'),
        headers: _getHeaders(includeJson: true),
        body: json.encode({'userId': _currentUser!.id}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String checkoutUrl = data['checkoutUrl'];
        
        final Uri url = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          _setLoading(false);
          return true;
        } else {
          _errorMessage = 'Tidak dapat membuka browser untuk pembayaran.';
        }
      }
    } catch (e) {
      _errorMessage = 'Kesalahan integrasi Stripe: $e';
    }
    _setLoading(false);
    return false;
  }

  // Refresh semua data harian
  Future<void> refreshAllData() async {
    if (_currentUser == null) return;
    await fetchDailyQuests();
    await fetchDailyWorkouts();
    await fetchDailyDiet();
    await fetchLeaderboard();
    await fetchAchievements();
  }

  // Logout
  void logout() {
    _currentUser = null;
    _token = null;
    _dailyQuests = [];
    _dailyWorkouts = [];
    _dailyDiet = [];
    _achievements = [];
    notifyListeners();
  }
}
