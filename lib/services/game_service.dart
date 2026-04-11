import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vs_game.dart';

class GameService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;
String? get currentUserId => _userId;


  /// Créer une nouvelle partie
  Future<String> createGame({required String challengeQuestion}) async {
    if (_userId == null) throw Exception('Non connecté');

    // Récupérer le nom du joueur
    final userDoc = await _db.collection('users').doc(_userId).get();
    final displayName = userDoc.data()?['displayName'];

    final doc = _db.collection('games').doc();

    await doc.set({
      'creatorId': _userId,
      'opponentId': null,
      'creatorName': displayName,
      'opponentName': null,
      'status': 'creatorPlaying',
      'creatorChoseChallenge': true,
      'challengeQuestion': challengeQuestion,
      'creatorAnswer': null,
      'opponentAnswer': null,
      'creatorScore': 0,
      'opponentScore': 0,
      'revangeRequest': 'none',
      'creatorSawRecap': false,
      'opponentSawRecap': false,
      'inviteCode': doc.id.substring(0, 8),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  /// Rejoindre une partie via code d'invitation
  Future<void> joinGame({required String inviteCode}) async {
    if (_userId == null) throw Exception('Non connecté');

    // Récupérer le nom du joueur
    final userDoc = await _db.collection('users').doc(_userId).get();
    final displayName = userDoc.data()?['displayName'];

    final query = await _db
        .collection('games')
        .where('inviteCode', isEqualTo: inviteCode)
        .where('opponentId', isNull: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) throw Exception('Partie introuvable');

    final doc = query.docs.first;

    await doc.reference.update({
      'opponentId': _userId,
      'opponentName': displayName,
    });
  }

  /// Soumettre la réponse du créateur + son score
  Future<void> submitCreatorTurn({
    required String gameId,
    required String answer,
    required int score,
  }) async {
    await _db.collection('games').doc(gameId).update({
      'creatorAnswer': answer,
      'creatorScore': score,
      'status': 'opponentTurn',
    });
  }

  /// Soumettre la réponse de l'adversaire + son score
  Future<void> submitOpponentTurn({
    required String gameId,
    required String answer,
    required int score,
  }) async {
    await _db.collection('games').doc(gameId).update({
      'opponentAnswer': answer,
      'opponentScore': score,
      'status': 'recapAvailable',
    });
  }

  /// Marquer le récap comme vu
  Future<void> markRecapSeen({required String gameId}) async {
    if (_userId == null) return;

    final doc = await _db.collection('games').doc(gameId).get();
    final data = doc.data();
    if (data == null) return;

    if (data['creatorId'] == _userId) {
      await doc.reference.update({'creatorSawRecap': true});
    } else {
      await doc.reference.update({'opponentSawRecap': true});
    }
  }

  /// Demander une revanche
  Future<void> requestRevange({required String gameId}) async {
    if (_userId == null) return;

    final doc = await _db.collection('games').doc(gameId).get();
    final data = doc.data();
    if (data == null) return;

    final isCreator = data['creatorId'] == _userId;

    await doc.reference.update({
      'revangeRequest': isCreator ? 'byCreator' : 'byOpponent',
    });
  }

  /// Accepter la revanche → créer une nouvelle partie avec rôles inversés
  Future<String> acceptRevange({required String gameId}) async {
    final doc = await _db.collection('games').doc(gameId).get();
    final data = doc.data();
    if (data == null) throw Exception('Partie introuvable');

    // Marquer l'ancienne partie comme terminée
    await doc.reference.update({'status': 'completed'});

    // Créer la nouvelle partie avec les rôles inversés
    final newDoc = _db.collection('games').doc();

    await newDoc.set({
      'creatorId': data['opponentId'],
      'opponentId': data['creatorId'],
      'creatorName': data['opponentName'],
      'opponentName': data['creatorName'],
      'status': 'creatorPlaying',
      'creatorChoseChallenge': true,
      'challengeQuestion': '',
      'creatorAnswer': null,
      'opponentAnswer': null,
      'creatorScore': 0,
      'opponentScore': 0,
      'revangeRequest': 'none',
      'creatorSawRecap': false,
      'opponentSawRecap': false,
      'inviteCode': newDoc.id.substring(0, 8),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newDoc.id;
  }

  /// Annuler une partie
  Future<void> cancelGame({required String gameId}) async {
    await _db.collection('games').doc(gameId).delete();
  }

  /// Écouter mes parties en temps réel
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


  /// Mettre à jour la question du défi
  Future<void> updateChallengeQuestion({
    required String gameId,
    required String question,
  }) async {
    await _db.collection('games').doc(gameId).update({
      'challengeQuestion': question,
    });
  }
    /// Récupérer une partie par code d'invitation
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
