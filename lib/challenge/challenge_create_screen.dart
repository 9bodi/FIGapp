import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/fig_theme.dart';
import '../services/game_service.dart';
import 'challenge_select_screen.dart';

class ChallengeCreateScreen extends StatefulWidget {
  const ChallengeCreateScreen({super.key});

  @override
  State<ChallengeCreateScreen> createState() => _ChallengeCreateScreenState();
}

class _ChallengeCreateScreenState extends State<ChallengeCreateScreen> {
  static const Color figBackground = FigColors.background;
  static const Color figCream = FigColors.cream;

  final GameService _gameService = GameService();

  bool _inviteSent = false;
  bool _creating = false;
  bool _codeCopied = false;
  String? _gameId;
  String? _inviteCode;

  Future<void> _createAndShare() async {
    setState(() => _creating = true);

    try {
      final gameId = await _gameService.createGame();

      final inviteCode = gameId.substring(0, 8);
      final inviteLink = 'https://figapp.link/invite/$inviteCode';

      await SharePlus.instance.share(
        ShareParams(
          text:
              'Je te défie sur FIG ! Rejoins la partie avec le code : $inviteCode\n\n$inviteLink',
        ),
      );

      if (!mounted) return;
      setState(() {
        _gameId = gameId;
        _inviteCode = inviteCode;
        _inviteSent = true;
        _creating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _creating = false);
    }
  }

  void _copyCode() {
    if (_inviteCode == null) return;
    Clipboard.setData(ClipboardData(text: _inviteCode!));
    setState(() => _codeCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _codeCopied = false);
    });
  }

  Future<void> _reshare() async {
    if (_inviteCode == null) return;
    final inviteLink = 'https://figapp.link/invite/$_inviteCode';

    await SharePlus.instance.share(
      ShareParams(
        text:
            'Je te défie sur FIG ! Rejoins la partie avec le code : $_inviteCode\n\n$inviteLink',
      ),
    );
  }

  Future<void> _cancelGame() async {
    if (_gameId != null) {
      await _gameService.cancelGame(_gameId!);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [FigColors.background, FigColors.backgroundDeep],
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
          Column(
            children: [
              // ── Contenu scrollable ──
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                              ? 'Invitation envoyée.'
                              : 'On lance un défi ?',
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
                              ? 'Donne ce code à ton adversaire, puis choisis ton défi.'
                              : 'Envoie le lien à la personne que tu veux défier.\nElle apparaîtra dans ta partie dès qu\u2019elle rejoint.',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            color: Colors.white70,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 28),

                        if (_inviteSent && _inviteCode != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'CODE DE LA PARTIE',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white54,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _inviteCode!,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: figCream,
                                      letterSpacing: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    _ActionChip(
                                      icon: _codeCopied
                                          ? Icons.check_rounded
                                          : Icons.copy_rounded,
                                      label: _codeCopied
                                          ? 'Copié !'
                                          : 'Copier',
                                      onTap: _copyCode,
                                    ),
                                    const SizedBox(width: 12),
                                    _ActionChip(
                                      icon: Icons.share_rounded,
                                      label: 'Partager',
                                      onTap: _reshare,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: figCream.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white54,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Ton adversaire entre ce code dans « Rejoindre une partie » sur son app.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: Colors.white54,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Boutons fixés en bas ──
              Container(
                color: FigColors.background,
                padding: EdgeInsets.fromLTRB(
                    24, 12, 24, 20 + bottomPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _creating
                            ? null
                            : _inviteSent
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChallengeSelectScreen(
                                          gameId: _gameId,
                                        ),
                                      ),
                                    );
                                  }
                                : _createAndShare,
                        style: FilledButton.styleFrom(
                          backgroundColor: figCream,
                          foregroundColor: figBackground,
                          disabledBackgroundColor:
                              Colors.white.withOpacity(0.08),
                          disabledForegroundColor: Colors.white38,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: Text(
                          _creating
                              ? 'Création…'
                              : _inviteSent
                                  ? 'Choisir mon défi'
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
                                    backgroundColor:
                                        FigColors.background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(22),
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
                                      'Le code ne fonctionnera plus et la partie sera supprimée.',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.white70,
                                        height: 1.4,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx),
                                        child: const Text(
                                          'Non, garder',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          _cancelGame();
                                        },
                                        child: const Text(
                                          'Oui, annuler',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight:
                                                FontWeight.w700,
                                            color:
                                                Color(0xFFE57373),
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
                                    builder: (_) =>
                                        const ChallengeSelectScreen(),
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white54,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16),
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
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: FigColors.cream, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FigColors.cream,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
