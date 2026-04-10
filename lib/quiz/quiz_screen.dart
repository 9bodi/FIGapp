import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../challenge/challenge_result_screen.dart';

enum CardKind { trueFalse, multipleChoice, estimation }

class QuizCardData {
  final CardKind kind;
  final String category;
  final String question;
  final List<String>? options;
  final int? correctIndex;
  final double? min;
  final double? max;
  final double? correctValue;
  final String answerLabel;
  final String revealTitle;
  final String revealText;

  const QuizCardData({
    required this.kind,
    required this.category,
    required this.question,
    required this.answerLabel,
    required this.revealTitle,
    required this.revealText,
    this.options,
    this.correctIndex,
    this.min,
    this.max,
    this.correctValue,
  });
}

const List<QuizCardData> demoCards = [
  QuizCardData(
    kind: CardKind.trueFalse,
    category: 'Mythe',
    question:
        'Pour des raisons biologiques, le désir sexuel est plus fort chez l’homme que chez la femme.',
    options: ['Faux', 'Vrai'],
    correctIndex: 0,
    answerLabel: 'Faux',
    revealTitle: 'Mythe très répandu',
    revealText:
        'Aucune base biologique ne prouve que les hommes auraient plus “besoin” de sexe. Ce mythe vient surtout de normes culturelles et d’une valorisation sociale du désir masculin.',
  ),
  QuizCardData(
    kind: CardKind.multipleChoice,
    category: 'Anatomie',
    question: 'Combien de terminaisons nerveuses le clitoris a-t-il ?',
    options: ['2 000', '5 000', '10 281', '20 000'],
    correctIndex: 2,
    answerLabel: '10 281',
    revealTitle: 'Réponse à retenir',
    revealText:
        'Le clitoris possède énormément de terminaisons nerveuses, ce qui en fait une zone majeure de sensibilité. C’est aussi un bon exemple de sujet longtemps invisibilisé dans l’éducation.',
  ),
  QuizCardData(
    kind: CardKind.estimation,
    category: 'Histoire',
    question:
        'En quelle année l’American Psychiatric Association a-t-elle retiré l’homosexualité de sa liste des troubles mentaux ?',
    min: 1900,
    max: 2025,
    correctValue: 1973,
    answerLabel: '1973',
    revealTitle: 'Date clé',
    revealText:
        'Cette décision est récente à l’échelle de l’histoire contemporaine. Elle rappelle que beaucoup de normes présentées comme “scientifiques” sont en réalité construites culturellement.',
  ),
];

class SoloIntroPage extends StatelessWidget {
  const SoloIntroPage({super.key});

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
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
                  'On ne t’a pas tout appris.',
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
                  '10 cartes pour questionner, comprendre\net voir autrement.',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 17,
                    color: Colors.white70,
                    height: 1.45,
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: _StartSessionCard(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SoloQuizPage(cards: demoCards),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoloQuizPage extends StatefulWidget {
  final List<QuizCardData> cards;
  final VoidCallback? onFinished;

  const SoloQuizPage({
    super.key,
    required this.cards,
    this.onFinished,
  });

  @override
  State<SoloQuizPage> createState() => _SoloQuizPageState();
}

class ChallengeQuizPage extends StatefulWidget {
  final List<QuizCardData> cards;
  final String challengeAnswer;

  const ChallengeQuizPage({
    super.key,
    required this.cards,
    required this.challengeAnswer,
  });

  @override
  State<ChallengeQuizPage> createState() => _ChallengeQuizPageState();
}

class _ChallengeQuizPageState extends State<ChallengeQuizPage> {
  @override
  Widget build(BuildContext context) {
    return SoloQuizPage(
      cards: widget.cards,
      onFinished: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeWaitingPage(
              challengeAnswer: widget.challengeAnswer,
            ),
          ),
        );
      },
    );
  }
}

class ChallengeWaitingPage extends StatelessWidget {
  final String challengeAnswer;

  const ChallengeWaitingPage({
    super.key,
    required this.challengeAnswer,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
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
                const Text(
                  'Ton défi est lancé, ta réponse est enregistrée, et ta série est terminée.\nÀ l’autre de jouer maintenant.',
                  style: TextStyle(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ta réponse',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white60,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        challengeAnswer,
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
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChallengeResultScreen(
                            challengeQuestion:
                                'Quelle petite révélation t’a récemment aidé·e à kiffer davantage ta sexualité ?',
                            myAnswer: challengeAnswer,
                            opponentAnswer:
                                'J’ai compris récemment que je pouvais arrêter de vouloir “bien faire” et commencer à me demander ce qui me faisait vraiment du bien.',
                            myScore: 6,
                            opponentScore: 4,
                          ),
                        ),
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
                      'Voir un recap test',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
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
      ),
    );
  }
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

    setState(() {
      answered = true;
    });

