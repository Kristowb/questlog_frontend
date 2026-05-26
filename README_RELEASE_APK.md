# PANDUAN RILIS APK: QUESTLOG FRONTEND

Dokumen ini berisi panduan lengkap langkah demi langkah untuk membangun (*build*) APK rilis aplikasi QuestLog: Fitness & Feast dan mendistribusikannya secara gratis melalui **GitHub Releases**.

---

## DAFTAR ISI
1. [Prasyarat & Konfigurasi Awal](#1-prasyarat--konfigurasi-awal)
2. [Melakukan Build APK Rilis](#2-melakukan-build-apk-rilis)
3. [Mengunggah ke GitHub Releases](#3-mengunggah-ke-github-releases)
4. [Catatan Keamanan Penting](#4-catatan-keamanan-penting)

---

## 1. PRASYARAT & KONFIGURASI AWAL

Sebelum melakukan build rilis, pastikan Anda telah menyiapkan kunci penandatanganan (*keystore*) digital.

### A. Membuat Keystore (.jks)
Jika Anda belum memiliki file keystore, buat baru dengan menjalankan perintah berikut di terminal:
```bash
keytool -genkey -v -keystore d:\Code\AI\QuestLog\nama-keystore-anda.jks -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias key
```
*Catatan: Ingat kata sandi yang Anda masukkan selama proses pembuatan keystore.*

### B. Mengonfigurasi `key.properties`
Buat berkas bernama `key.properties` di dalam folder `questlog_frontend/android/` dan masukkan detail keystore Anda:
```properties
storePassword=kata_sandi_keystore_anda
keyPassword=kata_sandi_keystore_anda
keyAlias=key
storeFile=d:/Code/AI/QuestLog/nama-keystore-anda.jks
```
*(Gunakan garis miring `/` untuk pemisah path folder di Windows).*

---

## 2. MELAKUKAN BUILD APK RILIS

1. Buka terminal di direktori proyek `questlog_frontend`.
2. Jalankan perintah kompilasi rilis berikut:
   ```bash
   flutter build apk --split-per-abi
   ```
3. Flutter akan memproses kompilasi dan menghasilkan tiga berkas APK terpisah berdasarkan arsitektur CPU di folder:
   `questlog_frontend/build/app/outputs/flutter-apk/`
   
   * **`app-armeabi-v7a-release.apk`**: Untuk ponsel Android versi lama (32-bit).
   * **`app-arm64-v8a-release.apk`**: Untuk ponsel Android modern (64-bit). *Ini berkas yang paling sering diunduh oleh kebanyakan pengguna saat ini.*
   * **`app-x86_64-release.apk`**: Untuk perangkat Android dengan arsitektur x86_64 (seperti beberapa model tablet atau emulator).

---

## 3. MENGUNGGAH KE GITHUB RELEASES

Guna membagikan berkas APK Anda kepada publik secara gratis melalui GitHub:

1. Masuk ke akun GitHub Anda dan buka repositori Anda di:
   `https://github.com/Kristowb/questlog_frontend`
2. Pada panel navigasi kanan, temukan bagian **Releases** dan klik **Create a new release** (atau langsung akses tautan: `https://github.com/Kristowb/questlog_frontend/releases/new`).
3. **Konfigurasi Tag Versi**:
   - Klik **Choose a tag**.
   - Masukkan versi rilis Anda (contoh: `v1.0.0`) lalu klik **Create new tag: v1.0.0 on publish**.
   - Pilih cabang target (default: `main`).
4. **Judul & Deskripsi Rilis**:
   - Isi judul rilis (contoh: `QuestLog v1.0.0 - Dark RPG Premium UI`).
   - Masukkan deskripsi rilis atau daftar perubahan (*changelog*) menggunakan format Markdown.
5. **Unggah Berkas APK**:
   - Seret (*drag-and-drop*) ketiga berkas `.apk` hasil rilis dari folder `build/app/outputs/flutter-apk/` ke kotak unggahan di bagian bawah halaman GitHub.
   - Tunggu hingga proses unggahan selesai 100%.
6. **Publikasikan**:
   - Klik tombol **Publish release** berwarna hijau.
   - Selesai! Aplikasi Anda sekarang dapat diunduh secara bebas oleh publik melalui tab **Releases** repositori Anda.

---

## 4. CATATAN KEAMANAN PENTING

> [!WARNING]
> * **Jangan Unggah Keystore ke GitHub**: Berkas keystore `.jks` berisi kunci enkripsi privat Anda. Jangan pernah mengunggahnya ke GitHub agar tidak disalahgunakan oleh pihak lain.
> * **Amankan `key.properties`**: Berkas `key.properties` berisi kata sandi kunci Anda secara mentah (*plain text*). Pastikan berkas ini terdaftar di dalam berkas `.gitignore` proyek Anda agar tidak terunggah ke repositori GitHub.

---

## 5. TROUBLESHOOTING: GOOGLE SIGN-IN (PLATFORMEXCEPTION: SIGN_IN_FAILED 10)

Jika Anda mendapati error **`PlatformException(sign_in_failed, Google SDK Gagal: ..., 10)`** ketika memasang APK rilis di perangkat lain, hal ini disebabkan karena sidik jari (**SHA-1 fingerprint**) dari berkas keystore rilis Anda belum terdaftar di Google Cloud Console.

### A. Mengapa Ini Terjadi?
* **Saat Pengembangan (Emulator):** Flutter menggunakan keystore debug bawaan (`debug.keystore`) secara otomatis. Anda kemungkinan besar telah mendaftarkan SHA-1 debug ini di Google Cloud Console, sehingga pengetesan di emulator berhasil.
* **Saat Rilis (Device Lain):** Aplikasi dibangun sebagai APK rilis menggunakan berkas keystore rilis Anda (`nama-keystore-anda.jks`). Karena sidik jari SHA-1 dari keystore rilis ini berbeda dengan debug, server Google menolak permintaan masuk karena tanda tangan tidak cocok.

### B. Sidik Jari SHA-1 Anda
Berikut adalah sidik jari SHA-1 dan SHA-256 yang berhasil diekstrak dari proyek Anda:

#### 1. Keystore Rilis (`nama-keystore-anda.jks`)
* **Alias:** `key`
* **SHA-1:** `A8:88:DF:FD:94:B4:66:88:03:6C:77:8B:B0:2D:97:BA:09:19:5B:C1`
* **SHA-256:** `93:57:47:A0:19:43:92:95:23:25:F0:BA:AA:90:91:FD:BD:D5:E2:60:7E:B2:8F:36:16:AB:4E:BF:2A:B1:E8:7E`

#### 2. Keystore Debug (`debug.keystore` lokal)
* **Alias:** `androiddebugkey`
* **SHA-1:** `50:AD:42:9E:C4:5A:5F:49:04:69:A7:09:05:E2:FF:B8:56:0D:2F:9D`
* **SHA-256:** `B5:26:8F:D3:BA:A7:8D:64:E6:86:80:13:3A:97:E4:29:59:55:9D:D0:CE:1B:9B:D7:AB:D9:44:EF:85:F3:AD:6E`

### C. Langkah Solusi (Menyelesaikan Error)
Guna mendaftarkan sidik jari rilis di Google Cloud Console:

1. Buka **[Google Cloud Console Credentials](https://console.cloud.google.com/apis/credentials)**.
2. Pastikan Anda berada di proyek Google Cloud yang sesuai (misal: **`questlog-497314`**).
3. Di bawah bagian **OAuth 2.0 Client IDs**, klik **Create Credentials** -> **OAuth client ID**.
4. Konfigurasikan Client ID baru dengan detail berikut:
   * **Application type:** Android
   * **Name:** `QuestLog Android Release` (atau nama penanda lainnya)
   * **Package name:** `com.questlog.questlog_frontend` (harus sama persis dengan `applicationId` di `build.gradle.kts`)
   * **SHA-1 certificate fingerprint:** Masukkan SHA-1 rilis Anda:
     ```text
     A8:88:DF:FD:94:B4:66:88:03:6C:77:8B:B0:2D:97:BA:09:19:5B:C1
     ```
5. Klik **Create**.
6. *(Opsional)* Jika Anda menggunakan Firebase, buka **Firebase Console** -> **Project Settings** -> Pilih aplikasi Android Anda -> Klik **Add fingerprint**, lalu masukkan SHA-1 rilis di atas dan unduh kembali berkas `google-services.json` terbaru (jika proyek Anda menggunakan plugin Firebase).
7. Setelah didaftarkan, tunggu sekitar 5–10 menit agar perubahan konfigurasi diterapkan di server Google.
8. Lakukan instalasi ulang APK rilis di perangkat lain dan uji kembali fitur login.

