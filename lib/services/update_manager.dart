import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ota_update/ota_update.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'toast_service.dart';

class UpdateManager {
  static const String _githubReleaseUrl =
      'https://api.github.com/repos/Kristowb/questlog_frontend/releases/latest';

  /// Memeriksa pembaruan dan menampilkan dialog jika versi baru tersedia.
  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      // 1. Ambil informasi versi aplikasi saat ini
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version; // Contoh: "1.0.0"

      // 2. Ambil informasi rilis terbaru dari GitHub
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      
      final response = await dio.get(_githubReleaseUrl);
      if (response.statusCode != 200 || response.data == null) {
        return;
      }

      final data = response.data;
      final String latestTagName = data['tag_name'] ?? ''; // Contoh: "v1.1.0" atau "1.1.0"
      final String releaseNotes = data['body'] ?? 'Tidak ada catatan rilis.';
      final List<dynamic> assets = data['assets'] ?? [];

      if (latestTagName.isEmpty) return;

      // Bersihkan versi dari prefiks 'v' jika ada
      final latestVersion = latestTagName.startsWith('v')
          ? latestTagName.substring(1)
          : latestTagName;

      // 3. Bandingkan versi
      if (_isNewerVersion(currentVersion, latestVersion)) {
        // Cari URL unduhan APK (cari yang sesuai arsitektur atau fallback ke aset pertama)
        String? downloadUrl;
        
        // Cari apk arm64-v8a yang paling umum untuk rilis modern
        for (var asset in assets) {
          final String name = asset['name'] ?? '';
          if (name.endsWith('.apk') && name.contains('arm64-v8a')) {
            downloadUrl = asset['browser_download_url'];
            break;
          }
        }

        // Jika tidak ditemukan arm64 secara spesifik, ambil APK apa saja yang tersedia
        if (downloadUrl == null) {
          for (var asset in assets) {
            final String name = asset['name'] ?? '';
            if (name.endsWith('.apk')) {
              downloadUrl = asset['browser_download_url'];
              break;
            }
          }
        }

        if (downloadUrl != null && context.mounted) {
          _showUpdateDialog(
            context,
            currentVersion: currentVersion,
            latestVersion: latestVersion,
            releaseNotes: releaseNotes,
            downloadUrl: downloadUrl,
          );
        }
      }
    } catch (e) {
      debugPrint('Gagal memeriksa pembaruan: $e');
    }
  }

  /// Membandingkan dua string versi (Format: X.Y.Z)
  static bool _isNewerVersion(String current, String latest) {
    try {
      final List<int> currentParts =
          current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final List<int> latestParts =
          latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      for (int i = 0; i < 3; i++) {
        final currentPart = i < currentParts.length ? currentParts[i] : 0;
        final latestPart = i < latestParts.length ? latestParts[i] : 0;
        if (latestPart > currentPart) return true;
        if (latestPart < currentPart) return false;
      }
    } catch (_) {}
    return false;
  }

  /// Menampilkan Dialog RPG Premium Pembaruan Aplikasi
  static void _showUpdateDialog(
    BuildContext context, {
    required String currentVersion,
    required String latestVersion,
    required String releaseNotes,
    required String downloadUrl,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false, // Mencegah ditutup dengan tombol back
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1F1235), // Dark purple
                    Color(0xFF0F0B1E), // Darker violet
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE94057).withValues(alpha: 0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE94057).withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // RPG Quest Header Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94057).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE94057), width: 1.5),
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: Color(0xFFE94057),
                        size: 40,
                      ),
                    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 16),

                    // RPG Quest Title
                    const Text(
                      'NEW QUEST AVAILABLE!',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      'Pembaruan Sistem Terdeteksi',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Color(0xFF00D4B2), // Emerald accent
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Version Compare Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildVersionBadge('LOKAL', currentVersion, const Color(0xFFA099B0)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(Icons.arrow_forward, color: Colors.white54, size: 16),
                        ),
                        _buildVersionBadge('BARU', latestVersion, const Color(0xFFE94057)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Release Notes Card
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'LOG PERUBAHAN:',
                        style: TextStyle(
                          color: Color(0xFFA099B0),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 120),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF07050E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2D2A42)),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          releaseNotes,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFA099B0),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'NANTI',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Install Button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF8A2387),
                                  Color(0xFFE94057),
                                  Color(0xFFF27121),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE94057).withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Tutup dialog pembaruan
                                _startDownload(context, downloadUrl);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'MULAI QUEST',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ).animate().scale(duration: 350.ms, curve: Curves.easeOutQuad),
        );
      },
    );
  }

  static Widget _buildVersionBadge(String label, String version, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'v$version',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Menjalankan proses pengunduhan OTA APK dan menampilkan Progress Dialog
  static void _startDownload(BuildContext context, String url) {
    final navigatorContext = context;
    final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
    final ValueNotifier<String> statusNotifier = ValueNotifier<String>('Memulai unduhan...');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false, // Jangan biarkan menutup secara paksa
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0B1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2D2A42)),
              ),
              child: ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (context, progressValue, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.download_for_offline,
                        color: Color(0xFF00D4B2),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'DOWNLOADING UPDATE...',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String>(
                        valueListenable: statusNotifier,
                        builder: (context, statusText, child) {
                          return Text(
                            statusText,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFFA099B0),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: const Color(0xFF07050E),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D4B2)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${(progressValue * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Color(0xFF00D4B2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    // Jalankan OTA Update
    try {
      OtaUpdate()
          .execute(
        url,
        destinationFilename: 'questlog_update.apk',
      )
          .listen(
        (OtaEvent event) {
          switch (event.status) {
            case OtaStatus.DOWNLOADING:
              final double progress = (double.tryParse(event.value ?? '0') ?? 0.0) / 100.0;
              progressNotifier.value = progress;
              statusNotifier.value = 'Mengunduh file sistem APK...';
              break;
            case OtaStatus.INSTALLING:
              statusNotifier.value = 'Membuka instalatur APK rilis...';
              Future.delayed(const Duration(seconds: 1), () {
                if (navigatorContext.mounted) {
                  Navigator.pop(navigatorContext); // Tutup dialog progress
                }
              });
              break;
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
              if (navigatorContext.mounted) {
                Navigator.pop(navigatorContext);
                _showSnackBar(navigatorContext, 'Izin instalasi APK tidak diberikan.');
              }
              break;
            case OtaStatus.DOWNLOAD_ERROR:
              if (navigatorContext.mounted) {
                Navigator.pop(navigatorContext);
                _showSnackBar(navigatorContext, 'Gagal mengunduh berkas APK. Silakan periksa koneksi internet Anda.');
              }
              break;
            case OtaStatus.INTERNAL_ERROR:
            default:
              if (navigatorContext.mounted) {
                Navigator.pop(navigatorContext);
                _showSnackBar(navigatorContext, 'Terjadi kesalahan sistem internal: ${event.value}');
              }
              break;
          }
        },
        onError: (err) {
          if (navigatorContext.mounted) {
            Navigator.pop(navigatorContext);
            _showSnackBar(navigatorContext, 'Gagal melakukan instalasi OTA: $err');
          }
        },
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      _showSnackBar(context, 'Error memulai OTA update: $e');
    }
  }

  static void _showSnackBar(BuildContext context, String message) {
    QuestLogToast.showError(context, message);
  }
}
