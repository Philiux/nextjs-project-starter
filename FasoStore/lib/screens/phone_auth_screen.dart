import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/helpers.dart';
import '../services/auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String? _verificationId;
  bool _codeSent = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  void _verifyPhone() async {
    final phone = _phoneController.text.trim();
    if (!isPhoneNumberAllowed(phone)) {
      setState(() {
        _errorMessage = 'Numéro de téléphone non autorisé.';
      });
      return;
    }
    setState(() {
      _errorMessage = null;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigate to home or dashboard
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _errorMessage = e.message;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithCode() async {
    final code = _codeController.text.trim();
    if (_verificationId == null) return;

    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: code);
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to home or dashboard
    } catch (e) {
      setState(() {
        _errorMessage = 'Code invalide.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentification par téléphone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                hintText: '+226xxxxxxxx',
              ),
              keyboardType: TextInputType.phone,
              enabled: !_codeSent,
            ),
            if (_codeSent)
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Code de vérification',
                ),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _codeSent ? _signInWithCode : _verifyPhone,
              child: Text(_codeSent ? 'Se connecter' : 'Envoyer le code'),
            ),
          ],
        ),
      ),
    );
  }
}
