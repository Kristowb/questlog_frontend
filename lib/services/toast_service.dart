import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/widget_previews.dart';

enum QuestLogToastType {
  success,
  error,
  info,
  warning,
}

class QuestLogToast {
  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, 'BERHASIL', QuestLogToastType.success, duration);
  }

  static void showError(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, 'GAGAL', QuestLogToastType.error, duration);
  }

  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, 'INFO', QuestLogToastType.info, duration);
  }

  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, 'PERINGATAN', QuestLogToastType.warning, duration);
  }

  static void _show(
    BuildContext context,
    String message,
    String title,
    QuestLogToastType type,
    Duration? duration,
  ) {
    if (!context.mounted) return;

    // Sembunyikan SnackBar yang sedang tampil agar tidak bertumpuk
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero, // Margin ditangani di dalam widget untuk responsivitas
        content: QuestLogToastWidget(
          title: title,
          message: message,
          type: type,
        ),
      ),
    );
  }
}

class QuestLogToastWidget extends StatelessWidget {
  final String title;
  final String message;
  final QuestLogToastType type;

  const QuestLogToastWidget({
    super.key,
    required this.title,
    required this.message,
    required this.type,
  });

  Color _getAccentColor() {
    switch (type) {
      case QuestLogToastType.success:
        return const Color(0xFF00D4B2); // Emerald-ish green
      case QuestLogToastType.error:
        return const Color(0xFFE94057); // Neon red-pink
      case QuestLogToastType.info:
        return const Color(0xFF8A2387); // Violet purple
      case QuestLogToastType.warning:
        return const Color(0xFFF27121); // Orange
    }
  }

  IconData _getIcon() {
    switch (type) {
      case QuestLogToastType.success:
        return Icons.check_circle_outline;
      case QuestLogToastType.error:
        return Icons.error_outline;
      case QuestLogToastType.info:
        return Icons.info_outline;
      case QuestLogToastType.warning:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();
    final icon = _getIcon();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420, // Menjaga lebar maksimum agar responsif di layar besar
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0F0B1E).withValues(alpha: 0.95),
                  const Color(0xFF07050E).withValues(alpha: 0.98),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  child: Row(
                    children: [
                      // Glow Icon Container
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Teks dengan perlindungan luapan (menggunakan Expanded)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: accentColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              message,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFFA099B0),
                                fontSize: 12.0,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Tutup
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white38, size: 16),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .animate()
          .fade(duration: 250.ms)
          .slideY(
            begin: 0.4,
            end: 0,
            duration: 350.ms,
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );
  }
}

// Preview untuk Widget Previewer
@Preview(name: 'Success Notification', group: 'QuestLog Notification Toast', size: Size(400, 100))
Widget previewSuccessToast() {
  return const QuestLogToastWidget(
    title: 'BERHASIL',
    message: 'Latihan keras Anda telah dicatat sebagai log!',
    type: QuestLogToastType.success,
  );
}

@Preview(name: 'Error Notification', group: 'QuestLog Notification Toast', size: Size(400, 100))
Widget previewErrorToast() {
  return const QuestLogToastWidget(
    title: 'GAGAL',
    message: 'Autentikasi gagal. Silakan periksa koneksi jaringan Anda.',
    type: QuestLogToastType.error,
  );
}

@Preview(name: 'Warning Notification', group: 'QuestLog Notification Toast', size: Size(400, 100))
Widget previewWarningToast() {
  return const QuestLogToastWidget(
    title: 'PERINGATAN',
    message: 'Fitur ini membutuhkan akses keanggotaan Premium.',
    type: QuestLogToastType.warning,
  );
}

@Preview(name: 'Info Notification', group: 'QuestLog Notification Toast', size: Size(400, 100))
Widget previewInfoToast() {
  return const QuestLogToastWidget(
    title: 'INFORMASI',
    message: 'Quest harian Anda akan di-reset dalam waktu 2 jam.',
    type: QuestLogToastType.info,
  );
}
