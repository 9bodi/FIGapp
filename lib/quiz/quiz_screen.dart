import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home_screen.dart';
import '../challenge/challenge_result_screen.dart';
import '../models/quiz_card.dart';
import '../data/demo_data.dart';
import '../theme/fig_theme.dart';
import '../services/quiz_service.dart';
import '../services/game_service.dart';

// ═══════════════════════════════════════════════════════════════════
//  SOLO INTRO
// ═══════════════════════════════════════════════════════════════════

class SoloIntroPage extends StatefulWidget {
  const SoloIntroPage({super.key});

  @override
  State<SoloIntroPage> createState() => _SoloIntroPageState();
}

class _SoloIntroPageState extends State<SoloIntroPage> {
  static const Color figCream = FigColors.cream;

  List<QuizCardData>? _cards;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      final cards = await QuizService().getAllCards();
      if (!mounted) return;
      setState(() => _cards = cards);
    } catch (e) {
      if (!mounted) return;
      setState(() => _cards = demoCards);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                        'On ne t\u2019a pas tout appris.',
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
                        _cards != null
                            ? '${_cards!.length} cartes pour questionner, comprendre\net voir autrement.'
                            : 'Chargement\u2026',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          color: Colors.white70,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 60),
                      if (_cards != null)
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: _StartSessionCard(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SoloQuizPage(cards: _cards!),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      if (_cards == null)
                        const Center(
                          child: CircularProgressIndicator(color: FigColors.cream),
                        ),
                      SizedBox(height: 40 + bottomPadding),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SOLO QUIZ PAGE
// ═══════════════════════════════════════════════════════════════════

class SoloQuizPage extends StatefulWidget {
  final List<QuizCardData> cards;
  final VoidCallback? onFinished;
  final Future<void> Function(int score)? onComplete;

  const SoloQuizPage({
    super.key,
    required this.cards,
    this.onFinished,
    this.onComplete,
  });

  @override
  State<SoloQuizPage> createState() => _SoloQuizPageState();
}

class _SoloQuizPageState extends State<SoloQuizPage> {
  static const Color figBackground = Color(0xFF231143);
  static const Color figCream = Color(0xFFE9DFC8);

  int currentIndex = 0;
  int correctAnswers = 0;
  int? selectedIndex;
  bool answered = false;
  double estimationValue = 1960;

  QuizCardData get currentCard => widget.cards[currentIndex];

  @override
  void initState() {
    super.initState();
    _resetCardState();
  }

  void _resetCardState() {
    final card = widget.cards[currentIndex];
    selectedIndex = null;
    answered = false;
    if (card.kind == CardKind.estimation) {
      estimationValue = ((card.min ?? 1900) + (card.max ?? 2025)) / 2;
    }
    setState(() {});
  }

  void _submitChoice(int index) {
    if (answered) return;
    final isCorrect = index == currentCard.correctIndex;
    if (isCorrect) correctAnswers += 1;

    setState(() {
      selectedIndex = index;
      answered = true;
    });

    _openReveal(isCorrect: isCorrect);
  }

  void _submitEstimation() {
    if (answered) return;
    final diff = (estimationValue - (currentCard.correctValue ?? 0)).abs();
    final isCorrect = diff <= 5;
    if (isCorrect) correctAnswers += 1;

    setState(() => answered = true);

    _openReveal(isCorrect: isCorrect, estimationGap: diff.round());
  }

  void _openReveal({required bool isCorrect, int? estimationGap}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF231143),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              top: false,
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? const Color(0x22E9DFC8)
                            : Colors.white.withOpacity(0.05),
                        border: Border.all(
                          color: isCorrect
                              ? const Color(0x66E9DFC8)
                              : Colors.white.withOpacity(0.08),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        _feedbackLabel(isCorrect, estimationGap),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE9DFC8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      currentCard.revealTitle,
                      style: const TextStyle(
                        fontFamily: 'Florisha',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: figCream,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'R\u00e9ponse : '),
                          TextSpan(
                            text: currentCard.answerLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentCard.revealText,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _goNext();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: figCream,
                          foregroundColor: figBackground,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          currentIndex == widget.cards.length - 1
                              ? 'Voir le bilan'
                              : 'Carte suivante',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _feedbackLabel(bool isCorrect, int? estimationGap) {
    if (currentCard.kind == CardKind.estimation && estimationGap != null) {
      if (estimationGap <= 5) return 'Tr\u00e8s proche';
      if (estimationGap <= 15) return 'Pas loin';
      return 'Date surprenante';
    }
    return isCorrect ? 'Bien vu' : 'Pi\u00e8ge classique';
  }

  Future<void> _goNext() async {
    if (currentIndex == widget.cards.length - 1) {
      if (widget.onComplete != null) {
        await widget.onComplete!(correctAnswers);
        return;
      }
      if (widget.onFinished != null) {
        widget.onFinished!();
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SoloResultPage(
            totalCards: widget.cards.length,
            correctAnswers: correctAnswers,
          ),
        ),
      );
      return;
    }

    setState(() {
      currentIndex += 1;
      final card = widget.cards[currentIndex];
      selectedIndex = null;
      answered = false;
      if (card.kind == CardKind.estimation) {
        estimationValue = ((card.min ?? 1900) + (card.max ?? 2025)) / 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / widget.cards.length;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 12 + bottomPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: figCream,
                    ),
                    Text(
                      'Carte ${currentIndex + 1}/${widget.cards.length}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    _topPill(Icons.auto_awesome_outlined, currentCard.category),
                    const SizedBox(width: 8),
                    _topPill(Icons.check_circle_outline_rounded, '$correctAnswers'),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(figCream),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final fade = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      );
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.02),
                        end: Offset.zero,
                      ).animate(fade);
                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
                    child: Container(
                      key: ValueKey(currentIndex),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: figCream,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                currentCard.category.toUpperCase(),
                                style: const TextStyle(
                                  color: figBackground,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentCard.question,
                              style: const TextStyle(
                                fontFamily: 'Florisha',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.12,
                                color: figCream,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ..._buildAnswerArea(context),
                          ],
                        ),
                      ),
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

  List<Widget> _buildAnswerArea(BuildContext context) {
    switch (currentCard.kind) {
      case CardKind.trueFalse:
      case CardKind.multipleChoice:
        final options = currentCard.options ?? [];
        return [
          for (int i = 0; i < options.length; i++) ...[
            AnswerButton(
              text: options[i],
              state: _choiceState(i),
              enabled: !answered,
              onTap: () => _submitChoice(i),
            ),
            if (i < options.length - 1) const SizedBox(height: 12),
          ],
        ];
      case CardKind.estimation:
        return [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Ton estimation',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          estimationValue.round().toString(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: figCream,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 12,
                    activeTrackColor: figCream,
                    inactiveTrackColor: Colors.white.withOpacity(0.12),
                    thumbColor: figCream,
                    overlayColor: figCream.withOpacity(0.12),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: Slider(
                    value: estimationValue,
                    min: currentCard.min ?? 1900,
                    max: currentCard.max ?? 2025,
                    divisions: ((currentCard.max ?? 2025) - (currentCard.min ?? 1900)).round(),
                    onChanged: answered ? null : (value) => setState(() => estimationValue = value),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _estimateEdgeLabel('${(currentCard.min ?? 1900).round()}'),
                    _estimateEdgeLabel('${(currentCard.max ?? 2025).round()}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: answered ? null : _submitEstimation,
              style: FilledButton.styleFrom(
                backgroundColor: figCream,
                foregroundColor: figBackground,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                'Valider',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ];
    }
    return [];
  }

  AnswerVisualState _choiceState(int optionIndex) {
    if (!answered) return AnswerVisualState.normal;
    if (optionIndex == currentCard.correctIndex) return AnswerVisualState.correct;
    if (selectedIndex == optionIndex) return AnswerVisualState.wrong;
    return AnswerVisualState.normal;
  }

  Widget _estimateEdgeLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Colors.white60,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _topPill(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: figCream),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: figCream,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CHALLENGE QUIZ PAGE (créateur – passe le score au waiting)
// ═══════════════════════════════════════════════════════════════════

class ChallengeQuizPage extends StatefulWidget {
  final List<QuizCardData> cards;
  final String challengeAnswer;
  final String? gameId;

  const ChallengeQuizPage({
    super.key,
    required this.cards,
    required this.challengeAnswer,
    this.gameId,
  });

  @override
  State<ChallengeQuizPage> createState() => _ChallengeQuizPageState();
}

class _ChallengeQuizPageState extends State<ChallengeQuizPage> {
  int _quizScore = 0;

  @override
  Widget build(BuildContext context) {
    return SoloQuizPage(
      cards: widget.cards,
      onComplete: (score) async {
        _quizScore = score;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeWaitingPage(
              challengeAnswer: widget.challengeAnswer,
              gameId: widget.gameId,
              quizScore: _quizScore,
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CHALLENGE WAITING PAGE (attend le tour de l'adversaire)
// ═══════════════════════════════════════════════════════════════════

class ChallengeWaitingPage extends StatefulWidget {
  final String challengeAnswer;
  final String? gameId;
  final int quizScore;

  const ChallengeWaitingPage({
    super.key,
    required this.challengeAnswer,
    this.gameId,
    this.quizScore = 0,
  });

  @override
  State<ChallengeWaitingPage> createState() => _ChallengeWaitingPageState();
}

class _ChallengeWaitingPageState extends State<ChallengeWaitingPage> {
  static const Color figCream = FigColors.cream;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _submitTurn();
  }

  Future<void> _submitTurn() async {
    if (widget.gameId == null) return;
    try {
      await GameService().submitCreatorTurn(
        widget.gameId!,
        widget.challengeAnswer,
        quizScore: widget.quizScore,
      );
    } catch (e) {
      debugPrint('Erreur soumission tour: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameId != null) {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('games')
            .doc(widget.gameId)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;

          if (data != null &&
              data['status'] == 'recapAvailable' &&
              !_navigated) {
            _navigated = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => ChallengeResultScreen(
                    gameId: widget.gameId!,
                  ),
                ),
                (route) => false,
              );
            });
          }

          return _buildWaitingUI(context);
        },
      );
    }

    return _buildWaitingUI(context);
  }

  Widget _buildWaitingUI(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                      const SizedBox(height: 60),
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
                      const Text(
                        'Ton d\u00e9fi est lanc\u00e9, ta r\u00e9ponse est enregistr\u00e9e, et ta s\u00e9rie est termin\u00e9e.\n\u00c0 l\u2019autre de jouer maintenant.',
                        style: TextStyle(
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
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ta r\u00e9ponse',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white60,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.challengeAnswer,
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
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Container(
                color: FigColors.background,
                padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottomPadding),
                child: SizedBox(
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
                      foregroundColor: const Color(0xFF231143),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SOLO RESULT PAGE
// ═══════════════════════════════════════════════════════════════════

class SoloResultPage extends StatelessWidget {
  final int totalCards;
  final int correctAnswers;

  const SoloResultPage({
    super.key,
    required this.totalCards,
    required this.correctAnswers,
  });

  static const Color figBackground = Color(0xFF231143);
  static const Color figCream = Color(0xFFE9DFC8);

  (String title, String text) _resultCopy() {
    final score = correctAnswers;

    if (score <= 4) {
      return (
        'Rire, r\u00e9fl\u00e9chir, voir autrement.',
        'Tu viens d\u2019aller au bout des $totalCards cartes, avec $score bonnes r\u00e9ponses au passage.\nLe plus int\u00e9ressant n\u2019\u00e9tait peut-\u00eatre pas le score.'
      );
    }

    if (score <= 8) {
      return (
        'Quelques id\u00e9es re\u00e7ues en moins.',
        '$totalCards cartes plus tard, t\u2019as mis juste sur $score.\nLe reste ? Disons que \u00e7a nourrit tr\u00e8s bien la conversation.'
      );
    }

    return (
      'T\u2019en sais d\u00e9j\u00e0 un peu plus.',
      'Tu viens de traverser $totalCards cartes, d\u2019\u00e9gratigner quelques id\u00e9es re\u00e7ues,\net d\u2019en sortir avec $score/$totalCards.\nPas mal pour un sujet qu\u2019on t\u2019a rarement appris correctement.'
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _resultCopy();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.close_rounded),
                        color: figCream,
                      ),
                      const SizedBox(height: 60),
                      Text(
                        result.$1,
                        style: const TextStyle(
                          fontFamily: 'Florisha',
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                          color: figCream,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        result.$2,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          color: Colors.white70,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Container(
                color: FigColors.background,
                padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottomPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SoloIntroPage(),
                            ),
                            (route) => false,
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
                          'Rejouer',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  WIDGETS UTILITAIRES
// ═══════════════════════════════════════════════════════════════════

enum AnswerVisualState { normal, correct, wrong }

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool enabled;
  final AnswerVisualState state;

  const AnswerButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.enabled,
    required this.state,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    Color background;
    Color border;

    switch (state) {
      case AnswerVisualState.correct:
        background = const Color(0x22E9DFC8);
        border = const Color(0x66E9DFC8);
        break;
      case AnswerVisualState.wrong:
        background = Colors.white.withOpacity(0.025);
        border = Colors.white.withOpacity(0.06);
        break;
      case AnswerVisualState.normal:
        background = Colors.white.withOpacity(0.05);
        border = Colors.white.withOpacity(0.08);
        break;
    }

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: figCream,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartSessionCard extends StatelessWidget {
  final VoidCallback onTap;

  const _StartSessionCard({required this.onTap});

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Column(
              children: [
                Icon(Icons.auto_awesome_rounded, color: figCream, size: 28),
                SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Commencer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: figCream,
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

class _QuizBackground extends StatelessWidget {
  final Widget child;

  const _QuizBackground({required this.child});

  static const Color figBackground = Color(0xFF231143);
  static const Color figBackgroundDeep = FigColors.backgroundDeep;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [figBackground, figBackgroundDeep],
            ),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -80,
          right: -80,
          child: Opacity(
            opacity: 0.05,
            child: Image.asset('assets/logo_symbol_calc.png', fit: BoxFit.cover),
          ),
        ),
        child,
      ],
    );
  }
}
