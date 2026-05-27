# QuestLog Frontend

Aplikasi mobile RPG untuk **QuestLog: Fitness & Feast** — dibangun menggunakan Flutter, Dart, dan Provider State Management.

---

## Arsitektur

```
UI (Screens) → Provider (ChangeNotifier) → Models (Entity) → REST API Backend
     ↑                                                          ↓
Widget Rebuild ←----------- Notifikasi Perubahan ←--------- JSON Parsing
```

### Struktur Paket

| Paket | Tanggung Jawab |
|-------|---------------|
| `models/` | Menampung kelas data / entitas utama (User, Quest, WorkoutLog, DietLog, Achievement) dengan parsing JSON (`fromJson`/`toJson`) |
| `providers/` | Mengelola *state* global (`QuestLogProvider`) menggunakan package `provider`, menangani request HTTP ke backend REST API, autentikasi, serta pemicuan penayangan perubahan status ke UI |
| `screens/` | Komponen layar UI berbasis Widget (Login, Home Dashboard, Workout Tracker, Diet Tracker, Leaderboard, Achievements, Premium Checkout) |

---

## Konvensi Kode

**State Binding & UI Sync** — Menggunakan `context.watch` untuk mendengarkan perubahan data, dan `context.read` untuk memicu aksi di dalam UI agar terhindar dari peringatan linting. Sinkronisasi data di-refresh secara otomatis setelah aksi penyelesaian quest, penambahan latihan, atau pencatatan diet.

```dart
// Mendengarkan perubahan data di dalam build method
final provider = context.watch<QuestLogProvider>();
final user = provider.currentUser;

// Menjalankan aksi asinkron di dalam event handler
void _onCompleteQuest(BuildContext context, String questId) async {
  final provider = context.read<QuestLogProvider>();
  await provider.completeQuest(questId);
}
```

**JSON Serialization** — Pemetaan data menggunakan model yang tangguh di dalam kelas model dengan validasi nilai fallback/default untuk mencegah kegagalan runtime (null safety).

```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? classType;
  final int level;
  final int strengthXp;
  final int vitalityXp;
  final int xpToNextLevel;
  final int coins;
  final bool isPremium;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.classType,
    required this.level,
    required this.strengthXp,
    required this.vitalityXp,
    required this.xpToNextLevel,
    required this.coins,
    required this.isPremium,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      classType: json['classType'],
      level: json['level'] ?? 1,
      strengthXp: json['strengthXp'] ?? 0,
      vitalityXp: json['vitalityXp'] ?? 0,
      xpToNextLevel: json['xpToNextLevel'] ?? 100,
      coins: json['coins'] ?? 0,
      isPremium: json['isPremium'] ?? false,
    );
  }
}
```

**Pemisahan Konfigurasi (Clean & DRY)** — Nilai-nilai penting seperti URL backend dan Client ID Google dipusatkan dalam kelas `AppConfig` agar tidak ada *hardcoding* di dalam widget UI.

```dart
final googleSignIn = GoogleSignIn(
  scopes: ['email'],
  serverClientId: AppConfig.googleClientId,
);
```

**Networking (Dio & ApiClient)** — Menggunakan `ApiClient` terpusat berbasis `Dio` dengan interceptor untuk secara otomatis menyisipkan otorisasi token JWT (`Bearer <token>`) di setiap request ke backend.

```dart
Future<Response> fetchUserData() async {
  return await _apiClient.dio.get('/users/${_currentUser!.id}');
}
```

---

## Stack

| Layer | Teknologi |
|-------|-----------|
| Runtime / SDK | Flutter SDK >= 3.10.4 (Direkomendasikan >= 3.22.0), Dart SDK |
| State Management | `provider` ^6.1.1 (ChangeNotifier) |
| Networking | `dio` ^5.4.3 (Menggantikan `http`) |
| Authentication | `google_sign_in` ^6.2.1 |
| UI Design & Anim | `google_fonts` ^6.2.1, `flutter_animate` ^4.5.0 |
| UI Indicators | `percent_indicator` ^4.2.3 (Circular & Linear indicator) |
| UI Charts | `fl_chart` ^0.66.0 (Grafik log latihan & diet) |
| Utility | `url_launcher` ^6.2.5 (Pembukaan URL Stripe Checkout) |

---

## Panduan Memulai

### 1. Prasyarat

Pastikan Anda telah menginstal Flutter SDK terbaru di mesin Anda. Jalankan perintah berikut untuk memverifikasi kesiapan lingkungan:

```bash
flutter doctor
```

### 2. Konfigurasi Endpoint Backend

Pada halaman login (`login_screen.dart`), terdapat input konfigurasi URL Backend Server.

- Gunakan `http://localhost:8080/api/v1` jika menjalankan aplikasi di browser/desktop/simulator Windows.
- Gunakan `http://10.0.2.2:8080/api/v1` jika menjalankan aplikasi di Android Emulator.
- Gunakan IP lokal mesin Anda (misal `http://192.168.1.x:8080/api/v1`) jika menggunakan perangkat fisik.

### 3. Mengambil Dependency

Jalankan perintah berikut untuk mengunduh semua package dependency yang terdaftar:

```bash
flutter pub get
```

### 4. Analisis Kode (Linter)

Proyek ini mempertahankan standar kualitas kode yang sangat ketat dan bebas dari semua peringatan linter (*lint warning-free*). Sebelum melakukan commit, selalu jalankan analisis statis untuk memastikan kualitas kode tetap terjaga:

```bash
flutter analyze
```

### 5. Menjalankan Aplikasi

Pilih perangkat target Anda (Emulator Android, iOS, Chrome, atau Windows) dan jalankan:

```bash
flutter run
```
