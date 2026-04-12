import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/fig_theme.dart';
import '../home_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  static const Color figBackground = FigColors.background;
  static const Color figCream = FigColors.cream;

  final TextEditingController _nameController = TextEditingController();
  bool _saving = false;

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'displayName': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      if (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasName = _nameController.text.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                'assets/logo_symbol.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        Center(
                          child: Image.asset(
                            'assets/logo_full.png',
                            width: 160,
                          ),
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          'Comment tu t\u2019appelles ?',
                          style: TextStyle(
                            fontFamily: 'Florisha',
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                            color: figCream,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'C\u2019est le nom que verront tes adversaires.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            color: Colors.white70,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextField(
                          controller: _nameController,
                          onChanged: (_) => setState(() {}),
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: figCream,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ton pr\u00e9nom',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white38,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.04),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                color: Color(0x66E9DFC8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          _saving ? null : (hasName ? _saveName : null),
                      style: FilledButton.styleFrom(
                        backgroundColor: figCream,
                        foregroundColor: figBackground,
                        disabledBackgroundColor:
                            Colors.white.withOpacity(0.08),
                        disabledForegroundColor: Colors.white38,
                        padding:
                            const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        _saving
                            ? 'Un instant\u2026'
                            : 'C\u2019est parti',
                        style: const TextStyle(
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
        ],
      ),
    );
  }
}
