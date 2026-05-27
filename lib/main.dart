import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/questlog_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestLogProvider()),
      ],
      child: const QuestLogApp(),
    ),
  );
}

class QuestLogApp extends StatelessWidget {
  const QuestLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuestLog: Fitness & Feast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07050E),
        primaryColor: const Color(0xFF00D4B2),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4B2),
          secondary: Color(0xFFE94057),
          surface: Color(0xFF0F0B1E),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontFamily: 'Inter'),
          bodyMedium: TextStyle(fontFamily: 'Inter'),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
