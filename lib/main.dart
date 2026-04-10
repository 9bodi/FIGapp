import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/seed_service.dart';
import 'splash_screen.dart';
import 'theme/fig_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connexion anonyme auto
  await AuthService().signInAnonymously();

  // Seed la base si vide
  await SeedService().seed();

  runApp(const FigApp());
}

class FigApp extends StatelessWidget {
  const FigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIG',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: FigColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FigColors.cream,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
