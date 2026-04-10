enum VsGameStatus {
  /// J'ai créé la partie, j'ai pas encore joué
  creatorPlaying,

  /// J'ai fini, l'autre doit jouer
  opponentTurn,

  /// L'autre a fini, je dois voir le recap
  recapAvailable,

  /// Les deux ont vu le recap
  completed,
}

enum RevangeRequest {
  none,
  byCreator,
  byOpponent,
}

class VsGame {
  final String id;
  final String creatorName;
  final String? opponentName;


  /// Qui a choisi le défi ce tour-ci
  final bool creatorChoseChallenge;

  /// Le défi choisi
  final String challengeQuestion;

  /// Réponses au défi
  final String? creatorAnswer;
  final String? opponentAnswer;

  /// Scores quiz
  final int creatorScore;
  final int opponentScore;

  /// Statut de la partie
  final VsGameStatus status;

  /// Est-ce que quelqu'un a demandé revanche
  final RevangeRequest revangeRequest;

  /// Qui a vu le recap
  final bool creatorSawRecap;
  final bool opponentSawRecap;

  const VsGame({
    required this.id,
    required this.creatorName,
    required this.opponentName,
    this.creatorChoseChallenge = true,
    this.challengeQuestion = '',
    this.creatorAnswer,
    this.opponentAnswer,
    this.creatorScore = 0,
    this.opponentScore = 0,
    this.status = VsGameStatus.creatorPlaying,
    this.revangeRequest = RevangeRequest.none,
    this.creatorSawRecap = false,
    this.opponentSawRecap = false,
  });

  /// Crée une copie avec des champs modifiés
  VsGame copyWith({
    String? id,
    String? creatorName,
    String? opponentName,
    bool? creatorChoseChallenge,
    String? challengeQuestion,
    String? creatorAnswer,
    String? opponentAnswer,
    int? creatorScore,
    int? opponentScore,
    VsGameStatus? status,
    RevangeRequest? revangeRequest,
    bool? creatorSawRecap,
    bool? opponentSawRecap,
  }) {
    return VsGame(
      id: id ?? this.id,
      creatorName: creatorName ?? this.creatorName,
      opponentName: opponentName ?? this.opponentName,
      creatorChoseChallenge:
          creatorChoseChallenge ?? this.creatorChoseChallenge,
      challengeQuestion: challengeQuestion ?? this.challengeQuestion,
      creatorAnswer: creatorAnswer ?? this.creatorAnswer,
      opponentAnswer: opponentAnswer ?? this.opponentAnswer,
      creatorScore: creatorScore ?? this.creatorScore,
      opponentScore: opponentScore ?? this.opponentScore,
      status: status ?? this.status,
      revangeRequest: revangeRequest ?? this.revangeRequest,
      creatorSawRecap: creatorSawRecap ?? this.creatorSawRecap,
      opponentSawRecap: opponentSawRecap ?? this.opponentSawRecap,
    );
  }

  /// Crée une revanche : les rôles s'inversent
  VsGame createRevange() {
    return VsGame(
      id: 'revange_${DateTime.now().millisecondsSinceEpoch}',
      // L'ancien opponent devient le creator (c'est lui qui choisit)
      creatorName: opponentName ?? 'Inconnu',

      opponentName: creatorName,
      // Celui qui n'a pas choisi avant choisit maintenant
      creatorChoseChallenge: true,
      status: VsGameStatus.creatorPlaying,
    );
  }
}