    _openReveal(isCorrect: isCorrect, estimationGap: diff.round());
  }

  void _openReveal({required bool isCorrect, int? estimationGap}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: const Color(0xFF231143),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
                      fontFamily: 'Helvetica',
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
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: figCream,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Réponse : '),
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
                    fontFamily: 'Helvetica',
                    fontSize: 16,
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
                        fontFamily: 'Helvetica',
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
  }

  String _feedbackLabel(bool isCorrect, int? estimationGap) {
    if (currentCard.kind == CardKind.estimation && estimationGap != null) {
      if (estimationGap <= 5) return 'Très proche';
      if (estimationGap <= 15) return 'Pas loin';
      return 'Date surprenante';
    }
    return isCorrect ? 'Bien vu' : 'Piège classique';
  }

  void _goNext() {
    if (currentIndex == widget.cards.length - 1) {
  if (widget.onFinished != null) {
    widget.onFinished!();
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SoloResultPage(
          totalCards: widget.cards.length,
          correctAnswers: correctAnswers,
        ),
      ),
    );
  }
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

    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
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
                        fontFamily: 'Helvetica',
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    _topPill(Icons.auto_awesome_outlined, currentCard.category),
                    const SizedBox(width: 10),
                    _topPill(
                      Icons.check_circle_outline_rounded,
                      '$correctAnswers',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(figCream),
                  ),
                ),
                const SizedBox(height: 18),
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
                        child: SlideTransition(
                          position: slide,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey(currentIndex),
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: figCream,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              currentCard.category.toUpperCase(),
                              style: const TextStyle(
                                color: figBackground,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Helvetica',
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentCard.question,
                            style: const TextStyle(
                              fontFamily: 'Florisha',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              height: 1.12,
                              color: figCream,
                            ),
                          ),
                          const Spacer(),
                          ..._buildAnswerArea(context),
                        ],
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
            if (i < options.length - 1) const SizedBox(height: 16),
          ],
        ];
      case CardKind.estimation:
        return [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
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
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          estimationValue.round().toString(),
                          style: const TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: figCream,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 16,
                    activeTrackColor: figCream,
                    inactiveTrackColor: Colors.white.withOpacity(0.12),
                    thumbColor: figCream,
                    overlayColor: figCream.withOpacity(0.12),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 15),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 24),
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: Slider(
                    value: estimationValue,
                    min: currentCard.min ?? 1900,
                    max: currentCard.max ?? 2025,
                    divisions:
                        ((currentCard.max ?? 2025) - (currentCard.min ?? 1900))
                            .round(),
                    onChanged: answered
                        ? null
                        : (value) {
                            setState(() {
                              estimationValue = value;
                            });
                          },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _estimateEdgeLabel(
                      '${(currentCard.min ?? 1900).round()}',
                    ),
                    _estimateEdgeLabel(
                      '${(currentCard.max ?? 2025).round()}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: answered ? null : _submitEstimation,
              style: FilledButton.styleFrom(
                backgroundColor: figCream,
                foregroundColor: figBackground,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Valider mon estimation',
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ];
    }
  }

  AnswerVisualState _choiceState(int optionIndex) {
    if (!answered) return AnswerVisualState.normal;
    if (optionIndex == currentCard.correctIndex) {
      return AnswerVisualState.correct;
    }
    if (selectedIndex == optionIndex) return AnswerVisualState.wrong;
    return AnswerVisualState.normal;
  }

  Widget _estimateEdgeLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Helvetica',
          color: Colors.white60,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _topPill(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: figCream),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.w700,
              color: figCream,
            ),
          ),
        ],
      ),
    );
  }
}

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
        'Rire, réfléchir, voir autrement.',
        'Tu viens d’aller au bout des $totalCards cartes, avec $score bonnes réponses au passage.\nLe plus intéressant n’était peut-être pas le score.'
      );
    }

    if (score <= 8) {
      return (
        'Quelques idées reçues en moins.',
        '$totalCards cartes plus tard, t’as mis juste sur $score.\nLe reste ? Disons que ça nourrit très bien la conversation.'
      );
    }

    return (
      'T’en sais déjà un peu plus.',
      'Tu viens de traverser $totalCards cartes, d’égratigner quelques idées reçues,\net d’en sortir avec $score/$totalCards.\nPas mal pour un sujet qu’on t’a rarement appris correctement.'
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _resultCopy();

    return Scaffold(
      body: _QuizBackground(
        child: SafeArea(
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SoloQuizPage(cards: demoCards),
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
                        fontFamily: 'Helvetica',
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
      ),
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
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
                  fontFamily: 'Helvetica',
                  fontSize: 18,
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
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: figCream,
                  size: 28,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Commencer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Florisha',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: figCream,
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
  static const Color figBackgroundDeep = Color(0xFF1A0D36);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                figBackground,
                figBackgroundDeep,
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
        child,
      ],
    );
  }
}
List<QuizCardData> getChallengeCards() {
  final shuffled = List<QuizCardData>.from(demoCards)..shuffle();
  return shuffled.take(5).toList();
}