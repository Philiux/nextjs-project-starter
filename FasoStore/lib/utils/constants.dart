class Constants {
  // Codes pays autorisés pour l'authentification
  static const List<String> allowedCountryCodes = [
    '+226', // Burkina Faso
    '+223', // Mali
    '+227', // Niger
  ];

  // Configuration des commissions
  static const double commissionRate = 0.025; // 2.5% (divisé par 2)
  static const double minimumCommission = 50.0; // 50 FCFA minimum (divisé par 2)

  // Configuration des paiements
  static const String stripePublishableKey = 'pk_test_votre_cle_publique';
  static const String stripeSecretKey = 'sk_test_votre_cle_secrete';

  // Mobile Money
  static const Map<String, String> mobileMoneyProviders = {
    'Orange Money': '+226 01 02 03 04',
    'Moov Money': '+226 05 06 07 08',
    'Telecel Money': '+226 09 10 11 12',
  };

  // URLs de l'API
  static const String baseApiUrl = 'https://votre-api.com';
  static const String imageProcessingApiUrl = 'https://api.remove.bg/v1.0/removebg';

  // Paramètres de l'application
  static const int maxProductImages = 5;
  static const int maxProductsPerPage = 20;
  static const double maxImageSize = 5.0; // En MB

  // Messages d'erreur
  static const String errorInvalidPhone = 'Numéro de téléphone non autorisé';
  static const String errorPaymentFailed = 'Le paiement a échoué';
  static const String errorImageTooLarge = 'Image trop volumineuse';
  static const String errorInvalidCredentials = 'Identifiants invalides';

  // Messages de succès
  static const String successPayment = 'Paiement réussi';
  static const String successOrderCreated = 'Commande créée avec succès';
  static const String successProductAdded = 'Produit ajouté avec succès';

  // Catégories de produits
  static const List<String> productCategories = [
    'Électronique',
    'Mode',
    'Maison',
    'Beauté',
    'Sports',
    'Alimentation',
    'Livres',
    'Autres',
  ];

  // États des commandes
  static const Map<String, String> orderStatuses = {
    'pending': 'En attente',
    'processing': 'En traitement',
    'shipped': 'Expédié',
    'delivered': 'Livré',
    'cancelled': 'Annulé',
  };

  // Thème
  static const Map<String, dynamic> themeColors = {
    'primary': 0xFF2196F3,
    'secondary': 0xFF4CAF50,
    'accent': 0xFFFFC107,
    'error': 0xFFE53935,
    'background': 0xFFFFFFFF,
  };

  // Paramètres de validation
  static const int minPasswordLength = 8;
  static const int maxProductNameLength = 100;
  static const int maxProductDescriptionLength = 1000;
  static const double maxProductPrice = 10000000; // 10 millions FCFA

  // Délais
  static const int sessionTimeout = 30; // minutes
  static const int otpTimeout = 2; // minutes
  static const int paymentTimeout = 15; // minutes
}
