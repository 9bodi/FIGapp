import 'package:flutter/material.dart';
import 'theme/fig_theme.dart';
import 'services/auth_service.dart';
import 'screens/name_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color figBackground = FigColors.background;

  bool _started = false;
  bool _showFullLogo = false;
  bool _pulse = false;
  bool _moveUp = false;
  bool _fadeOut = false;
  bool _showSymbol = false;

  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();

    // Animation de respiration douce du logo symbole
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _breatheAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _breatheController,
        curve: Curves.easeInOut,
      ),
    );

    // Faire apparaître le symbole en fondu au démarrage
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showSymbol = true);
    });
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  Future<void> _startAnimation() async {
    if (_started) return;
    _started = true;

    // Stop la respiration
    _breatheController.stop();

    // Pulse au clic
    setState(() => _pulse = true);
    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;
    setState(() {
      _pulse = false;
      _moveUp = true;
    });

    // Attendre un peu avant de montrer le full logo
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _showFullLogo = true);

    // Laisser le full logo s'afficher plus longtemps
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;
    setState(() => _fadeOut = true);

    await Future.delayed(const Duration(milliseconds: 500));

    // Navigation
    final hasName = await AuthService().hasDisplayName();
    final destination = hasName ? const HomeScreen() : const NameScreen();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: figBackground,
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        opacity: _fadeOut ? 0 : 1,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _startAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: figBackground,
            child: Center(
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                offset: _moveUp ? const Offset(0, -0.03) : Offset.zero,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  scale: _pulse ? 1.08 : 1.0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final fade = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      );
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(fade);
                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(
                          position: slide,
                          child: child,
                        ),
                      );
                    },
                    child: _showFullLogo
                        ? Image.asset(
                            'assets/logo_full.png',
                            key: const ValueKey('full_logo'),
                            width: screenWidth * 0.74,
                            fit: BoxFit.contain,
                          )
                        : AnimatedOpacity(
                            duration: const Duration(milliseconds: 600),
                            opacity: _showSymbol ? 1.0 : 0.0,
                            child: AnimatedBuilder(
                              animation: _breatheAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _breatheAnimation.value,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                'assets/logo_symbol.png',
                                key: const ValueKey('symbol_logo'),
                                width: screenWidth * 0.42,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
