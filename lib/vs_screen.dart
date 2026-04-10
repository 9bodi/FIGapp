import 'package:flutter/material.dart';
import 'challenge/challenge_create_screen.dart';
import 'challenge/challenge_result_screen.dart';

enum VsGameStatus {
  myTurn,
  opponentTurn,
  recapReady,
}

class VsGamePreview {
  final String name;
  final VsGameStatus status;
  final String challengeQuestion;
  final String myAnswer;
  final String opponentAnswer;
  final int myScore;
  final int opponentScore;

  const VsGamePreview({
    required this.name,
    required this.status,
    required this.challengeQuestion,
    required this.myAnswer,
    required this.opponentAnswer,
    required this.myScore,
    required this.opponentScore,
  });
}

class VsScreen extends StatelessWidget {
  const VsScreen({super.key});

  static const Color figBackground = Color(0xFF231143);
  static const Color figCream = Color(0xFFE9DFC8);

  static const List<VsGamePreview> demoGames = [
    VsGamePreview(
      name: 'Camille',
      status: VsGameStatus.myTurn,
      challengeQuestion:
          'Quelle petite révélation t’a récemment aidé·e à kiffer davantage ta sexualité ?',
      myAnswer: '',
      opponentAnswer: '',
      myScore: 0,
      opponentScore: 0,
    ),
    VsGamePreview(
      name: 'Sarah',
      status: VsGameStatus.opponentTurn,
      challengeQuestion:
          'Raconte ton pire date ou le plan foireux le plus mythique de ta vie.',
      myAnswer:
          'J’ai raconté mon pire date en croyant être drôle, et finalement c’est surtout devenu un très bon filtre.',
      opponentAnswer: '',
      myScore: 5,
      opponentScore: 0,
    ),
    VsGamePreview(
      name: 'Léo',
      status: VsGameStatus.recapReady,
      challengeQuestion:
          'Quelle “idée reçue” sur le plaisir t’a toujours donné envie de hurler “FAUX !” ?',
      myAnswer:
          'L’idée qu’il faudrait savoir instinctivement quoi faire. Comme si parler cassait l’ambiance.',
      opponentAnswer:
          'Que le plaisir féminin serait “plus compliqué”. Souvent, c’est juste qu’on l’écoute moins.',
      myScore: 6,
      opponentScore: 4,
    ),
    VsGamePreview(
      name: 'Alex',
      status: VsGameStatus.opponentTurn,
      challengeQuestion:
          'Quelle petite révélation t’a récemment aidé·e à kiffer davantage ta sexualité ?',
      myAnswer:
          'Comprendre que je pouvais arrêter de performer et commencer à ressentir.',
      opponentAnswer: '',
      myScore: 7,
      opponentScore: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final actionableGames = demoGames
        .where(
          (game) =>
              game.status == VsGameStatus.myTurn ||
              game.status == VsGameStatus.recapReady,
        )
        .toList();

    final waitingGames = demoGames
        .where((game) => game.status == VsGameStatus.opponentTurn)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
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
                      Image.asset(
                        'assets/logo_full.png',
                        width: 90,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Défi',
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
                      fontFamily: 'Helvetica',
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
                    child: Row(
                      children: [
                        Expanded(
                          child: _VsColumn(
                            title: 'À toi',
                            items: actionableGames
                                .map(
                                  (game) => _VsMiniCard(
                                    game: game,
                                    onTap: () {
                                      _openGame(context, game);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _VsColumn(
                            title: 'En cours',
                            items: waitingGames
                                .map(
                                  (game) => _VsMiniCard(
                                    game: game,
                                    onTap: () {
                                      _openGame(context, game);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
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

  void _openGame(BuildContext context, VsGamePreview game) {
    switch (game.status) {
      case VsGameStatus.myTurn:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChallengeCreateScreen(),
          ),
        );
        break;
      case VsGameStatus.opponentTurn:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengePendingScreen(
              opponentName: game.name,
              challengeQuestion: game.challengeQuestion,
            ),
          ),
        );
        break;
      case VsGameStatus.recapReady:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeResultScreen(
              challengeQuestion: game.challengeQuestion,
              myAnswer: game.myAnswer,
              opponentAnswer: game.opponentAnswer,
              myScore: game.myScore,
              opponentScore: game.opponentScore,
            ),
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

  static const Color figCream = Color(0xFFE9DFC8);

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
                      fontFamily: 'Helvetica',
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
  final VsGamePreview game;
  final VoidCallback onTap;

  const _VsMiniCard({
    required this.game,
    required this.onTap,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  IconData get _icon {
    switch (game.status) {
      case VsGameStatus.myTurn:
        return Icons.reply_rounded;
      case VsGameStatus.opponentTurn:
        return Icons.more_horiz_rounded;
      case VsGameStatus.recapReady:
        return Icons.visibility_outlined;
    }
  }

  String get _label {
    switch (game.status) {
      case VsGameStatus.myTurn:
        return 'À toi de jouer';
      case VsGameStatus.opponentTurn:
        return 'À l’autre de jouer';
      case VsGameStatus.recapReady:
        return 'Voir vos réponses';
    }
  }

  bool get _highlight {
    return game.status == VsGameStatus.myTurn ||
        game.status == VsGameStatus.recapReady;
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
                    game.name,
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
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
                fontFamily: 'Helvetica',
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

  static const Color figCream = Color(0xFFE9DFC8);

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
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.compare_arrows_rounded,
                  color: figCream,
                  size: 26,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Nouvelle partie',
                  style: TextStyle(
                    fontFamily: 'Florisha',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: figCream,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choisis un défi, invite quelqu’un et joue.',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: figCream,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF231143),
                    ),
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

  static const Color figCream = Color(0xFFE9DFC8);

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
                colors: [
                  Color(0xFF231143),
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
                  const Spacer(),
                  const Text(
                    'À l’autre de jouer.',
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
                    '$opponentName n’a pas encore terminé son tour.\nLa partie reste là, en attente.',
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
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
                        fontFamily: 'Helvetica',
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
                        foregroundColor: const Color(0xFF231143),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Retour',
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