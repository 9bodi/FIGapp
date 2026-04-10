import 'package:flutter/material.dart';
import 'vs_screen.dart';
import 'quiz/quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color figBackground = Color(0xFF231143);
  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: figBackground,
      body: Stack(
        children: [
          // 🔥 LOGO EN FOND
          Positioned(
  bottom: -120,
  left: -60,
  right: -60,
  child: Opacity(
    opacity: 0.05,
    child: Image.asset(
      'assets/logo_symbol.png',
      fit: BoxFit.cover,
    ),
  ),
),

          // CONTENU
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔝 LOGO PRINCIPAL
                  Center(
                    child: Image.asset(
                      'assets/logo_full.png',
                      width: 140,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // 🧩 SOLO / VS
                  Row(
                    children: [
                      Expanded(
                        child: _FigCard(
                          title: "Solo",
                          subtitle: "Quizz",
                          icon: Icons.auto_awesome_rounded,
                          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SoloIntroPage(),
    ),
  );
},
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _FigCard(
                          title: "Défier",
                          subtitle: "Un.e ami.e",
                          icon: Icons.compare_arrows_rounded,
                          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const VsScreen(),
    ),
  );
},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 🎯 A TOI DE JOUER
                  const Text(
                    "À toi de jouer",
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: figCream,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const _GameCard(
                    title: "Camille",
                    subtitle: "T’attend pour continuer",
                  ),

                  const Spacer(),

                  // 🚀 CTA INVITER
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: figBackground,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Inviter quelqu’un",
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

class _FigCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FigCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Ink(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 25,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: figCream, size: 26),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Florisha',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: figCream,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _GameCard({
    required this.title,
    required this.subtitle,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: figCream.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.reply_rounded, // 👈 icône reprise
              color: figCream,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.w800,
                    color: figCream,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}