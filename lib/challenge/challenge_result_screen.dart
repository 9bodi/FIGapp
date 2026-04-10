import 'package:flutter/material.dart';
import '../theme/fig_theme.dart';
import '../home_screen.dart';
import 'challenge_select_screen.dart';

class ChallengeResultScreen extends StatefulWidget {
  final String challengeQuestion;
  final String myAnswer;
  final String opponentAnswer;
  final int myScore;
  final int opponentScore;

  /// Est-ce que c'est MOI qui ai choisi le défi ce tour-ci ?
  final bool iChoseThisRound;

  /// Est-ce que l'adversaire a déjà demandé revanche ?
  final bool opponentWantsRevange;

  const ChallengeResultScreen({
    super.key,
    required this.challengeQuestion,
    required this.myAnswer,
    required this.opponentAnswer,
    required this.myScore,
    required this.opponentScore,
    this.iChoseThisRound = true,
    this.opponentWantsRevange = false,
  });

  @override
  State<ChallengeResultScreen> createState() => _ChallengeResultScreenState();
}

class _ChallengeResultScreenState extends State<ChallengeResultScreen> {
  static const Color figBackground = FigColors.background;
  static const Color figCream = FigColors.cream;

  bool _revangeRequested = false;

  String get _scoreLabel {
    if (widget.myScore > widget.opponentScore) return 'Tu m\u00e8nes.';
    if (widget.myScore < widget.opponentScore) return 'Tu es men\u00e9\u00b7e.';
    return '\u00c9galit\u00e9.';
  }

  void _handleRevange() {
    if (widget.opponentWantsRevange) {
      // L'autre a déjà demandé → on lance directement
      _startRevange();
    } else {
      // On demande la revanche, en attente de l'autre
      setState(() {
        _revangeRequested = true;
      });

      // TODO: backend → enregistrer la demande de revanche
      // Pour la démo, on simule que l'autre accepte après 2 secondes
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _startRevange();
      });
    }
  }

  void _startRevange() {
    if (widget.iChoseThisRound) {
      // J'avais choisi le défi → c'est à l'AUTRE de choisir → j'attends
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const _RevangeWaitingScreen(),
        ),
        (route) => false,
      );
    } else {
      // L'autre avait choisi → c'est à MOI de choisir → je vais direct au select
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const ChallengeSelectScreen(),
        ),
        (route) => false,
      );
    }
  }

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
                colors: [
                  FigColors.background,
                  FigColors.backgroundDeep,
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
                    'M\u00eame d\u00e9fi.\nDeux histoires.',
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: figCream,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _scoreLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Score visuel
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Toi  ${widget.myScore}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: widget.myScore >= widget.opponentScore
                                ? figCream
                                : Colors.white54,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '\u2014',
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          '${widget.opponentScore}  L\u2019autre',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: widget.opponentScore >= widget.myScore
                                ? figCream
                                : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bandeau revanche demandée par l'autre
                  if (widget.opponentWantsRevange && !_revangeRequested)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0x22E9DFC8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0x55E9DFC8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: figCream,
                            size: 22,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'L\u2019autre veut sa revanche !',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                color: figCream,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Réponses
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _AnswerCard(
                            label: 'Toi',
                            text: widget.myAnswer,
                          ),
                          const SizedBox(height: 14),
                          _AnswerCard(
                            label: 'L\u2019autre',
                            text: widget.opponentAnswer,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bouton Revanche
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _revangeRequested ? null : _handleRevange,
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: figBackground,
                        disabledBackgroundColor:
                            Colors.white.withOpacity(0.08),
                        disabledForegroundColor: Colors.white38,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        _revangeRequested
                            ? 'Revanche demand\u00e9e\u2026'
                            : widget.opponentWantsRevange
                                ? 'Accepter la revanche'
                                : 'Revanche',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Bouton Retour
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

class _AnswerCard extends StatelessWidget {
  final String label;
  final String text;

  const _AnswerCard({
    required this.label,
    required this.text,
  });

  static const Color figCream = FigColors.cream;

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
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
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

/// Écran d'attente quand j'ai demandé revanche mais c'est à l'autre de choisir
class _RevangeWaitingScreen extends StatelessWidget {
  const _RevangeWaitingScreen();

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
                colors: [
                  FigColors.background,
                  FigColors.backgroundDeep,
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
                  const Spacer(),
                  const Text(
                    'Revanche accept\u00e9e.',
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      color: figCream,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'C\u2019est \u00e0 l\u2019autre de choisir le d\u00e9fi cette fois.\nTu recevras une notification quand ce sera ton tour.',
                    style: TextStyle(
                      fontFamily: 'Inter',
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: FigColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Retour accueil',
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
