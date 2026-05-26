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
