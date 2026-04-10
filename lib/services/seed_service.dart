import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Vérifie si la base est déjà peuplée
  Future<bool> isSeeded() async {
    final snap = await _db.collection('quizCards').limit(1).get();
    return snap.docs.isNotEmpty;
  }

  /// Peuple la base avec les données de démo
  Future<void> seed() async {
    if (await isSeeded()) return;

    final batch = _db.batch();

    // Quiz cards
    for (final card in _quizCards) {
      final doc = _db.collection('quizCards').doc();
      batch.set(doc, card);
    }

    // Challenge prompts
    for (final prompt in _challengePrompts) {
      final doc = _db.collection('challengePrompts').doc();
      batch.set(doc, prompt);
    }

    await batch.commit();
  }

  static final List<Map<String, dynamic>> _quizCards = [
    {
      'kind': 'trueFalse',
      'category': 'Mythe',
      'question':
          'Pour des raisons biologiques, le d\u00e9sir sexuel est plus fort chez l\'homme que chez la femme.',
      'options': ['Faux', 'Vrai'],
      'correctIndex': 0,
      'answerLabel': 'Faux',
      'revealTitle': 'Mythe tr\u00e8s r\u00e9pandu',
      'revealText':
          'Aucune base biologique ne prouve que les hommes auraient plus "besoin" de sexe. Ce mythe vient surtout de normes culturelles et d\'une valorisation sociale du d\u00e9sir masculin.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Anatomie',
      'question':
          'Combien de terminaisons nerveuses le clitoris a-t-il ?',
      'options': ['2 000', '5 000', '10 281', '20 000'],
      'correctIndex': 2,
      'answerLabel': '10 281',
      'revealTitle': 'R\u00e9ponse \u00e0 retenir',
      'revealText':
          'Le clitoris poss\u00e8de \u00e9norm\u00e9ment de terminaisons nerveuses, ce qui en fait une zone majeure de sensibilit\u00e9. C\'est aussi un bon exemple de sujet longtemps invisibilis\u00e9 dans l\'\u00e9ducation.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'estimation',
      'category': 'Histoire',
      'question':
          'En quelle ann\u00e9e l\'American Psychiatric Association a-t-elle retir\u00e9 l\'homosexualit\u00e9 de sa liste des troubles mentaux ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': '1973',
      'revealTitle': 'Date cl\u00e9',
      'revealText':
          'Cette d\u00e9cision est r\u00e9cente \u00e0 l\'\u00e9chelle de l\'histoire contemporaine. Elle rappelle que beaucoup de normes pr\u00e9sent\u00e9es comme "scientifiques" sont en r\u00e9alit\u00e9 construites culturellement.',
      'min': 1900,
      'max': 2025,
      'correctValue': 1973,
    },
  ];

  static final List<Map<String, dynamic>> _challengePrompts = [
    {
      'text':
          'Quelle "id\u00e9e re\u00e7ue" sur le plaisir t\'a toujours donn\u00e9 envie de hurler "FAUX !" ?',
      'order': 1,
    },
    {
      'text':
          'Raconte ton pire date ou le plan foireux le plus mythique de ta vie.',
      'order': 2,
    },
    {
      'text':
          'Quelle petite r\u00e9v\u00e9lation t\'a r\u00e9cemment aid\u00e9\u00b7e \u00e0 kiffer davantage ta sexualit\u00e9 ?',
      'order': 3,
    },
  ];
}
