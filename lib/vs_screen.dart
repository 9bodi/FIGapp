import 'package:flutter/material.dart';
import 'theme/fig_theme.dart';
import 'services/game_service.dart';
import 'challenge/challenge_create_screen.dart';
import 'challenge/challenge_result_screen.dart';
import 'challenge/challenge_opponent_flow.dart';
import 'home_screen.dart';

class VsScreen extends StatelessWidget {
  const VsScreen({super.key});

  static const Color figBackground = FigColors.background;
  static const Color figCream = FigColors.cream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [figBackground, Color(0xFF1A0D36)],
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
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: figCream,
                      ),
                      const Spacer(),
                      Image.asset('assets/logo_full.png', width: 90),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'D\u00e9fi',
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: figCream,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Lance une partie et joue tout de suite.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PrimaryVsCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChallengeCreateScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
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

                        final actionableGames = games
                            .where((g) =>
                                g['status'] == 'creatorPlaying' ||
                                g['status'] == 'recapAvailable')
                            .toList();

                        final waitingGames = games
                            .where((g) => g['status'] == 'opponentTurn')
                            .toList();

                        return Row(
                          children: [
                            Expanded(
                              child: _VsColumn(
                                title: '\u00c0 toi',
                                items: actionableGames
                                    .map((game) => _VsMiniCard(
                                          game: game,
                                          onTap: () =>
                                              _openGame(context, game),
                                        ))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _VsColumn(
                                title: 'En cours',
                                items: waitingGames
                                    .map((game) => _VsMiniCard(
                                          game: game,
                                          onTap: () =>
                                              _openGame(context, game),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      },
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

    switch (status) {
      case 'creatorPlaying':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChallengeCreateScreen(),
          ),
        );
        break;
      case 'opponentTurn':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengePendingScreen(
              opponentName: game['opponentName'] ?? 'En attente\u2026',
              challengeQuestion: game['challengeQuestion'] ?? '',
            ),
          ),
        );
        break;
      case 'recapAvailable':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeResultScreen(gameId: gameId),
          ),
        );
        break;
    }
  }
}

class _VsColumn extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _VsColumn({
    required this.title,
    required this.items,
  });

  static const Color figCream = FigColors.cream;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Florisha',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: figCream,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: items.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: const Text(
                    'Rien pour le moment',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white54,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) => items[index],
                ),
        ),
      ],
    );
  }
}

class _VsMiniCard extends StatelessWidget {
  final Map<String, dynamic> game;
  final VoidCallback onTap;

  const _VsMiniCard({
    required this.game,
    required this.onTap,
  });

  static const Color figCream = FigColors.cream;

  IconData get _icon {
    switch (game['status']) {
      case 'creatorPlaying':
        return Icons.reply_rounded;
      case 'opponentTurn':
        return Icons.more_horiz_rounded;
      case 'recapAvailable':
        return Icons.visibility_outlined;
      default:
        return Icons.check_rounded;
    }
  }

  String get _label {
    switch (game['status']) {
      case 'creatorPlaying':
        return '\u00c0 toi de jouer';
      case 'opponentTurn':
        return '\u00c0 ${game['opponentName'] ?? 'l\'autre'} de jouer';
      case 'recapAvailable':
        return 'Voir le r\u00e9cap';
      default:
        return 'Termin\u00e9e';
    }
  }

  bool get _highlight {
    return game['status'] == 'creatorPlaying' ||
        game['status'] == 'recapAvailable';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: _highlight
              ? const Color(0x22E9DFC8)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _highlight
                ? const Color(0x55E9DFC8)
                : Colors.white.withOpacity(0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon, size: 18, color: figCream),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    game['opponentName'] ?? 'En attente\u2026',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: figCream,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: _highlight ? FontWeight.w700 : FontWeight.w600,
                color: _highlight ? figCream : Colors.white70,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryVsCard extends StatelessWidget {
  final VoidCallback onTap;

  const _PrimaryVsCard({required this.onTap});

  static const Color figCream = FigColors.cream;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.compare_arrows_rounded,
                  color: figCream,
                  size: 26,
                ),
                SizedBox(height: 18),
                Text(
                  'Nouvelle partie',
                  style: TextStyle(
                    fontFamily: 'Florisha',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: figCream,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Choisis un d\u00e9fi, invite quelqu\u2019un et joue.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.3,
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

class ChallengePendingScreen extends StatelessWidget {
  final String opponentName;
  final String challengeQuestion;

  const ChallengePendingScreen({
    super.key,
    required this.opponentName,
    required this.challengeQuestion,
  });

  static const Color figCream = FigColors.cream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [FigColors.background, FigColors.backgroundDeep],
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
                  const Spacer(),
                  const Text(
                    '\u00c0 l\u2019autre de jouer.',
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      color: figCream,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '$opponentName n\u2019a pas encore termin\u00e9 son tour.\nLa partie reste l\u00e0, en attente.',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      color: Colors.white70,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Text(
                      challengeQuestion,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: figCream,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: FigColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Retour',
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
}
