import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_card.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Récupérer toutes les cartes quiz (usage interne)
  Future<List<QuizCardData>> getAllCards() async {
    final snap = await _db.collection('quizCards').get();

    return snap.docs.map((doc) {
      final d = doc.data();
      return QuizCardData(
        kind: _parseKind(d['kind']),
        category: d['category'] ?? '',
        question: d['question'] ?? '',
        options: d['options'] != null
            ? List<String>.from(d['options'])
            : null,
        correctIndex: d['correctIndex'],
        min: d['min']?.toDouble(),
        max: d['max']?.toDouble(),
        correctValue: d['correctValue']?.toDouble(),
        answerLabel: d['answerLabel'] ?? '',
        revealTitle: d['revealTitle'] ?? '',
        revealText: d['revealText'] ?? '',
      );
    }).toList();
  }

  /// Récupérer 5 cartes aléatoires pour le mode solo
  Future<List<QuizCardData>> getSoloCards({int count = 5}) async {
    final all = await getAllCards();
    all.shuffle();
    return all.take(count).toList();
  }

  /// Récupérer 5 cartes aléatoires pour un challenge
  Future<List<QuizCardData>> getChallengeCards({int count = 5}) async {
    final all = await getAllCards();
    all.shuffle();
    return all.take(count).toList();
  }

  /// Récupérer les prompts de défi
  Future<List<String>> getChallengePrompts() async {
    final snap = await _db
        .collection('challengePrompts')
        .orderBy('order')
        .get();

    return snap.docs.map((doc) => doc.data()['text'] as String).toList();
  }

  CardKind _parseKind(String? kind) {
    switch (kind) {
      case 'trueFalse':
        return CardKind.trueFalse;
      case 'multipleChoice':
        return CardKind.multipleChoice;
      case 'estimation':
        return CardKind.estimation;
      default:
        return CardKind.trueFalse;
    }
  }
}
