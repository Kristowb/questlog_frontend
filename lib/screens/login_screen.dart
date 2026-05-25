import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/questlog_provider.dart';
import 'class_selection_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mockController = TextEditingController();
  final TextEditingController _ipController = TextEditingController(text: 'http://localhost:8080/api/v1');

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
                          color: const Color(0xFFE94057).withOpacity(0.5),
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
                  ),
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
                  const SizedBox(height: 48),

                  // IP Configurator (Sangat penting jika testing di android emulator vs web vs windows)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1C2C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF38354D)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Backend Server URL:',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _ipController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                provider.setBaseUrl(_ipController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Base URL Backend diperbarui!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF38354D),
                                minimumSize: const Size(60, 30),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text('Simpan', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Google Login Button (Dengan visual yang premium)
                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            // Untuk pengujian Google Sign-In asli:
                            // final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
                            // final auth = await googleUser?.authentication;
                            // final token = auth?.idToken;
                            // Di sini kita trigger dengan Token asli jika tersedia, atau arahkan ke Mock
                            bool success = await provider.login('mock_token_Adventurer');
                            if (success && mounted) {
                              _handleLoginSuccess(context, provider);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.login, size: 24),
                              SizedBox(width: 12),
                              Text(
                                'Masuk dengan Google OAuth',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Divider
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFF38354D))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'ATAU COBA BYPASS LOKAL (MOCK)',
                          style: TextStyle(color: Color(0xFFA099B0), fontSize: 12),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFF38354D))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mock Name Input untuk bypass testing cepat
                  TextField(
                    controller: _mockController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama pahlawan Anda...',
                      hintStyle: const TextStyle(color: Color(0xFFA099B0), fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFF1E1C2C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF38354D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF38354D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF00D4B2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            String name = _mockController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Nama pahlawan tidak boleh kosong!')),
                              );
                              return;
                            }
                            bool success = await provider.login('mock_token_$name');
                            if (success && mounted) {
                              _handleLoginSuccess(context, provider);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1C2C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0xFF00D4B2), width: 1.5),
                      ),
                      elevation: 0,
                    ),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Color(0xFF00D4B2))
                        : const Text(
                            'Masuk secara Instan (Bypass Mock)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00D4B2),
                            ),
                          ),
                  ),
                  
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 24),
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

  void _handleLoginSuccess(BuildContext context, QuestLogProvider provider) {
    if (provider.currentUser?.classType == null) {
      // Belum pilih class
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClassSelectionScreen()),
      );
    } else {
      // Sudah ada class, masuk ke dashboard utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
