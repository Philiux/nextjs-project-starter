# Structure complète de l'application Flutter E-commerce (style AliExpress)

## Dossiers principaux

- /lib
  - /models
    - user.dart
    - product.dart
    - category.dart
    - order.dart
    - cart_item.dart
  - /screens
    - auth/
      - login_screen.dart
      - register_screen.dart
      - phone_auth_screen.dart
      - forgot_password_screen.dart
    - buyer/
      - home_screen.dart
      - product_list_screen.dart
      - product_detail_screen.dart
      - cart_screen.dart
      - order_history_screen.dart
      - profile_screen.dart
    - seller/
      - dashboard_screen.dart
      - product_management_screen.dart
      - order_management_screen.dart
      - image_processing_tools.dart
    - admin/
      - dashboard_screen.dart
      - user_management_screen.dart
      - product_management_screen.dart
      - order_management_screen.dart
    - common/
      - splash_screen.dart
      - onboarding_screens.dart
      - settings_screen.dart
  - /providers
    - auth_provider.dart
    - user_provider.dart
    - cart_provider.dart
    - product_provider.dart
    - order_provider.dart
  - /services
    - auth_service.dart
    - payment_service.dart
    - image_processing_service.dart
    - product_service.dart
    - order_service.dart
  - /utils
    - constants.dart
    - helpers.dart
    - commission.dart
  - main.dart

## Fonctionnalités clés

- Authentification par téléphone (avec restriction pays) et email
- Gestion des rôles utilisateurs (acheteur, vendeur, admin)
- Catalogue produits avec catégories, marques, filtres
- Panier, commandes, historique commandes
- Tableau de bord vendeur avec gestion produits, commandes, outils images (suppression arrière-plan)
- Tableau de bord admin avec gestion utilisateurs, produits, commandes
- Paiements intégrés : Mobile Money + Carte de crédit (Stripe)
- UI moderne, responsive, multilingue (français/anglais)

## Prochaines étapes

- Implémenter main.dart avec navigation et providers
- Implémenter auth_provider avec Firebase Auth
- Créer écrans d'authentification (login, register, phone auth)
- Créer écrans acheteur (catalogue, produit, panier, profil)
- Créer écrans vendeur (dashboard, gestion produits, outils images)
- Créer écrans admin (dashboard, gestion utilisateurs)
- Intégrer paiements Mobile Money et Stripe
- Ajouter gestion commandes et historique
