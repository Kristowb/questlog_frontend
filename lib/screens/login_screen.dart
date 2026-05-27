import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/app_config.dart';
import '../providers/questlog_provider.dart';
import 'class_selection_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleLoginSuccess(BuildContext context, QuestLogProvider provider) {
    if (provider.currentUser?.classType == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClassSelectionScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestLogProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F1235), // Dark purple
              Color(0xFF0F0B1E), // Darker violet
              Color(0xFF07050E), // Pure dark
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Icon RPG
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE94057).withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield,
                      size: 56,
                      color: Colors.white,
                    ),
                  ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  // Title
                  const Text(
                    'QUESTLOG',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'FITNESS & FEAST',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      color: Color(0xFF00D4B2), // Emerald-ish green
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ubah latihan keras & diet ketat harian Anda menjadi petualangan RPG legendaris!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Color(0xFFA099B0),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Divider "Or sign in with"
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFF38354D))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '- Masuk dengan -',
                          style: TextStyle(color: Color(0xFFA099B0), fontSize: 13),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFF38354D))),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Row Tombol Sosial Media
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Card
                      _buildSocialCard(
                        context: context,
                        onTap: provider.isLoading
                            ? null
                            : () async {
                                try {
                                  final googleSignIn = GoogleSignIn(
                                    scopes: ['email'],
                                    serverClientId: AppConfig.googleClientId,
                                  );
                                  final googleUser = await googleSignIn.signIn();
                                  if (googleUser != null) {
                                    final auth = await googleUser.authentication;
                                    final token = auth.idToken;
                                    if (token != null) {
                                      bool success = await provider.login(token);
                                      if (success && context.mounted) {
                                        _handleLoginSuccess(context, provider);
                                      }
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Gagal mendapatkan ID Token Google.')),
                                      );
                                      }
                                    }
                                  }
                                } catch (e) {
                                  debugPrint('Google Sign-In Error: $e');
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Google SDK Gagal: $e'),
                                    ),
                                  );
                                }
                              },
                        child: provider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFFEA4335),
                                ),
                              )
                            : const GoogleLogo(size: 26),
                      ),
                      const SizedBox(width: 20),

                      // Facebook Card (Placeholder)
                      _buildSocialCard(
                        context: context,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Masuk via Facebook segera hadir!')),
                          );
                        },
                        child: const Icon(
                          Icons.facebook,
                          color: Color(0xFF1877F2),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Twitter/X Card (Placeholder)
                      _buildSocialCard(
                        context: context,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Masuk via Twitter/X segera hadir!')),
                          );
                        },
                        child: const TwitterXLogo(size: 24),
                      ),
                    ],
                  ),
                  
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 32),
                    Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCard({
    required BuildContext context,
    required VoidCallback? onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

// Vector Google Logo Custom Painter
class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double strokeWidth = size.width * 0.22;

    final Paint paintRed = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint paintYellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint paintGreen = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint paintBlue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint paintBlueFill = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    canvas.drawArc(rect, -2.5, 1.9, false, paintRed);
    canvas.drawArc(rect, -3.9, 1.5, false, paintYellow);
    canvas.drawArc(rect, 0.7, 1.9, false, paintGreen);
    canvas.drawArc(rect, -0.6, 1.3, false, paintBlue);

    final double barLength = radius * 0.95;
    final double barThickness = strokeWidth * 0.95;
    final Rect barRect = Rect.fromLTWH(
      center.dx,
      center.dy - barThickness / 2,
      barLength,
      barThickness,
    );
    canvas.drawRect(barRect, paintBlueFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Vector Twitter/X Logo Custom Painter
class TwitterXLogo extends StatelessWidget {
  final double size;
  const TwitterXLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TwitterXLogoPainter(),
    );
  }
}

class _TwitterXLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.8),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
