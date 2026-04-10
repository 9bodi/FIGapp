import '../models/quiz_card.dart';
import '../models/vs_game.dart';

const List<QuizCardData> demoCards = [
  QuizCardData(
    kind: CardKind.trueFalse,
    category: 'Mythe',
    question:
        'Pour des raisons biologiques, le désir sexuel est plus fort chez l\'homme que chez la femme.',
    options: ['Faux', 'Vrai'],
    correctIndex: 0,
    answerLabel: 'Faux',
    revealTitle: 'Mythe très répandu',
    revealText:
        'Aucune base biologique ne prouve que les hommes auraient plus "besoin" de sexe. Ce mythe vient surtout de normes culturelles et d\'une valorisation sociale du désir masculin.',
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
        'Le clitoris possède énormément de terminaisons nerveuses, ce qui en fait une zone majeure de sensibilité. C\'est aussi un bon exemple de sujet longtemps invisibilisé dans l\'éducation.',
  ),
  QuizCardData(
    kind: CardKind.estimation,
    category: 'Histoire',
    question:
        'En quelle année l\'American Psychiatric Association a-t-elle retiré l\'homosexualité de sa liste des troubles mentaux ?',
    min: 1900,
    max: 2025,
    correctValue: 1973,
    answerLabel: '1973',
    revealTitle: 'Date clé',
    revealText:
        'Cette décision est récente à l\'échelle de l\'histoire contemporaine. Elle rappelle que beaucoup de normes présentées comme "scientifiques" sont en réalité construites culturellement.',
  ),
];

const List<VsGame> demoGames = [
  VsGame(
    id: 'game_1',
    creatorName: 'Moi',
    opponentName: 'Camille',
    creatorChoseChallenge: true,
    challengeQuestion:
        'Quelle petite révélation t\'a récemment aidé·e à kiffer davantage ta sexualité ?',
    creatorAnswer: null,
    opponentAnswer: null,
    status: VsGameStatus.creatorPlaying,
  ),
  VsGame(
    id: 'game_2',
    creatorName: 'Moi',
    opponentName: 'Sarah',
    creatorChoseChallenge: true,
    challengeQuestion:
        'Raconte ton pire date ou le plan foireux le plus mythique de ta vie.',
    creatorAnswer:
        'J\'ai raconté mon pire date en croyant être drôle, et finalement c\'est surtout devenu un très bon filtre.',
    opponentAnswer: null,
    creatorScore: 5,
    opponentScore: 0,
    status: VsGameStatus.opponentTurn,
  ),
  VsGame(
    id: 'game_3',
    creatorName: 'Moi',
    opponentName: 'Léo',
    creatorChoseChallenge: true,
    challengeQuestion:
        'Quelle "idée reçue" sur le plaisir t\'a toujours donné envie de hurler "FAUX !" ?',
    creatorAnswer:
        'L\'idée qu\'il faudrait savoir instinctivement quoi faire. Comme si parler cassait l\'ambiance.',
    opponentAnswer:
        'Que le plaisir féminin serait "plus compliqué". Souvent, c\'est juste qu\'on l\'écoute moins.',
    creatorScore: 6,
    opponentScore: 4,
    status: VsGameStatus.recapAvailable,
  ),
  VsGame(
    id: 'game_4',
    creatorName: 'Moi',
    opponentName: 'Alex',
    creatorChoseChallenge: true,
    challengeQuestion:
        'Quelle petite révélation t\'a récemment aidé·e à kiffer davantage ta sexualité ?',
    creatorAnswer:
        'Comprendre que je pouvais arrêter de performer et commencer à ressentir.',
    opponentAnswer: null,
    creatorScore: 7,
    opponentScore: 0,
    status: VsGameStatus.opponentTurn,
  ),
];


const List<String> challengeCards = [
  'Quelle "idée reçue" sur le plaisir t\'a toujours donné envie de hurler "FAUX !" ?',
  'Raconte ton pire date ou le plan foireux le plus mythique de ta vie.',
  'Quelle petite révélation t\'a récemment aidé·e à kiffer davantage ta sexualité ?',
];

List<QuizCardData> getChallengeCards() {
  final shuffled = List<QuizCardData>.from(demoCards)..shuffle();
  return shuffled.take(5).toList();
}
