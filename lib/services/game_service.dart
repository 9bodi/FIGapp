import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;
  String? get currentUserId => _userId;

  // ── Créer une partie ──────────────────────────────────────────────
  Future<String> createGame() async {
    if (_userId == null) throw Exception('Non connecté');

    final userDoc = await _db.collection('users').doc(_userId).get();
    final displayName = userDoc.data()?['displayName'] ?? 'Joueur';

    final doc = await _db.collection('games').add({
      'creatorId': _userId,
      'creatorName': displayName,
      'creatorChoseChallenge': false,
      'challengeQuestion': '',
      'creatorAnswer': '',
      'creatorQuizScore': 0,
      'creatorScore': 0,
      'opponentId': null,
      'opponentName': '',
      'opponentAnswer': '',
      'opponentQuizScore': 0,
      'opponentScore': 0,
      'status': 'creatorPlaying',
      'revangeRequest': 'none',
      'creatorSawRecap': false,
      'opponentSawRecap': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final inviteCode = doc.id.substring(0, 8);
    await doc.update({'inviteCode': inviteCode});

    return doc.id;
  }

  // ── Rejoindre une partie ──────────────────────────────────────────
  Future<void> joinGame({required String inviteCode}) async {
    if (_userId == null) throw Exception('Non connecté');

    final query = await _db
        .collection('games')
        .where('inviteCode', isEqualTo: inviteCode)
        .where('opponentId', isNull: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) throw Exception('Partie introuvable ou déjà rejointe');

    final userDoc = await _db.collection('users').doc(_userId).get();
    final displayName = userDoc.data()?['displayName'] ?? 'Joueur';

    await query.docs.first.reference.update({
      'opponentId': _userId,
      'opponentName': displayName,
    });
  }

  // ── Tour du créateur ──────────────────────────────────────────────
  Future<void> submitCreatorTurn(
    String gameId,
    String answer, {
    int quizScore = 0,
  }) async {
    await _db.collection('games').doc(gameId).update({
      'creatorAnswer': answer,
      'creatorQuizScore': quizScore,
      'status': 'opponentTurn',
    });
  }

  // ── Tour de l'adversaire (calcule le gagnant de la manche) ───────
  Future<void> submitOpponentTurn(
    String gameId,
    String answer, {
    int quizScore = 0,
  }) async {
    // Récupérer les données actuelles de la partie
    final doc = await _db.collection('games').doc(gameId).get();
    final data = doc.data()!;

    final creatorQuizScore = (data['creatorQuizScore'] ?? 0) as int;
    int creatorScore = (data['creatorScore'] ?? 0) as int;
    int opponentScore = (data['opponentScore'] ?? 0) as int;

    // Déterminer le gagnant de cette manche
    if (creatorQuizScore > quizScore) {
      creatorScore += 1;
    } else if (quizScore > creatorQuizScore) {
      opponentScore += 1;
    }
    // En cas d'égalité, personne ne marque

    await _db.collection('games').doc(gameId).update({
      'opponentAnswer': answer,
      'opponentQuizScore': quizScore,
      'creatorScore': creatorScore,
      'opponentScore': opponentScore,
      'status': 'recapAvailable',
    });
  }

  // ── Marquer le récap comme vu ─────────────────────────────────────
  Future<void> markRecapSeen(String gameId) async {
    if (_userId == null) return;
    final doc = await _db.collection('games').doc(gameId).get();
    final data = doc.data();
    if (data == null) return;

    if (data['creatorId'] == _userId) {
      await _db.collection('games').doc(gameId).update({'creatorSawRecap': true});
    } else if (data['opponentId'] == _userId) {
      await _db.collection('games').doc(gameId).update({'opponentSawRecap': true});
    }
  }

  // ── Demander une revanche ─────────────────────────────────────────
  Future<void> requestRevange(String gameId) async {
    if (_userId == null) return;
    final doc = await _db.collection('games').doc(gameId).get();
    final data = doc.data();
    if (data == null) return;

    final value = data['creatorId'] == _userId ? 'byCreator' : 'byOpponent';
    await _db.collection('games').doc(gameId).update({'revangeRequest': value});
  }

  // ── Accepter une revanche (transférer les scores cumulés) ────────
  Future<String> acceptRevange(String gameId) async {
    if (_userId == null) throw Exception('Non connecté');

    final oldDoc = await _db.collection('games').doc(gameId).get();
    final oldData = oldDoc.data()!;

    // Récupérer les scores cumulés de la partie précédente
    final oldCreatorScore = (oldData['creatorScore'] ?? 0) as int;
    final oldOpponentScore = (oldData['opponentScore'] ?? 0) as int;
    final oldCreatorId = oldData['creatorId'] as String;
    final oldOpponentId = oldData['opponentId'] as String;
    final oldCreatorName = oldData['creatorName'] as String;
    final oldOpponentName = oldData['opponentName'] as String;

    // Marquer l'ancienne partie comme terminée
    await _db.collection('games').doc(gameId).update({'status': 'completed'});

    // Les rôles sont inversés : l'ancien adversaire devient le créateur
    // Les scores suivent les JOUEURS, pas les rôles
    // Nouveau créateur = ancien adversaire
    // Nouveau adversaire = ancien créateur
    final newDoc = await _db.collection('games').add({
      'creatorId': oldOpponentId,
      'creatorName': oldOpponentName,
      'creatorChoseChallenge': false,
      'challengeQuestion': '',
      'creatorAnswer': '',
      'creatorQuizScore': 0,
      // Le score du nouveau créateur = score de l'ancien adversaire
      'creatorScore': oldOpponentScore,
      'opponentId': oldCreatorId,
      'opponentName': oldCreatorName,
      'opponentAnswer': '',
      'opponentQuizScore': 0,
      // Le score du nouvel adversaire = score de l'ancien créateur
      'opponentScore': oldCreatorScore,
      'status': 'creatorPlaying',
      'revangeRequest': 'none',
      'creatorSawRecap': false,
      'opponentSawRecap': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final inviteCode = newDoc.id.substring(0, 8);
    await newDoc.update({'inviteCode': inviteCode});

    return newDoc.id;
  }

  // ── Annuler une partie ────────────────────────────────────────────
  Future<void> cancelGame(String gameId) async {
    await _db.collection('games').doc(gameId).delete();
  }

  // ── Observer mes parties en temps réel ────────────────────────────
  Stream<List<Map<String, dynamic>>> watchMyGames() {
    if (_userId == null) return const Stream.empty();

    return _db
        .collection('games')
        .where('status', isNotEqualTo: 'completed')
        .snapshots()
        .map((snap) {
      return snap.docs
          .where((doc) {
            final data = doc.data();
            return data['creatorId'] == _userId ||
                data['opponentId'] == _userId;
          })
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          })
          .toList();
    });
  }

  // ── Mettre à jour la question défi ────────────────────────────────
  Future<void> updateChallengeQuestion(String gameId, String question) async {
    await _db.collection('games').doc(gameId).update({
      'challengeQuestion': question,
      'creatorChoseChallenge': true,
    });
  }

  // ── Récupérer une partie par code d'invitation ────────────────────
  Future<Map<String, dynamic>> getGameByInviteCode(String inviteCode) async {
    final query = await _db
        .collection('games')
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) throw Exception('Partie introuvable');

    final doc = query.docs.first;
    final data = doc.data();
    data['id'] = doc.id;
    return data;
  }
}
