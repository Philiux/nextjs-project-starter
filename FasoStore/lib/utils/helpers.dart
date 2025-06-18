import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class Helpers {
  // Formatage des prix
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      symbol: 'FCFA ',
      decimalDigits: 0,
      locale: 'fr_FR',
    );
    return formatter.format(price);
  }

  // Formatage des dates
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(date);
  }

  // Validation du numéro de téléphone
  static bool isValidPhoneNumber(String phone) {
    return Constants.allowedCountryCodes.any((code) => phone.startsWith(code)) &&
        phone.length >= 12 &&
        phone.length <= 13;
  }

  // Validation de l'email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validation du mot de passe
  static bool isValidPassword(String password) {
    return password.length >= Constants.minPasswordLength &&
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password);
  }

  // Affichage des messages d'erreur
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Affichage des messages de succès
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Boîte de dialogue de confirmation
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Boîte de dialogue de chargement
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Masquer la boîte de dialogue de chargement
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Génération d'un ID unique
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Calcul de la taille d'un fichier en MB
  static double getFileSizeInMB(int bytes) {
    return bytes / (1024 * 1024);
  }

  // Vérification de la connexion Internet
  static Future<bool> hasInternetConnection() async {
    try {
      // TODO: Implémenter la vérification de la connexion Internet
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtenir le statut de la commande en français
  static String getOrderStatusInFrench(String status) {
    return Constants.orderStatuses[status] ?? 'Inconnu';
  }

  // Validation des données du produit
  static String? validateProduct({
    required String name,
    required String description,
    required double price,
  }) {
    if (name.isEmpty || name.length > Constants.maxProductNameLength) {
      return 'Nom de produit invalide';
    }
    if (description.isEmpty || description.length > Constants.maxProductDescriptionLength) {
      return 'Description de produit invalide';
    }
    if (price <= 0 || price > Constants.maxProductPrice) {
      return 'Prix invalide';
    }
    return null;
  }
}
