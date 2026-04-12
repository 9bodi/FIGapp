import 'package:flutter/material.dart';
import '../theme/fig_theme.dart';
import '../services/auth_service.dart';
import '../services/game_service.dart';
import 'name_screen.dart';
import '../challenge/challenge_opponent_flow.dart';

class JoinScreen extends StatefulWidget {
  final String? inviteCode;
  const JoinScreen({super.key, this.inviteCode});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.inviteCode != null) {
      _codeController.text = widget.inviteCode!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _joinGame());
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinGame() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'Entre le code d\'invitation');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await AuthService().signInAnonymously();

      final hasName = await AuthService().hasDisplayName();
      if (!hasName && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NameScreen()),
        );
      }

      await GameService().joinGame(inviteCode: code);

      final gameData = await GameService().getGameByInviteCode(code);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChallengeOpponentFlow(
            gameId: gameData['id'],
            creatorName: gameData['creatorName'] ?? 'Ton adversaire',
            challengeQuestion: gameData['challengeQuestion'] ?? '',
            status: gameData['status'] ?? 'creatorPlaying',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [FigColors.background, FigColors.backgroundDeep],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Contenu scrollable ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                            'assets/logo_full.png', width: 120),
                      ),
                      const SizedBox(height: 48),
                      const Text(
                        'Rejoindre une partie',
                        style: TextStyle(
                          fontFamily: 'Florisha',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: FigColors.cream,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Entre le code reçu pour rejoindre le défi.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _codeController,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          color: FigColors.cream,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                        textCapitalization:
                            TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'CODE D\'INVITATION',
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.25),
                            letterSpacing: 2,
                          ),
                          filled: true,
                          fillColor:
                              Colors.white.withOpacity(0.06),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color:
                                  Colors.white.withOpacity(0.1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color:
                                  Colors.white.withOpacity(0.1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                            borderSide: const BorderSide(
                                color: FigColors.cream),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ── Bouton fixé en bas ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _loading ? null : _joinGame,
                    style: FilledButton.styleFrom(
                      backgroundColor: FigColors.cream,
                      foregroundColor: FigColors.background,
                      disabledBackgroundColor:
                          FigColors.cream.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: FigColors.background,
                            ),
                          )
                        : const Text(
                            'Rejoindre',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
