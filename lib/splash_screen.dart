import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'theme/fig_theme.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color figBackground = FigColors.background;


  bool _started = false;
  bool _showFullLogo = false;
  bool _pulse = false;
  bool _moveUp = false;
  bool _fadeOut = false;

  Future<void> _startAnimation() async {
    if (_started) return;
    _started = true;

    setState(() {
      _pulse = true;
    });

    await Future.delayed(const Duration(milliseconds: 220));

    if (!mounted) return;
    setState(() {
      _pulse = false;
      _moveUp = true;
      _showFullLogo = true;
    });

    await Future.delayed(const Duration(milliseconds: 1700));

    if (!mounted) return;
    setState(() {
      _fadeOut = true;
    });

    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
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
        duration: const Duration(milliseconds: 350),
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
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                offset: _moveUp ? const Offset(0, -0.02) : Offset.zero,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  scale: _pulse ? 1.06 : 1.0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 520),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final fade = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      );

                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.035),
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
                        : Image.asset(
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
    );
  }
}