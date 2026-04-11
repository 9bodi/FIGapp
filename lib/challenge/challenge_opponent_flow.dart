import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/fig_theme.dart';
import '../services/game_service.dart';
import '../services/quiz_service.dart';
import '../models/quiz_card.dart';
import '../quiz/quiz_screen.dart';
import '../home_screen.dart';
import 'challenge_result_screen.dart';

class ChallengeOpponentFlow extends StatefulWidget {
  final String gameId;
  final String creatorName;
  final String challengeQuestion;
  final String status;

  const ChallengeOpponentFlow({
    super.key,
    required this.gameId,
    required this.creatorName,
    required this.challengeQuestion,
    required this.status,
  });

  @override
  State<ChallengeOpponentFlow> createState() => _ChallengeOpponentFlowState();
}

class _ChallengeOpponentFlowState extends State<ChallengeOpponentFlow> {
  final _answerController = TextEditingController();
  bool _answered = false;
  bool _loadingCards = false;
  List<QuizCardData>? _quizCards;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    if (_answerController.text.trim().isEmpty) return;

    setState(() {
      _answered = true;
      _loadingCards = true;
    });

    try {
      final cards = await QuizService().getChallengeCards();
      setState(() {
        _quizCards = cards;
        _loadingCards = false;
      });
    } catch (e) {
      setState(() {
        _quizCards = [];
        _loadingCards = false;
      });
    }
  }

  void _startQuiz() {
    if (_quizCards == null || _quizCards!.isEmpty) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OpponentQuizPage(
          gameId: widget.gameId,
          challengeAnswer: _answerController.text.trim(),
          cards: _quizCards!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status != 'opponentTurn') {
      return _WaitingForCreatorScreen(
        gameId: widget.gameId,
        creatorName: widget.creatorName,
      );
    }

    return _buildChallengeScreen();
  }

  Widget _buildChallengeScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [FigColors.background, FigColors.backgroundDeep],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  ),
                  icon: const Icon(Icons.close_rounded),
                  color: FigColors.cream,
                ),
                const SizedBox(height: 24),
                Text(
                  '${widget.creatorName} te défie !',
                  style: const TextStyle(
                    fontFamily: 'Florisha',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: FigColors.cream,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Le défi',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white54,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.challengeQuestion,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: FigColors.cream,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (!_answered) ...[
                  const Text(
                    'Ta réponse',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _answerController,
                    maxLines: 3,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: FigColors.cream,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Écris ta réponse ici…',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white.withOpacity(0.25),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: FigColors.cream),
                      ),
                    ),
                  ),
                ],
                if (_answered && _loadingCards)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: FigColors.cream),
                    ),
                  ),
                if (_answered && !_loadingCards)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: FigColors.cream,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Réponse enregistrée : "${_answerController.text.trim()}"',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _answered
                        ? (_loadingCards ? null : _startQuiz)
                        : _submitAnswer,
                    style: FilledButton.styleFrom(
                      backgroundColor: FigColors.cream,
                      foregroundColor: FigColors.background,
                      disabledBackgroundColor: FigColors.cream.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      _answered ? 'Jouer le quiz' : 'Valider ma réponse',
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
        ),
      ),
    );
  }
}

class _WaitingForCreatorScreen extends StatelessWidget {
  final String gameId;
  final String creatorName;

  const _WaitingForCreatorScreen({
    required this.gameId,
    required this.creatorName,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('games')
          .doc(gameId)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>?;

        if (data != null && data['status'] == 'opponentTurn') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChallengeOpponentFlow(
                  gameId: gameId,
                  creatorName: data['creatorName'] ?? creatorName,
                  challengeQuestion: data['challengeQuestion'] ?? '',
                  status: 'opponentTurn',
                ),
              ),
            );
          });
        }

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [FigColors.background, FigColors.backgroundDeep],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
                      icon: const Icon(Icons.close_rounded),
                      color: FigColors.cream,
                    ),
                    const Spacer(),
                    Text(
                      '$creatorName prépare son défi…',
                      style: const TextStyle(
                        fontFamily: 'Florisha',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                        color: FigColors.cream,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Tu as rejoint la partie !\nDès que l\'autre aura fini son tour, tu pourras jouer.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        color: Colors.white70,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Center(
                      child: CircularProgressIndicator(
                        color: FigColors.cream,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FigColors.cream,
                          side: BorderSide(
                            color: FigColors.cream.withOpacity(0.3),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
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
          ),
        );
      },
    );
  }
}

class OpponentQuizPage extends StatefulWidget {
  final String gameId;
  final String challengeAnswer;
  final List<QuizCardData> cards;

  const OpponentQuizPage({
    super.key,
    required this.gameId,
    required this.challengeAnswer,
    required this.cards,
  });

  @override
  State<OpponentQuizPage> createState() => _OpponentQuizPageState();
}

class _OpponentQuizPageState extends State<OpponentQuizPage> {
  bool _submitted = false;

  Future<void> _onQuizComplete(int score) async {
    if (_submitted) return;
    _submitted = true;

    try {
      await GameService().submitOpponentTurn(
        gameId: widget.gameId,
        answer: widget.challengeAnswer,
        score: score,
      );
    } catch (e) {
      debugPrint('Erreur soumission tour adversaire: $e');
    }

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => ChallengeResultScreen(gameId: widget.gameId),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SoloQuizPage(
      cards: widget.cards,
      onComplete: _onQuizComplete,
    );
  }
}
