import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../config/app_config.dart';
import '../models/user.dart';
import '../models/quest.dart';
import '../models/workout_log.dart';
import '../models/diet_log.dart';
import '../models/achievement.dart';
import '../models/daily_boss.dart';
import '../services/api_client.dart';

class QuestLogProvider with ChangeNotifier {
  String _baseUrl = AppConfig.backendUrl;
  late final ApiClient _apiClient;
  
  User? _currentUser;
  String? _token;
  List<Quest> _dailyQuests = [];
  List<WorkoutLog> _dailyWorkouts = [];
  List<DietLog> _dailyDiet = [];
  List<User> _leaderboard = [];
  List<Achievement> _achievements = [];
  DailyBoss? _activeBoss;
  bool _isLoading = false;
  String? _errorMessage;

  QuestLogProvider() {
    _apiClient = ApiClient(baseUrl: _baseUrl);
  }

  // Getters
  User? get currentUser => _currentUser;
  String? get token => _token;
  List<Quest> get dailyQuests => _dailyQuests;
  List<WorkoutLog> get dailyWorkouts => _dailyWorkouts;
  List<DietLog> get dailyDiet => _dailyDiet;
  List<User> get leaderboard => _leaderboard;
  List<Achievement> get achievements => _achievements;
  DailyBoss? get activeBoss => _activeBoss;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setBaseUrl(String url) {
    _baseUrl = url;
    _apiClient.updateBaseUrl(url);
    notifyListeners();
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
      final response = await _apiClient.dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        _token = idToken; // Simpan token secara lokal
        _apiClient.updateToken(idToken); // Update token untuk interceptor ApiClient
        _currentUser = User.fromJson(response.data);
        await refreshAllData();
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Gagal masuk: ${response.data}';
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
      final response = await _apiClient.dio.post(
        '/users/${_currentUser!.id}/class',
        data: {'classType': classType.toUpperCase()},
      );

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.data);
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
      final response = await _apiClient.dio.get(
        '/users/${_currentUser!.id}',
      );
      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.data);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal refresh profil: $e');
    }
  }

  // Fetch Daily Quests
  Future<void> fetchDailyQuests() async {
    if (_currentUser == null) return;
    try {
      final response = await _apiClient.dio.get(
        '/quests/daily/${_currentUser!.id}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _dailyQuests = data.map((q) => Quest.fromJson(q)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal mengambil quest harian: $e');
    }
  }

  // Complete Quest
  Future<bool> completeQuest(int questId) async {
    _setLoading(true);
    try {
      final response = await _apiClient.dio.post(
        '/quests/$questId/complete',
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
      final response = await _apiClient.dio.get(
        '/workouts/daily/${_currentUser!.id}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _dailyWorkouts = data.map((w) => WorkoutLog.fromJson(w)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal mengambil latihan harian: $e');
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

      final response = await _apiClient.dio.post(
        '/workouts',
        data: log.toJson(),
      );

      if (response.statusCode == 200) {
        await refreshProfile();
        await fetchDailyWorkouts();
        await fetchDailyQuests(); // Update status quest jika ada kecocokan
        await fetchAchievements(); // Refresh pencapaian jika terbuka
        await fetchActiveBoss(); // Perbarui status boss setelah workout
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
      final response = await _apiClient.dio.get(
        '/diet/daily/${_currentUser!.id}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _dailyDiet = data.map((d) => DietLog.fromJson(d)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal mengambil data diet harian: $e');
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

      final response = await _apiClient.dio.post(
        '/diet',
        data: log.toJson(),
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
      final response = await _apiClient.dio.get(
        '/users/leaderboard',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _leaderboard = data.map((u) => User.fromJson(u)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal mengambil leaderboard: $e');
    }
  }

  // Fetch Achievements
  Future<void> fetchAchievements() async {
    if (_currentUser == null) return;
    try {
      final response = await _apiClient.dio.get(
        '/achievements/user/${_currentUser!.id}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _achievements = data.map((a) => Achievement.fromJson(a)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal mengambil pencapaian pahlawan: $e');
    }
  }

  // Buy Premium (Stripe PaymentSheet Built-in Native Overlay)
  Future<bool> buyPremium() async {
    if (_currentUser == null) return false;
    _setLoading(true);
    _errorMessage = null;
    try {
      // 1. Dapatkan PaymentIntent dari backend
      debugPrint('[QuestLogProvider] Mengambil PaymentIntent untuk user ID: ${_currentUser!.id}...');
      final response = await _apiClient.dio.post(
        '/premium/payment-intent',
        data: {'userId': _currentUser!.id},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final String clientSecret = data['paymentIntentClientSecret'];
        final String publishableKey = data['publishableKey'];
        debugPrint('[QuestLogProvider] Sukses mendapatkan PaymentIntent. clientSecret: $clientSecret, publishableKey: $publishableKey');

        // 2. Inisialisasi Stripe SDK
        debugPrint('[QuestLogProvider] Menginisialisasi Stripe SDK...');
        Stripe.publishableKey = publishableKey;
        await Stripe.instance.applySettings();

        // 3. Inisialisasi PaymentSheet
        debugPrint('[QuestLogProvider] Menginisialisasi PaymentSheet...');
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'QuestLog RPG',
            style: ThemeMode.dark,
          ),
        );
        debugPrint('[QuestLogProvider] Sukses menginisialisasi PaymentSheet.');

        // 4. Tampilkan PaymentSheet asli di aplikasi
        debugPrint('[QuestLogProvider] Menampilkan PaymentSheet...');
        await Stripe.instance.presentPaymentSheet();
        debugPrint('[QuestLogProvider] Pengguna menyelesaikan alur input di PaymentSheet.');

        // 5. Ekstrak PaymentIntent ID dari clientSecret untuk verifikasi server-side
        final String paymentIntentId = clientSecret.split('_secret_').first;

        // 6. Konfirmasi pembayaran ke backend secara aman
        debugPrint('[QuestLogProvider] Mengirim konfirmasi pembayaran ke server untuk PaymentIntentID: $paymentIntentId...');
        final confirmResponse = await _apiClient.dio.post(
          '/premium/confirm-payment',
          data: {
            'userId': _currentUser!.id,
            'paymentIntentId': paymentIntentId,
          },
        );

        if (confirmResponse.statusCode == 200) {
          _currentUser = User.fromJson(confirmResponse.data);
          notifyListeners();
          await refreshAllData();
          debugPrint('[QuestLogProvider] Pembayaran berhasil dikonfirmasi oleh backend. Status premium aktif!');
          _setLoading(false);
          return true;
        } else {
          _errorMessage = 'Gagal mengonfirmasi status premium di server.';
          debugPrint('[QuestLogProvider] Gagal mengonfirmasi pembayaran di server. Kode status: ${confirmResponse.statusCode}');
        }
      } else {
        _errorMessage = 'Gagal membuat sesi pembayaran di server.';
        debugPrint('[QuestLogProvider] Gagal mengambil PaymentIntent. Kode status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is StripeException) {
        _errorMessage = 'Pembayaran dibatalkan atau gagal: ${e.error.localizedMessage}';
        debugPrint('[QuestLogProvider] StripeException terjadi: ${e.error.localizedMessage} (Code: ${e.error.code}, Decls: ${e.error.stripeErrorCode})');
      } else {
        _errorMessage = 'Kesalahan integrasi Stripe: $e';
        debugPrint('[QuestLogProvider] Exception integrasi Stripe terjadi: $e');
      }
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
    await fetchActiveBoss();
  }

  // Fetch Daily Active Boss
  Future<void> fetchActiveBoss() async {
    if (_currentUser == null) return;
    try {
      final response = await _apiClient.dio.get(
        '/boss/active/${_currentUser!.id}',
      );
      if (response.statusCode == 200) {
        _activeBoss = DailyBoss.fromJson(response.data);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Gagal mengambil status Raid Boss harian: $e');
    }
  }

  // Claim Daily Boss Defeat Reward
  Future<bool> claimBossReward() async {
    if (_currentUser == null) return false;
    _setLoading(true);
    try {
      final response = await _apiClient.dio.post(
        '/boss/claim-reward/${_currentUser!.id}',
      );
      if (response.statusCode == 200) {
        await refreshProfile();
        await fetchActiveBoss();
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _errorMessage = 'Gagal mengklaim hadiah kemenangan bos harian: $e';
    }
    _setLoading(false);
    return false;
  }

  // Logout
  void logout() {
    _currentUser = null;
    _token = null;
    _apiClient.updateToken(null); // Reset token di ApiClient
    _dailyQuests = [];
    _dailyWorkouts = [];
    _dailyDiet = [];
    _achievements = [];
    _activeBoss = null;
    notifyListeners();
  }
}
