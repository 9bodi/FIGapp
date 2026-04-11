import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/fig_theme.dart';
import '../home_screen.dart';
import 'challenge_create_screen.dart';
import 'challenge_select_screen.dart';
import 'challenge_opponent_flow.dart';
import '../services/game_service.dart';

class ChallengeResultScreen extends StatefulWidget {
  final String gameId;

  const ChallengeResultScreen({
    super.key,
    required this.gameId,
  });

  @override
  State<ChallengeResultScreen> createState() => _ChallengeResultScreenState();
}

class _ChallengeResultScreenState extends State<ChallengeResultScreen> {
  bool _revangeRequested = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    GameService().markRecapSeen(gameId: widget.gameId);
  }

  Future<void> _navigateToNewGame() async {
    if (_navigating || !mounted) return;
    _navigating = true;

    try {
      final myId = GameService().currentUserId;

      final query = await FirebaseFirestore.instance
          .collection('games')
          .where('status', isNotEqualTo: 'completed')
          .get();

      final newGame = query.docs.where((doc) {
        final data = doc.data();
        return data['creatorId'] == myId || data['opponentId'] == myId;
      }).firstOrNull;

      if (newGame == null || !mounted) {
        _navigating = false;
        return;
      }

      final newData = newGame.data();
      final newGameId = newGame.id;
      final imNewCreator = newData['creatorId'] == myId;

      if (imNewCreator) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeSelectScreen(gameId: newGameId),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeOpponentFlow(
              gameId: newGameId,
              creatorName: newData['creatorName'] ?? 'Adversaire',
              challengeQuestion: newData['challengeQuestion'] ?? '',
              status: newData['status'] ?? 'creatorPlaying',
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Erreur navigation revanche: $e');
      _navigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('games')
          .doc(widget.gameId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return Scaffold(
            backgroundColor: FigColors.background,
            body: const Center(
              child: CircularProgressIndicator(color: FigColors.cream),
            ),
          );
        }

        final game = snapshot.data!.data() as Map<String, dynamic>;

        // Si la partie est passée en completed (l'autre a accepté la revanche)
        if (game['status'] == 'completed' && _revangeRequested) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToNewGame();
          });
          return Scaffold(
            backgroundColor: FigColors.background,
            body: const Center(
              child: CircularProgressIndicator(color: FigColors.cream),
            ),
          );
        }

        final creatorName = game['creatorName'] ?? 'Joueur 1';
        final opponentName = game['opponentName'] ?? 'Joueur 2';
        final creatorAnswer = game['creatorAnswer'] ?? '';
        final opponentAnswer = game['opponentAnswer'] ?? '';
        final creatorScore = game['creatorScore'] ?? 0;
        final opponentScore = game['opponentScore'] ?? 0;
        final challengeQuestion = game['challengeQuestion'] ?? '';
        final revangeRequest = game['revangeRequest'] ?? 'none';

        final myId = GameService().currentUserId;
        final isCreator = game['creatorId'] == myId;
        final myName = isCreator ? creatorName : opponentName;
        final otherName = isCreator ? opponentName : creatorName;
        final myAnswer = isCreator ? creatorAnswer : opponentAnswer;
        final otherAnswer = isCreator ? opponentAnswer : creatorAnswer;
        final myScore = isCreator ? creatorScore : opponentScore;
        final otherScore = isCreator ? opponentScore : creatorScore;

        final otherWantsRevange = isCreator
            ? revangeRequest == 'byOpponent'
            : revangeRequest == 'byCreator';
        final iRequestedRevange = isCreator
            ? revangeRequest == 'byCreator'
            : revangeRequest == 'byOpponent';

        String scoreLabel;
        if (myScore > otherScore) {
          scoreLabel = 'Tu mènes !';
        } else if (myScore < otherScore) {
          scoreLabel = 'Tu es mené·e.';
        } else {
          scoreLabel = 'Égalité.';
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
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            scoreLabel,
                            style: const TextStyle(
                              fontFamily: 'Florisha',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: FigColors.cream,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ScoreBadge(
                                  name: myName,
                                  score: myScore,
                                  isMe: true),
                              const SizedBox(width: 20),
                              const Text('—',
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 24)),
                              const SizedBox(width: 20),
                              _ScoreBadge(
                                  name: otherName,
                                  score: otherScore,
                                  isMe: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      challengeQuestion,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _AnswerCard(
                              label: 'Toi',
                              answer: myAnswer,
                              isMe: true,
                            ),
                            const SizedBox(height: 12),
                            _AnswerCard(
                              label: otherName,
                              answer: otherAnswer,
                              isMe: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (otherWantsRevange)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: FigColors.cream.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: FigColors.cream.withOpacity(0.2)),
                        ),
                        child: Text(
                          '$otherName veut une revanche !',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: FigColors.cream,
                          ),
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: (iRequestedRevange || _revangeRequested)
                            ? null
                            : () async {
                                if (otherWantsRevange) {
                                  final newGameId =
                                      await GameService().acceptRevange(
                                    gameId: widget.gameId,
                                  );
                                  if (!mounted) return;

                                  final newGameData =
                                      await FirebaseFirestore.instance
                                          .collection('games')
                                          .doc(newGameId)
                                          .get();
                                  final newData = newGameData.data();
                                  final imNewCreator =
                                      newData?['creatorId'] == myId;

                                  if (!mounted) return;

                                  if (imNewCreator) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChallengeSelectScreen(
                                          gameId: newGameId,
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChallengeOpponentFlow(
                                          gameId: newGameId,
                                          creatorName:
                                              newData?['creatorName'] ??
                                                  'Adversaire',
                                          challengeQuestion:
                                              newData?['challengeQuestion'] ??
                                                  '',
                                          status:
                                              newData?['status'] ??
                                                  'creatorPlaying',
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } else {
                                  await GameService().requestRevange(
                                    gameId: widget.gameId,
                                  );
                                  if (!mounted) return;
                                  setState(
                                      () => _revangeRequested = true);
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: FigColors.cream,
                          foregroundColor: FigColors.background,
                          disabledBackgroundColor:
                              FigColors.cream.withOpacity(0.4),
                          padding:
                              const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: Text(
                          otherWantsRevange
                              ? 'Accepter la revanche'
                              : (iRequestedRevange || _revangeRequested)
                                  ? 'Revanche demandée\u2026'
                                  : 'Revanche',
                          style: const TextStyle(
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
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FigColors.cream,
                          side: BorderSide(
                              color: FigColors.cream.withOpacity(0.3)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 20),
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

class _ScoreBadge extends StatelessWidget {
  final String name;
  final int score;
  final bool isMe;

  const _ScoreBadge({
    required this.name,
    required this.score,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$score',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: isMe ? FigColors.cream : Colors.white54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isMe ? 'Toi' : name,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isMe ? FigColors.cream : Colors.white54,
          ),
        ),
      ],
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final String label;
  final String answer;
  final bool isMe;

  const _AnswerCard({
    required this.label,
    required this.answer,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isMe ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(isMe ? 0.12 : 0.06),
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
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer.isEmpty ? '—' : answer,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: FigColors.cream,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
