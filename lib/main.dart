import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'theme/fig_theme.dart';


void main() {
  runApp(const FigApp());
}

class FigApp extends StatelessWidget {
  const FigApp({super.key});

  @override
  Widget build(BuildContext context) {
    const figBackground = FigColors.background;


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
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}