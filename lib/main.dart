import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const FigApp());
}

class FigApp extends StatelessWidget {
  const FigApp({super.key});

  @override
  Widget build(BuildContext context) {
    const figBackground = Color(0xFF231143);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIG',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: figBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE9DFC8),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Helvetica',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}