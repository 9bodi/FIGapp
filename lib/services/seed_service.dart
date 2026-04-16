import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> isSeeded() async {
    final snap = await _db.collection('quizCards').limit(1).get();
    if (snap.docs.isEmpty) return false;
    // Vérifier si c'est l'ancienne version (3 cartes) ou la nouvelle (48+)
    final count = await _db.collection('quizCards').count().get();
    return count.count! >= 40;
  }

  Future<void> seed() async {
    if (await isSeeded()) return;
    await _clearCollections();
    await _seedQuizCards();
    await _seedChallengePrompts();
  }

  Future<void> _clearCollections() async {
    final quizSnap = await _db.collection('quizCards').get();
    final promptSnap = await _db.collection('challengePrompts').get();
    final batch = _db.batch();
    for (final doc in quizSnap.docs) {
      batch.delete(doc.reference);
    }
    for (final doc in promptSnap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> _seedQuizCards() async {
    final batch = _db.batch();
    for (final card in _quizCards) {
      final doc = _db.collection('quizCards').doc();
      batch.set(doc, card);
    }
    await batch.commit();
  }

  Future<void> _seedChallengePrompts() async {
    final batch = _db.batch();
    for (final prompt in _challengePrompts) {
      final doc = _db.collection('challengePrompts').doc();
      batch.set(doc, prompt);
    }
    await batch.commit();
  }

  // ═══════════════════════════════════════════════════════════════
  //  QUIZ CARDS — Savoir Érotique (48 cartes)
  // ═══════════════════════════════════════════════════════════════

  static final List<Map<String, dynamic>> _quizCards = [
    // ── VRAI / FAUX ──────────────────────────────────────────────

    {
      'kind': 'trueFalse',
      'category': 'Mythe',
      'question':
          'Plus de 70 % des recherches médicales et tests cliniques sont aujourd\'hui réalisés sur des corps féminins.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Le corps masculin comme norme',
      'revealText':
          'La science a longtemps étudié le corps masculin comme la norme universelle. Les corps féminins sont encore souvent exclus des essais cliniques. Des médicaments mal dosés, des effets secondaires sous-estimés… Comme le rappelle la biologiste Cat Bohannon, on soigne encore les femmes avec des données issues de corps d\'hommes.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Anatomie',
      'question':
          'Les érections du pénis et du clitoris fonctionnent de la même façon.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 0,
      'answerLabel': 'Vrai',
      'revealTitle': 'Même mécanique',
      'revealText':
          'Ils ont des structures biologiques similaires et contiennent tous les deux des tissus érectiles qui se gorgent de sang pendant l\'excitation sexuelle. Le clitoris peut devenir de 50 à 300 % plus gros lorsqu\'il est engorgé.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Anatomie',
      'question':
          'La graisse des hanches et des cuisses chez les femmes est primordiale pour le développement d\'un fœtus.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 0,
      'answerLabel': 'Vrai',
      'revealTitle': 'Réserve vitale',
      'revealText':
          'Cette graisse, dite glutéo-fémorale, sert de réserve ultra-spécialisée pour nourrir le cerveau et la rétine du bébé pendant le 3e trimestre et l\'allaitement. Après liposuccion, elle repousse ailleurs, signe qu\'elle est vitale et finement régulée par l\'évolution.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Biologie',
      'question':
          'Un homme produit assez de spermatozoïdes en 2 semaines pour féconder toutes les femmes fertiles sur la planète.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 0,
      'answerLabel': 'Vrai',
      'revealTitle': 'L\'ovule choisit',
      'revealText':
          'Chaque éjaculation contient 200 à 500 millions de spermatozoïdes. Mais contrairement au mythe du spermatozoïde héroïque, c\'est l\'ovule qui choisit : il émet des signaux chimiques et laisse entrer le spermatozoïde le plus compatible. Le patriarcat a transformé un processus de coopération en une fable de compétition masculine.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Santé',
      'question':
          'Les IST (infections sexuellement transmissibles) ne peuvent être transmises par voie orale.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Protection orale aussi',
      'revealText':
          'Les préservatifs peuvent réduire considérablement le risque d\'IST pendant les rapports sexuels oraux. Ils ne sont pas réservés aux rapports pénétrants.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Anatomie',
      'question':
          'La taille du clitoris change pendant l\'excitation sexuelle.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 0,
      'answerLabel': 'Vrai',
      'revealTitle': 'Clitoris érectile',
      'revealText':
          'Le clitoris peut devenir 2,5 fois plus grand lorsqu\'il est stimulé.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Biologie',
      'question': 'L\'érection vient avec la puberté.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Dès le fœtus',
      'revealText':
          'Même les fœtus mâles de 16 semaines peuvent avoir des érections dans l\'utérus ! Par ailleurs, la profondeur moyenne du vagin est de 7 à 11 cm. Autrement dit, la majorité des pénis sont déjà plus que suffisants. Preuve que le plaisir ne se mesure pas en centimètres.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Mythe',
      'question':
          'Pour des raisons biologiques, le désir sexuel est plus fort chez l\'homme que chez la femme.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Mythe du désir masculin',
      'revealText':
          'Aucune base biologique ne prouve que les hommes "ont plus besoin de sexe". Ce mythe vient d\'une lecture patriarcale, pas scientifique. La société valorise la libido masculine et culpabilise le désir féminin. Comme l\'explique Mona Chollet, le désir n\'a pas de genre, juste des siècles de conditionnement.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Mythe',
      'question':
          'Le premier rapport sexuel est toujours douloureux pour une femme.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Mythe patriarcal',
      'revealText':
          'Comme l\'explique Julia Pietri, cette croyance vient d\'un mythe patriarcal qui associe douleur et "pureté". En réalité, le corps féminin n\'est pas censé souffrir : la douleur vient souvent du stress, du manque de lubrification, ou d\'un manque de délicatesse du partenaire.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Mythe',
      'question':
          'Il existe deux types d\'orgasmes féminins, le vaginal et le clitoridien.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Un seul organe, un seul orgasme',
      'revealText':
          'Tous les orgasmes féminins viennent du clitoris, qu\'il soit stimulé directement ou indirectement par la pénétration. Cette idée de "double orgasme" a été forgée par des médecins hommes pour rendre le plaisir féminin dépendant de la pénétration.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Histoire',
      'question':
          'Les statues grecques ont des petits pénis car c\'était physiquement la taille moyenne à l\'époque.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Symbole de maîtrise',
      'revealText':
          'Les gros pénis étaient mal vus car ils symbolisaient une sexualité excessive, menaçante pour l\'esprit. Un petit sexe était le signe d\'un homme maître de lui-même, donc plus spirituel et rationnel.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Santé',
      'question':
          'Avoir des rapports sexuels pendant les règles est dangereux à cause du flux sanguin.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Aucun danger',
      'revealText':
          'Avoir des relations sexuelles pendant les règles peut même soulager les crampes menstruelles.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Histoire',
      'question':
          'Les périodes de progrès pour les femmes dans l\'histoire ont été suivies de phases de recul systématique.',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 0,
      'answerLabel': 'Vrai',
      'revealTitle': 'Backlash permanent',
      'revealText':
          'Selon l\'ONU (2024), près de 50 % des pays ont connu un recul sur les droits des femmes au cours des dix dernières années. Après #MeToo, les mouvements masculinistes ont explosé. En Afghanistan, les talibans ont réinstauré l\'interdiction d\'école pour les filles ; aux États-Unis, le droit à l\'avortement a été restreint dans plus de 20 États depuis 2022.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'trueFalse',
      'category': 'Science',
      'question':
          'Les scientifiques ont longtemps prouvé que les hommes sont plus "logiques" et les femmes plus "émotionnelles".',
      'options': ['Vrai', 'Faux'],
      'correctIndex': 1,
      'answerLabel': 'Faux',
      'revealTitle': 'Biais culturel, pas biologique',
      'revealText':
          'Aucune étude sérieuse ne montre une différence structurelle du cerveau justifiant cette idée. Cat Bohannon souligne que les premières recherches ont été menées sur des soldats et des hommes blancs. Les différences observées venaient surtout… des échantillons.',
      'min': null,
      'max': null,
      'correctValue': null,
    },

    // ── QCM ──────────────────────────────────────────────────────

    {
      'kind': 'multipleChoice',
      'category': 'Anatomie',
      'question': 'Combien de terminaisons nerveuses le clitoris a-t-il ?',
      'options': ['2 000', '5 000', '10 281', '20 000'],
      'correctIndex': 2,
      'answerLabel': '10 281',
      'revealTitle': 'Le double du pénis',
      'revealText':
          'Le clitoris a deux fois plus de terminaisons nerveuses que le pénis, ce qui en fait la partie la plus sensible du corps humain.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Histoire',
      'question':
          'À quelle époque les femmes ont-elles perdu le plus de droits en France ?',
      'options': ['Le Moyen Âge', 'La Renaissance', 'La Révolution', 'Le XIXe siècle'],
      'correctIndex': 1,
      'answerLabel': 'La Renaissance',
      'revealTitle': 'Période sombre',
      'revealText':
          'On nous vend la Renaissance comme un feu d\'artifice d\'art et de génie. Pourtant, pour les droits des femmes, c\'est une période sombre : perte de droits avec la loi salique, exclusion de nombreux corps de métiers et masculinisation de la langue française.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Anatomie',
      'question': 'Quelle est la taille totale du clitoris ?',
      'options': ['2 à 4 cm', '5 à 8 cm', '9 à 12 cm', '15 à 18 cm'],
      'correctIndex': 2,
      'answerLabel': '9 à 12 cm',
      'revealTitle': 'L\'iceberg du plaisir',
      'revealText':
          'Seul un cinquième du clitoris est visible. Le reste est caché sous la peau et entoure le vagin. La pointe visible est composée du gland (4-7 mm) et de sa capuche.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Biologie',
      'question': 'Quel est le rôle de l\'oxytocine ?',
      'options': [
        'Hormone du stress',
        'Hormone de la croissance',
        'Hormone du plaisir et de l\'attachement',
        'Hormone de la faim'
      ],
      'correctIndex': 2,
      'answerLabel': 'Hormone du plaisir et de l\'attachement',
      'revealTitle': 'Câlinons-nous !',
      'revealText':
          'L\'oxytocine est libérée par l\'hypothalamus lors des contacts physiques, comme les câlins, ou pendant l\'orgasme. Elle renforce la confiance, l\'attachement et les liens affectifs. Des études montrent qu\'un taux élevé d\'oxytocine améliore la lecture des émotions.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question':
          'Comment l\'échelle de Kinsey décrit-elle l\'orientation sexuelle ?',
      'options': [
        'Homme ou femme',
        'Un spectre de 0 à 6',
        'Trois catégories fixes',
        'Un test de personnalité'
      ],
      'correctIndex': 1,
      'answerLabel': 'Un spectre de 0 à 6',
      'revealTitle': 'Pas de cases',
      'revealText':
          'Alfred Kinsey était un biologiste et sexologue révolutionnaire qui a contesté la vision binaire de l\'orientation sexuelle. Son échelle va de 0 (exclusivement hétérosexuel) à 6 (exclusivement homosexuel). Il l\'a développée à la fin des années 1940.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question':
          'D\'où vient le premier manuel sexuel et comment s\'appelle-t-il ?',
      'options': [
        'Le Kama Sutra, Inde',
        'L\'Ars Amatoria, Rome',
        'Le Tao du sexe, Chine',
        'Le Manuel d\'Éros, Grèce'
      ],
      'correctIndex': 0,
      'answerLabel': 'Le Kama Sutra, écrit en Inde',
      'revealTitle': 'Plus que des positions',
      'revealText':
          'Le Kama Sutra ne se résume pas à des positions sexuelles : il comprend des conseils sur l\'amour, le mariage et l\'épanouissement. Il existe depuis plus de 2 000 ans.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Langue',
      'question':
          'Pourquoi, dans la langue française, le masculin "l\'emporte" sur le féminin ?',
      'options': [
        'C\'est une règle logique ancestrale',
        'Le latin imposait cette règle',
        'Un grammairien l\'a décrété en 1647',
        'L\'Académie française l\'a voté en 1900'
      ],
      'correctIndex': 2,
      'answerLabel': 'Décision de Vaugelas en 1647',
      'revealTitle': 'Décision politique, pas linguistique',
      'revealText':
          'Claude Favre de Vaugelas a décrété que "le genre masculin est le plus noble". Avant lui, on appliquait la règle du plus proche ("le masculin et la féminine sont belles"). La prochaine fois qu\'un réac dénigre l\'écriture inclusive, rappelez-lui que ses potes du XVIe ont déjà touché à "notre belle langue".',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question': 'Qu\'est-ce que la pansexualité ?',
      'options': [
        'Attirance uniquement physique',
        'Attirance pour une personne, quel que soit son genre',
        'Attirance pour les personnes du même genre',
        'Absence d\'attirance sexuelle'
      ],
      'correctIndex': 1,
      'answerLabel': 'Attirance quel que soit le genre',
      'revealTitle': 'Au-delà des étiquettes',
      'revealText':
          'Être pansexuel·le, c\'est comme avoir un cœur qui ne lit pas les étiquettes. Freud aurait sûrement appelé ça le "complexe de l\'ouverture d\'esprit", mais venant d\'un mec convaincu que tout tourne autour du pénis, on va pas lui laisser la parole sur le sujet.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question': 'Que signifie l\'acronyme "BDSM" ?',
      'options': [
        'Bondage, Discipline, Domination, Soumission, Sadisme, Masochisme',
        'Beauté, Désir, Sensualité, Magie',
        'Besoin, Douceur, Soin, Massage',
        'Bienveillance, Dialogue, Sexualité, Maturité'
      ],
      'correctIndex': 0,
      'answerLabel': 'Bondage, Discipline, Domination, Soumission, Sadisme, Masochisme',
      'revealTitle': 'Consensuel avant tout',
      'revealText':
          'Malgré sa réputation sulfureuse, le BDSM met l\'accent sur l\'exploration consensuelle et la communication. Ses origines modernes remontent à la fin du XXe siècle.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question':
          'Quel est le terme désignant une attirance sexuelle pour l\'intelligence ?',
      'options': [
        'Demisexualité',
        'Sapiosexualité',
        'Pansexualité',
        'Cérébralité'
      ],
      'correctIndex': 1,
      'answerLabel': 'Sapiosexualité',
      'revealTitle': 'Le cerveau comme zone érogène',
      'revealText':
          'Ce terme a été ajouté au dictionnaire d\'Oxford en 2014, ce qui témoigne de son émergence et de son adoption croissante dans la culture contemporaine.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question':
          'Quel est le terme pour désigner l\'absence d\'attirance sexuelle envers autrui ?',
      'options': [
        'Aromantisme',
        'Asexualité',
        'Abstinence',
        'Anérotisme'
      ],
      'correctIndex': 1,
      'answerLabel': 'Asexualité',
      'revealTitle': 'L\'anneau noir',
      'revealText':
          'L\'asexualité est souvent représentée par un anneau noir porté sur le majeur de la main droite, symbolisant le manque d\'attirance sexuelle de l\'individu.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Histoire',
      'question':
          'Qui était Simone Veil et pourquoi est-elle célèbre ?',
      'options': [
        'Écrivaine, prix Nobel de littérature',
        'Survivante de la Shoah, loi légalisant l\'avortement en 1975',
        'Première femme présidente de la République',
        'Fondatrice du planning familial'
      ],
      'correctIndex': 1,
      'answerLabel': 'Survivante de la Shoah, loi sur l\'avortement (1975)',
      'revealTitle': 'Huée à l\'Assemblée',
      'revealText':
          'En 1974, Simone Veil s\'est fait huer à l\'Assemblée par des hommes persuadés d\'avoir leur mot à dire sur le corps des femmes. Cinquante ans plus tard, la question reste la même : pourquoi certains pensent-ils encore que notre utérus leur appartient ?',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question': 'Qu\'est-ce que le tantra ou sexe tantrique ?',
      'options': [
        'Une position sexuelle indienne',
        'Une pratique spirituelle unissant énergie, souffle et conscience',
        'Un type de massage érotique',
        'Une forme de méditation solitaire'
      ],
      'correctIndex': 1,
      'answerLabel': 'Pratique spirituelle de plus de 1 500 ans',
      'revealTitle': 'Jouir sans éjaculer',
      'revealText':
          'Le tantra est une série d\'exercices pour être plus présent : synchroniser sa respiration avec son·sa partenaire, maintenir le contact visuel, apprendre à jouir sans éjaculation. Le tout pour prolonger le plaisir et renforcer la connexion.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Biologie',
      'question':
          'Pourquoi l\'accouchement humain est-il si difficile par rapport aux autres mammifères ?',
      'options': [
        'À cause de la taille du bassin',
        'À cause de la taille du cerveau du bébé',
        'À cause de la station debout uniquement',
        'À cause d\'une anomalie génétique'
      ],
      'correctIndex': 1,
      'answerLabel': 'À cause du cerveau',
      'revealTitle': 'Le dilemme obstétrical',
      'revealText':
          'L\'évolution a fait grossir la tête du bébé plus vite que le bassin de la mère. Cat Bohannon appelle ça "le dilemme obstétrical" : marcher debout et donner naissance à un grand cerveau, c\'est un compromis douloureux… mais fascinant.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Culture',
      'question':
          'Quels sont les profils les plus "likés" sur les applis de rencontre hétéro ?',
      'options': [
        'Femmes blondes et hommes musclés',
        'Femmes asiatiques et hommes blancs',
        'Femmes latinas et hommes noirs',
        'Aucun biais significatif'
      ],
      'correctIndex': 1,
      'answerLabel': 'Femmes asiatiques et hommes blancs',
      'revealTitle': 'Désir conditionné',
      'revealText':
          'Les "likes" reflètent surtout des stéréotypes racialisés : l\'imaginaire orientaliste valorise les femmes asiatiques comme "douces" et "dociles". Ce n\'est pas du désir "naturel", c\'est du conditionnement culturel.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Histoire',
      'question':
          'Qui a peint L\'Origine du monde, montrant un sexe féminin de face, en 1866 ?',
      'options': [
        'Édouard Manet',
        'Gustave Courbet',
        'Auguste Renoir',
        'Eugène Delacroix'
      ],
      'correctIndex': 1,
      'answerLabel': 'Gustave Courbet',
      'revealTitle': 'Modèle effacée',
      'revealText':
          'Le modèle s\'appelait Constance Quéniaux, ancienne danseuse de l\'Opéra. Son nom n\'a été officiellement révélé qu\'en 2018. L\'Histoire a souvent réduit les femmes au rôle de corps exposés, tout en effaçant leurs noms.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Biologie',
      'question':
          'Pourquoi les femmes vivent-elles plus longtemps que les hommes en moyenne ?',
      'options': [
        'Elles font plus de sport',
        'Leur organisme est mieux équipé pour la survie à long terme',
        'Elles mangent mieux',
        'C\'est un pur hasard statistique'
      ],
      'correctIndex': 1,
      'answerLabel': 'Organisme mieux équipé pour la survie',
      'revealTitle': 'Avantage évolutif',
      'revealText':
          'Les femmes possèdent davantage de mécanismes de réparation cellulaire, en partie grâce à l\'évolution liée à la grossesse et à la maternité.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Biologie',
      'question':
          'Pourquoi les humains n\'ont-ils plus d\'os dans le pénis (comme la plupart des mammifères) ?',
      'options': [
        'À cause d\'une mutation génétique',
        'Parce que le sexe humain repose plus sur la connexion que sur la durée',
        'Parce que l\'os s\'est atrophié avec le temps',
        'Pour des raisons de mobilité'
      ],
      'correctIndex': 1,
      'answerLabel': 'La connexion plutôt que la durée',
      'revealTitle': 'Évolution sentimentale',
      'revealText':
          'La plupart des mammifères ont un "baculum" (os du pénis) pour maintenir l\'érection. Chez l\'humain, la confiance, la proximité et l\'excitation psychologique ont remplacé le besoin d\'un os.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Biologie',
      'question':
          'Pourquoi des femmes vivent-elles environ un tiers de leur vie après la dernière ovulation ?',
      'options': [
        'C\'est un accident de l\'évolution',
        'Pour augmenter la survie des enfants via soins et transmission',
        'À cause des hormones de remplacement',
        'Pour des raisons purement génétiques'
      ],
      'correctIndex': 1,
      'answerLabel': 'L\'hypothèse de la grand-mère',
      'revealTitle': 'Atout évolutif',
      'revealText':
          'Arrêter de faire des bébés vers 45-50 ans libère du temps et de l\'énergie pour aider la descendance (garde, nourriture, savoirs), ce qui augmente les chances de survie des jeunes et favorise la culture partagée.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Histoire',
      'question':
          'Quel article de loi française a excusé jusqu\'en 1975 le meurtre d\'une épouse surprise en adultère ?',
      'options': [
        'Article 212 du Code civil',
        'Article 324 du Code pénal',
        'Article 16 de la Constitution',
        'Article 113 du Code pénal'
      ],
      'correctIndex': 1,
      'answerLabel': 'Article 324 du Code pénal',
      'revealTitle': 'Domination légale',
      'revealText':
          'Ce vieux levier juridique illustre comment la loi a longtemps protégé la domination masculine dans la sphère privée. Il n\'a été abrogé qu\'en 1975.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Histoire',
      'question': 'Qu\'est-ce que la loi salique ?',
      'options': [
        'Une loi sur le mariage',
        'Un code détourné pour interdire aux femmes l\'accès au trône',
        'Une loi sur l\'héritage des terres agricoles',
        'Une loi religieuse sur la dot'
      ],
      'correctIndex': 1,
      'answerLabel': 'Interdiction du trône aux femmes',
      'revealTitle': 'Le pouvoir au masculin',
      'revealText':
          'À l\'origine, c\'est un code juridique du VIe siècle sur l\'héritage des terres. Mais au XIVe siècle, des juristes l\'ont détourné pour interdire aux femmes d\'accéder au trône. Ce détournement a gravé dans la culture française l\'idée que le pouvoir devait être masculin.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Histoire',
      'question': 'Qu\'est-ce que la mentrification ?',
      'options': [
        'La gentrification des quartiers par les hommes',
        'L\'attribution à des hommes d\'œuvres faites par des femmes',
        'La masculinisation du langage',
        'Un phénomène économique'
      ],
      'correctIndex': 1,
      'answerLabel': 'Attribuer à des hommes des œuvres de femmes',
      'revealTitle': 'Effacement systématique',
      'revealText':
          'Victor Hugo doit une partie de ses écrits à Juliette Drouet. Camus n\'a jamais cité Francine Faure, qui l\'a aidé à structurer Le Mythe de Sisyphe. Camille Claudel a longtemps été "l\'élève" de Rodin, alors qu\'elle lui a appris à sculpter les émotions.',
      'min': null,
      'max': null,
      'correctValue': null,
    },
    {
      'kind': 'multipleChoice',
      'category': 'Santé',
      'question': 'Qu\'est-ce que le priapisme ?',
      'options': [
        'Une forme d\'impuissance',
        'Une érection prolongée et douloureuse de plus de 4 heures',
        'Un trouble de la libido',
        'Une infection urinaire'
      ],
      'correctIndex': 1,
      'answerLabel': 'Érection douloureuse de plus de 4 heures',
      'revealTitle': 'Urgence médicale',
      'revealText':
          'Le sang reste bloqué dans les tissus érectiles. Le phénomène existe aussi chez les femmes (clitorisme). Ces érections prolongées peuvent être un effet secondaire de certains antidépresseurs ou du Viagra.',
      'min': null,
      'max': null,
      'correctValue': null,
    },

    // ── ESTIMATION ───────────────────────────────────────────────

    {
      'kind': 'estimation',
      'category': 'Biologie',
      'question':
          'Quelle est la vitesse d\'éjaculation chez les hommes (en km/h) ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': '45 km/h',
      'revealTitle': 'Projectile intime',
      'revealText':
          'L\'éjaculation masculine est si rapide que si un homme éjacule debout, le sperme pourrait potentiellement voyager jusqu\'à environ 2,3 mètres. De quoi flatter leur égo.',
      'min': 5,
      'max': 100,
      'correctValue': 45,
    },
    {
  'kind': 'multipleChoice',
  'category': 'Histoire',
  'question': 'À quand remonte le plus ancien sextoy découvert ?',
  'options': ['5 000 ans', '12 000 ans', '28 000 ans', '50 000 ans'],
  'correctIndex': 2,
  'answerLabel': '28 000 ans',
  'revealTitle': 'Plaisir préhistorique',
  'revealText':
      'Un phallus en pierre de 20 cm, vieux de 28 000 ans, a été découvert dans la grotte de Hohle Fels, en Allemagne. D\'après les archéologues, il servait à la fois d\'outil et de sextoy préhistorique.',
  'min': null,
  'max': null,
  'correctValue': null,
},

    {
      'kind': 'estimation',
      'category': 'Santé',
      'question':
          'Quel pourcentage d\'hommes est concerné par l\'éjaculation précoce ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': 'Environ 30 %',
      'revealTitle': 'Pas que humain',
      'revealText':
          'Environ 30 % des hommes seraient concernés. L\'éjaculation précoce n\'est pas seulement un phénomène humain, elle a également été observée chez diverses espèces d\'animaux !',
      'min': 5,
      'max': 80,
      'correctValue': 30,
    },
    {
      'kind': 'estimation',
      'category': 'Société',
      'question':
          'Sur 100 femmes, combien atteignent l\'orgasme dans un rapport hétérosexuel ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': 'Environ 65',
      'revealTitle': 'Le fossé de l\'orgasme',
      'revealText':
          'C\'est ce qu\'on appelle le "fossé de l\'orgasme" et il n\'a rien de naturel. Il résulte d\'une éducation centrée sur le plaisir masculin. La clé ? Moins de performance, plus de communication, et surtout : ne jamais oublier le clitoris.',
      'min': 10,
      'max': 100,
      'correctValue': 65,
    },
    {
      'kind': 'estimation',
      'category': 'Société',
      'question':
          'Quel pourcentage de femmes homosexuelles atteignent habituellement l\'orgasme pendant un rapport ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': '86 %',
      'revealTitle': 'Question de pédagogie',
      'revealText':
          '86 % contre seulement 65 % chez les femmes hétéros. Pas une question de biologie, mais de pédagogie : quand on s\'écoute, qu\'on communique, et qu\'on ne zappe pas le clitoris, la satisfaction grimpe en flèche.',
      'min': 30,
      'max': 100,
      'correctValue': 86,
    },
    {
      'kind': 'estimation',
      'category': 'Histoire',
      'question':
          'En quelle année l\'American Psychiatric Association a-t-elle retiré l\'homosexualité de sa liste des troubles mentaux ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': '1973',
      'revealTitle': 'Victoire récente et fragile',
      'revealText':
          'Aujourd\'hui, dans plus de 60 pays, l\'homosexualité reste illégale, et dans certains, passible de prison ou de mort. En Russie, la Cour suprême a classé le "mouvement LGBT" comme organisation extrémiste.',
      'min': 1940,
      'max': 2000,
      'correctValue': 1973,
    },
    {
      'kind': 'estimation',
      'category': 'Société',
      'question':
          'Quel pourcentage d\'hommes de plus de 30 ans ont plusieurs orgasmes au cours d\'un même rapport ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': 'Moins de 7 %',
      'revealTitle': 'Exercices de Kegel',
      'revealText':
          'Les hommes peuvent pratiquer des exercices de Kegel pour augmenter leur capacité à avoir plusieurs orgasmes. Cette faculté n\'est pas réservée aux femmes !',
      'min': 1,
      'max': 50,
      'correctValue': 7,
    },
    {
  'kind': 'multipleChoice',
  'category': 'Société',
  'question': 'Combien d\'enfants sont victimes de violences sexuelles chaque année en France ?',
  'options': ['Environ 20 000', 'Environ 60 000', 'Environ 160 000', 'Environ 300 000'],
  'correctIndex': 2,
  'answerLabel': 'Environ 160 000',
  'revealTitle': 'Silence complice',
  'revealText':
      'À l\'échelle européenne, 1 enfant sur 5 subit une forme de violence sexuelle au cours de l\'enfance. Les cours d\'éducation à la sexualité et au consentement aident les enfants victimes à sortir du silence.',
  'min': null,
  'max': null,
  'correctValue': null,
},

    {
      'kind': 'estimation',
      'category': 'Histoire',
      'question':
          'En quelle année a-t-on réalisé la première dissection du clitoris ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': '1998',
      'revealTitle': 'Même année que le Viagra',
      'revealText':
          'Réalisée par l\'urologue australienne Helen O\'Connell, cette étude est sortie… la même année que la commercialisation du Viagra. On a trouvé un remède pour l\'érection masculine avant même d\'avoir cartographié l\'organe du plaisir féminin.',
      'min': 1950,
      'max': 2025,
      'correctValue': 1998,
    },
    {
      'kind': 'estimation',
      'category': 'Société',
      'question':
          'Sur 100 rapports, combien de fois les femmes simulent-elles l\'orgasme ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': 'Environ 33 (1 sur 3)',
      'revealTitle': 'Service après-vente du patriarcat',
      'revealText':
          'Près de 60 % des femmes ont déjà simulé un orgasme, et plus d\'un tiers le font régulièrement. Souvent pour ménager l\'ego ou écourter le rapport. La fausse extase, c\'est un vrai service après-vente du patriarcat.',
      'min': 5,
      'max': 80,
      'correctValue': 33,
    },
    {
      'kind': 'estimation',
      'category': 'Histoire',
      'question':
          'En quelle année a eu lieu la première échographie du clitoris ?',
      'options': null,
      'correctIndex': null,
      'answerLabel': '2008',
      'revealTitle': '45 ans de retard',
      'revealText':
          'Réalisée par Dr Odile Buisson et Dr Pierre Foldès. La première échographie du pénis a été effectuée 45 ans plus tôt, en 1963. Sacré retard dans l\'égalité du plaisir !',
      'min': 1970,
      'max': 2025,
      'correctValue': 2008,
    },
  ];

  // ═══════════════════════════════════════════════════════════════
  //  CHALLENGE PROMPTS — Histoire Perso (49 défis)
  // ═══════════════════════════════════════════════════════════════

  static final List<Map<String, dynamic>> _challengePrompts = [
    {'text': 'Si tu avais carte blanche pour poser la question la plus intime du monde, tu demanderais quoi ?', 'order': 1},
    {'text': 'Le truc le plus marquant, touchant ou complètement dingue que tu aies fait par amour ?', 'order': 2},
    {'text': 'Crois-tu à l\'amitié post-sexe, ou finis-tu toujours par "revoir le film" dans ta tête ?', 'order': 3},
    {'text': 'S\'il existait une boule de cristal qui pouvait te révéler une vérité sur toi, ta vie, ton futur, que voudrais-tu savoir ?', 'order': 4},
    {'text': 'Si tu pouvais te réveiller demain en ayant acquis une qualité ou une compétence, laquelle choisirais-tu ? Pourquoi ?', 'order': 5},
    {'text': 'Si tu pouvais vivre jusqu\'à 90 ans avec l\'esprit ou le corps de tes 30 ans, lequel choisirais-tu ?', 'order': 6},
    {'text': 'À quoi ressemblerait pour toi la "journée parfaite" ?', 'order': 7},
    {'text': 'Aimerais-tu être célèbre ? De quelle façon ?', 'order': 8},
    {'text': 'Qu\'est-ce qui a le pouvoir de faire vaciller ta confiance en toi ?', 'order': 9},
    {'text': 'Quel film, livre ou chanson t\'a fait réfléchir sur tes propres désirs ?', 'order': 10},
    {'text': 'Raconte ta première histoire d\'amour, celle qui t\'a appris, blessé·e ou fait planer.', 'order': 11},
    {'text': 'As-tu déjà vécu un moment intime où ton corps disait "non", mais ta bouche n\'a pas osé ?', 'order': 12},
    {'text': '3 déclencheurs d\'excitation qui marchent à tous les coups pour toi ? Allez, balance.', 'order': 13},
    {'text': 'As-tu déjà vécu un moment gênant au lit ? Comment t\'as réagi ? Rire, fuite ou improvisation ?', 'order': 14},
    {'text': 'Balance ton fantasme du moment.', 'order': 15},
    {'text': 'Connais-tu ton love language ? C\'est quoi ta manière d\'aimer et de te sentir aimé·e ?', 'order': 16},
    {'text': 'Qu\'est-ce qui a fait évoluer ta manière de ressentir du plaisir au fil du temps ?', 'order': 17},
    {'text': 'T\'as déjà (sur)vécu à une relation toxique ? Comment as-tu réussi à t\'en sortir ?', 'order': 18},
    {'text': 'À quels tabous ou jugements t\'as dû faire face à cause de ta sexualité ?', 'order': 19},
    {'text': 'As-tu remarqué des schémas qui se répètent dans tes relations ? (Toujours le même type, hein…)', 'order': 20},
    {'text': 'Comment fais-tu durer le feu du désir après plusieurs années ?', 'order': 21},
    {'text': 'Les sextoys : amis fidèles, gadgets rigolos ou intrus électriques ?', 'order': 22},
    {'text': 'Quelle "idée reçue" sur le plaisir t\'a toujours donné envie de hurler "FAUX !" ?', 'order': 23},
    {'text': 'Quelle petite révélation t\'a récemment aidé·e à kiffer davantage ta sexualité ?', 'order': 24},
    {'text': 'C\'est quoi pour toi l\'ingrédient secret d\'une relation qui fonctionne ?', 'order': 25},
    {'text': 'C\'est quoi ton plaisir coupable quand t\'as besoin de réconfort ?', 'order': 26},
    {'text': 'Quelle habitude chelou fais-tu quand personne te regarde ?', 'order': 27},
    {'text': 'Si tu pouvais dîner avec n\'importe qui (mort ou vivant), qui serait à ta table ?', 'order': 28},
    {'text': 'Raconte ton pire date ou le plan foireux le plus mythique de ta vie.', 'order': 29},
    {'text': 'C\'est quoi ton talent inutile, mais que tu revendiques à 200 % ?', 'order': 30},
    {'text': 'Quelle est la dernière fois où t\'as ri jusqu\'à en pleurer ?', 'order': 31},
    {'text': 'T\'as déjà eu un crush improbable, genre honteux mais mémorable ?', 'order': 32},
    {'text': 'Quelle connerie t\'as faite et que tu referais sans hésiter ?', 'order': 33},
    {'text': 'Si ton corps pouvait parler, qu\'est-ce qu\'il aurait à te reprocher ?', 'order': 34},
    {'text': 'Quelle croyance de ton enfance t\'as dû désapprendre pour vivre mieux ?', 'order': 35},
    {'text': 'C\'est quoi le compliment qui t\'a retourné·e comme une crêpe ?', 'order': 36},
    {'text': 'De quoi t\'es la/le plus fier·e, même si personne n\'a jamais applaudi ?', 'order': 37},
    {'text': 'As-tu déjà eu l\'impression d\'être "trop" ou "pas assez" ? Dans quelle situation ?', 'order': 38},
    {'text': 'Quelle est la dernière fois où t\'as dit "non" alors que t\'aurais dit "oui" avant ?', 'order': 39},
    {'text': 'Raconte une fois où t\'as merdé, mais où t\'as appris un truc énorme.', 'order': 40},
    {'text': 'Si tu pouvais demander pardon à quelqu\'un (ou à toi-même), ce serait pour quoi ?', 'order': 41},
    {'text': 'As-tu déjà eu une révélation qui a tout changé dans ta façon d\'aimer ?', 'order': 42},
    {'text': 'C\'est quoi le "putain j\'aurais dû…" que tu traînes encore dans un coin de ta tête ?', 'order': 43},
    {'text': 'Dis à tes partenaires de jeu une chose bien précise que t\'aimes chez iel·s.', 'order': 44},
    {'text': 'Que ressens-tu vis-à-vis de ta relation avec ta mère ?', 'order': 45},
    {'text': 'Qu\'est-ce qui te rend le plus reconnaissant·e dans la vie ?', 'order': 46},
    {'text': 'C\'était quand, la dernière fois où tu t\'es senti·e vraiment à ta place ?', 'order': 47},
    {'text': 'Selon toi, quelle est la plus grosse intox du patriarcat ?', 'order': 48},
    {'text': 'Si tu pouvais te débarrasser de l\'un de tes travers, tu choisirais lequel ?', 'order': 49},
  ];
}
