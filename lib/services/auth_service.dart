import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// L'utilisateur connecté actuellement
  User? get currentUser => _auth.currentUser;

  /// Stream pour écouter les changements d'auth
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Connexion anonyme (pour l'instant)
  Future<User?> signInAnonymously() async {
    if (_auth.currentUser != null) return _auth.currentUser;
    final result = await _auth.signInAnonymously();
    return result.user;
  }

  /// Vérifie si l'utilisateur a déjà un nom
  Future<bool> hasDisplayName() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists && doc.data()?['displayName'] != null;
  }

  /// Récupère le nom de l'utilisateur
  Future<String?> getDisplayName() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['displayName'];
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
