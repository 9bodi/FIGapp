import 'package:flutter/material.dart';
import '../quiz/quiz_screen.dart';

class ChallengeSelectScreen extends StatefulWidget {
  const ChallengeSelectScreen({super.key});

  @override
  State<ChallengeSelectScreen> createState() => _ChallengeSelectScreenState();
}

class _ChallengeSelectScreenState extends State<ChallengeSelectScreen> {
  static const Color figBackground = Color(0xFF231143);
  static const Color figCream = Color(0xFFE9DFC8);

  static const List<String> challengeCards = [
    'Quelle “idée reçue” sur le plaisir t’a toujours donné envie de hurler “FAUX !” ?',
    'Raconte ton pire date ou le plan foireux le plus mythique de ta vie.',
    'Quelle petite révélation t’a récemment aidé·e à kiffer davantage ta sexualité ?',
  ];

  late final PageController _pageController;
  final TextEditingController _textController = TextEditingController();

  int selectedIndex = 0;
  bool showAnswerArea = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _textController.text.trim().isNotEmpty;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  figBackground,
                  Color(0xFF1A0D36),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: figCream,
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/logo_full.png',
                        width: 90,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    showAnswerArea ? 'À toi de répondre' : 'Choisis un défi',
                    style: const TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: figCream,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    showAnswerArea
                        ? 'Ton adversaire répondra au même défi, puis vous enchaînerez sur les mêmes questions.'
                        : 'Fais défiler les cartes et garde celle qui te donne le plus envie de répondre.',
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    height: showAnswerArea ? 170 : 340,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: challengeCards.length,
                      onPageChanged: (index) {
  setState(() {
    selectedIndex = index;
    if (showAnswerArea) {
      showAnswerArea = false;
    }
  });
},
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedIndex;
                        return AnimatedPadding(
  duration: const Duration(milliseconds: 220),
  curve: Curves.easeOutCubic,
  padding: EdgeInsets.symmetric(
    horizontal: 8,
    vertical: showAnswerArea
        ? (isSelected ? 6 : 20)
        : (isSelected ? 6 : 18),
  ),
  child: _ChallengeCarouselCard(
  text: challengeCards[index],
  selected: isSelected,
  compact: showAnswerArea,
  onTap: () {
    if (index == selectedIndex) {
      setState(() {
        showAnswerArea = true;
      });
    } else {
      setState(() {
        selectedIndex = index;
        showAnswerArea = false;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    }
  },
),
);
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  if (!showAnswerArea)
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.62,
                        child: _RespondCtaCard(
                          onTap: () {
                            setState(() {
                              showAnswerArea = true;
                            });
                          },
                        ),
                      ),
                    ),

                  if (showAnswerArea) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: figCream,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Texte',
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.w700,
                              color: figBackground,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.mic_none_rounded,
                                size: 18,
                                color: Colors.white38,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Vocal',
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onChanged: (_) => setState(() {}),
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 17,
                          color: figCream,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Balance ta réponse ici…',
                          hintStyle: const TextStyle(
                            fontFamily: 'Helvetica',
                            color: Colors.white38,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.04),
                          contentPadding: const EdgeInsets.all(18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            borderSide: BorderSide(
                              color: Color(0x66E9DFC8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: canContinue
    ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChallengeQuizPage(
              cards: getChallengeCards(),
              challengeAnswer: _textController.text,
            ),
          ),
        );
      }
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: figCream,
                          foregroundColor: figBackground,
                          disabledBackgroundColor: Colors.white.withOpacity(0.08),
                          disabledForegroundColor: Colors.white38,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'Continuer',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCarouselCard extends StatelessWidget {
  final String text;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _ChallengeCarouselCard({
    required this.text,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withOpacity(0.07)
                : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: selected
                  ? const Color(0x55E9DFC8)
                  : Colors.white.withOpacity(0.06),
              width: selected ? 1.3 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(selected ? 0.28 : 0.16),
                blurRadius: selected ? 28 : 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.compare_arrows_rounded,
                  color: figCream,
                  size: compact ? 20 : 24,
                ),
                SizedBox(height: compact ? 12 : 18),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: compact ? 15 : 20,
                      fontWeight: FontWeight.w700,
                      color: figCream,
                      height: 1.25,
                    ),
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 12),
                  Text(
                    selected ? 'Carte sélectionnée' : 'Fais glisser',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 13,
                      color: selected ? figCream : Colors.white54,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RespondCtaCard extends StatelessWidget {
  final VoidCallback onTap;

  const _RespondCtaCard({required this.onTap});

  static const Color figCream = Color(0xFFE9DFC8);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.edit_note_rounded,
                  color: figCream,
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  'Répondre à cette carte',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
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