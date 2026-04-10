import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/fig_theme.dart';
import 'challenge_select_screen.dart';

class ChallengeCreateScreen extends StatefulWidget {
  const ChallengeCreateScreen({super.key});

  @override
  State<ChallengeCreateScreen> createState() => _ChallengeCreateScreenState();
}

class _ChallengeCreateScreenState extends State<ChallengeCreateScreen> {
  static const Color figBackground = FigColors.background;
  static const Color figCream = FigColors.cream;

  bool _inviteSent = false;

  static const String _inviteLink = 'https://figapp.link/invite/demo123';

  Future<void> _shareInvite() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Je te d\u00e9fie sur FIG ! Clique ici pour jouer : $_inviteLink',
      ),
    );

    if (!mounted) return;
    setState(() {
      _inviteSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  FigColors.background,
                  FigColors.backgroundDeep,
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
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: figCream,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _inviteSent
                        ? 'Invitation envoy\u00e9e.'
                        : 'On lance un d\u00e9fi ?',
                    style: const TextStyle(
                      fontFamily: 'Florisha',
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      color: figCream,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _inviteSent
                        ? 'Maintenant choisis ton d\u00e9fi et joue ton tour.'
                        : 'Envoie le lien \u00e0 la personne que tu veux d\u00e9fier.\nElle appara\u00eetra dans ta partie d\u00e8s qu\u2019elle rejoint.',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      color: Colors.white70,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (_inviteSent)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: figCream,
                                size: 22,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Lien envoy\u00e9 \u2014 en attente de l\u2019adversaire',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    color: figCream,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    _inviteLink,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: Colors.white54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: _shareInvite,
                                  child: const Icon(
                                    Icons.share_rounded,
                                    color: figCream,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
SizedBox(
  width: double.infinity,
  child: FilledButton(
    onPressed: _inviteSent
        ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChallengeSelectScreen(),
              ),
            );
          }
        : _shareInvite,
    style: FilledButton.styleFrom(
      backgroundColor: figCream,
      foregroundColor: figBackground,
      padding: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
    child: Text(
      _inviteSent
          ? 'Choisir mon d\u00e9fi'
          : 'Partager l\u2019invitation',
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
),
const SizedBox(height: 12),
SizedBox(
  width: double.infinity,
  child: TextButton(
    onPressed: _inviteSent
        ? () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: FigColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                title: const Text(
                  'Annuler la partie ?',
                  style: TextStyle(
                    fontFamily: 'Florisha',
                    fontWeight: FontWeight.w700,
                    color: figCream,
                  ),
                ),
                content: const Text(
                  'Le lien envoy\u00e9 ne fonctionnera plus et la partie sera supprim\u00e9e.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Non, garder',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                      // TODO: backend → invalider le lien + supprimer la partie
                    },
                    child: const Text(
                      'Oui, annuler',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE57373),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChallengeSelectScreen(),
              ),
            );
          },
    style: TextButton.styleFrom(
      foregroundColor: Colors.white54,
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    child: Text(
      _inviteSent
          ? 'Annuler la partie'
          : 'Passer pour l\u2019instant',
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
