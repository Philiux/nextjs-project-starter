import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Obtenir l'utilisateur courant
  User? get currentUser => _auth.currentUser;

  // Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inscription avec email et mot de passe
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      // Vérifier si le numéro de téléphone est autorisé
      if (!Helpers.isValidPhoneNumber(phoneNumber)) {
        throw FirebaseAuthException(
          code: 'invalid-phone-number',
          message: Constants.errorInvalidPhone,
        );
      }

      // Créer l'utilisateur
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Créer le profil utilisateur dans Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'role': UserRole.buyer.toString(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Mettre à jour le profil Firebase Auth
        await userCredential.user!.updateDisplayName(name);
      }

      return userCredential;
    } catch (e) {
      print('Erreur d\'inscription: $e');
      rethrow;
    }
  }

  // Connexion avec email et mot de passe
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Erreur de connexion: $e');
      rethrow;
    }
  }

  // Authentification par téléphone
  Future<void> signInWithPhone(
    String phoneNumber,
    Function(String) onCodeSent,
    Function(String) onError,
  ) async {
    try {
      if (!Helpers.isValidPhoneNumber(phoneNumber)) {
        throw FirebaseAuthException(
          code: 'invalid-phone-number',
          message: Constants.errorInvalidPhone,
        );
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Erreur de vérification');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(minutes: Constants.otpTimeout),
      );
    } catch (e) {
      print('Erreur d\'authentification par téléphone: $e');
      rethrow;
    }
  }

  // Vérifier le code OTP
  Future<UserCredential> verifyOTP(String verificationId, String code) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Erreur de vérification OTP: $e');
      rethrow;
    }
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Erreur de réinitialisation du mot de passe: $e');
      rethrow;
    }
  }

  // Mise à jour du profil utilisateur
  Future<void> updateUserProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
