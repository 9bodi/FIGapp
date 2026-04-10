import 'package:flutter/material.dart';
import '../home_screen.dart';

class ChallengeResultScreen extends StatelessWidget {
  final String challengeQuestion;
  final String myAnswer;
  final String opponentAnswer;
  final int myScore;
  final int opponentScore;

  const ChallengeResultScreen({
    super.key,
    required this.challengeQuestion,
    required this.myAnswer,
    required this.opponentAnswer,
    required this.myScore,
    required this.opponentScore,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF231143),
                  Color(0xFF1A0D36),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // logo fond
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
                  // close
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.close_rounded),
                    color: figCream,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Même défi.\nDeux histoires.',
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: figCream,
                      height: 1.05,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _AnswerCard(
                    label: 'Toi',
                    text: myAnswer,
                  ),

                  const SizedBox(height: 14),

                  _AnswerCard(
                    label: 'L’autre',
                    text: opponentAnswer,
                  ),

                  const Spacer(),

                  Text(
                    'Tu fais $myScore/10. Lui $opponentScore/10.',
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 15,
                      color: Colors.white60,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        // TODO revanche flow
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: const Color(0xFF231143),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Revanche',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: figCream,
                        side: const BorderSide(color: Color(0x33E9DFC8)),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Retour accueil',
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

class _AnswerCard extends StatelessWidget {
  final String label;
  final String text;

  const _AnswerCard({
    required this.label,
    required this.text,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: figCream,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}