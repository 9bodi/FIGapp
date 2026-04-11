import 'package:flutter/material.dart';
import 'theme/fig_theme.dart';
import 'services/game_service.dart';
import 'vs_screen.dart';
import 'quiz/quiz_screen.dart';
import 'challenge/challenge_create_screen.dart';
import 'challenge/challenge_result_screen.dart';
import 'challenge/challenge_opponent_flow.dart';
import 'screens/join_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color figBackground = FigColors.background;
  static const Color figCream = FigColors.cream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: figBackground,
      body: Stack(
        children: [
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/logo_full.png',
                      width: 140,
                    ),
                  ),
                  const SizedBox(height: 36),
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
                          title: "D\u00e9fier",
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
                  const Text(
                    "\u00c0 toi de jouer",
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: figCream,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: GameService().watchMyGames(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: figCream,
                            ),
                          );
                        }

                        final games = snapshot.data ?? [];

                        if (games.isEmpty) {
                          return const _EmptyGamesCard();
                        }

                        return ListView.separated(
                          itemCount: games.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            final game = games[index];
                            return GestureDetector(
                              onTap: () => _openGame(context, game),
                              child: _GameCard(
                                title: game['opponentName'] ??
                                    'En attente\u2026',
                                subtitle: _statusLabel(game),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ChallengeCreateScreen(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: figBackground,
                        padding:
                            const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Inviter quelqu'un",
                        style: TextStyle(
                          fontFamily: 'Inter',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JoinScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: FigColors.cream,
                        side: BorderSide(
                          color: FigColors.cream.withOpacity(0.3),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Rejoindre une partie",
                        style: TextStyle(
                          fontFamily: 'Inter',
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

  void _openGame(BuildContext context, Map<String, dynamic> game) {
    final status = game['status'] ?? '';
    final gameId = game['id'] ?? '';
    final myId = GameService().currentUserId;
    final isCreator = game['creatorId'] == myId;

    switch (status) {
      case 'creatorPlaying':
        if (isCreator) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ChallengeCreateScreen(),
            ),
          );
        }
        break;
      case 'opponentTurn':
        if (isCreator) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChallengePendingScreen(
                opponentName:
                    game['opponentName'] ?? 'En attente\u2026',
                challengeQuestion:
                    game['challengeQuestion'] ?? '',
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChallengeOpponentFlow(
                gameId: gameId,
                creatorName:
                    game['creatorName'] ?? 'Adversaire',
                challengeQuestion:
                    game['challengeQuestion'] ?? '',
                status: 'opponentTurn',
              ),
            ),
          );
        }
        break;
      case 'recapAvailable':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ChallengeResultScreen(gameId: gameId),
          ),
        );
        break;
    }
  }

  String _statusLabel(Map<String, dynamic> game) {
    final myId = GameService().currentUserId;
    final isCreator = game['creatorId'] == myId;
    final revangeRequest = game['revangeRequest'] ?? 'none';

    final otherWantsRevange = isCreator
        ? revangeRequest == 'byOpponent'
        : revangeRequest == 'byCreator';

    if (otherWantsRevange && game['status'] == 'recapAvailable') {
      return 'Revanche ? \u2022 R\u00e9cap dispo';
    }

    switch (game['status']) {
      case 'creatorPlaying':
        return isCreator
            ? '\u00c0 toi de jouer'
            : 'En attente de l\u2019autre';
      case 'opponentTurn':
        return isCreator
            ? 'En attente de l\u2019autre'
            : '\u00c0 toi de jouer';
      case 'recapAvailable':
        return 'R\u00e9cap disponible';
      case 'completed':
        return 'Termin\u00e9e';
      default:
        return '';
    }
  }
}

class _EmptyGamesCard extends StatelessWidget {
  const _EmptyGamesCard();

  static const Color figCream = FigColors.cream;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sports_esports_outlined,
            color: Colors.white38,
            size: 32,
          ),
          SizedBox(height: 12),
          Text(
            'Aucune partie en cours',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Lance un d\u00e9fi pour commencer !',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Colors.white38,
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

  static const Color figCream = FigColors.cream;

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
                    fontFamily: 'Inter',
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

  static const Color figCream = FigColors.cream;

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
              Icons.reply_rounded,
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
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    color: figCream,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
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
