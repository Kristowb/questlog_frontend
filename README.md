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

**State Binding & UI Sync** — Menggunakan `Provider.of` untuk akses data dan pemicu aksi di dalam UI. Sinkronisasi data di-refresh secara otomatis setelah aksi penyelesaian quest, penambahan latihan, atau pencatatan diet.
```dart
final provider = Provider.of<QuestLogProvider>(context);
final user = provider.currentUser;

// Menjalankan aksi
await provider.completeQuest(quest.id);
```

**JSON Serialization** — Pemetaan data menggunakan model yang tangguh dengan validasi nilai fallback/default untuk mencegah kegagalan runtime (null safety).
```dart
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
  );
}
```

**Bypass Mock / Login OAuth** — Mendukung autentikasi menggunakan Google Sign-In asli serta opsi masuk instan (Bypass Mock) menggunakan nama kustom pahlawan untuk mempercepat siklus pengujian lokal.

---

## Stack

| Layer | Teknologi |
|-------|-----------|
| Runtime / SDK | Flutter SDK >= 3.10.4, Dart SDK |
| State Management | `provider` ^6.1.1 (ChangeNotifier) |
| Networking | `http` ^1.2.0 |
| Authentication | `google_sign_in` ^6.2.1 |
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

### 4. Menjalankan Aplikasi
Pilih perangkat target Anda (Emulator Android, iOS, Chrome, atau Windows) dan jalankan:
```bash
flutter run
```
