import 'package:flutter/material.dart';
import 'challenge_select_screen.dart';

class ChallengeCreateScreen extends StatelessWidget {
  const ChallengeCreateScreen({super.key});

  static const Color figBackground = Color(0xFF231143);
  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  figBackground,
                  Color(0xFF1A0D36),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: -140,
            left: -80,
            right: -80,
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/logo_symbol_calc.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: figCream,
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'On lance un défi ?',
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      color: figCream,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Choisis quelqu’un, réponds à un défi,\npuis comparez vos réponses.',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 17,
                      color: Colors.white70,
                      height: 1.45,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChallengeSelectScreen(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: figBackground,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Continuer',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}