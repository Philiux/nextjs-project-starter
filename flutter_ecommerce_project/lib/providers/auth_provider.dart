import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    notifyListeners();
  }

  Future<void> signInWithPhoneNumber(String phoneNumber, String smsCode) async {
    if (!Constants.allowedCountryCodes.any((code) => phoneNumber.startsWith(code))) {
      _errorMessage = 'Numéro de téléphone non autorisé.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      // Ici, vous devez implémenter la logique complète de vérification du code SMS
      // Pour simplifier, on suppose que la connexion est réussie
      // Exemple : await _auth.signInWithCredential(credential);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
