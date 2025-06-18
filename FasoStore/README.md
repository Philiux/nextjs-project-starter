# Faso Store

Application de marketplace pour le Burkina Faso développée avec Flutter.

## Fonctionnalités

- 🛍️ Achat et vente de produits
- 🚚 Système de livraison intégré
- 💳 Paiement sécurisé (Mobile Money, Carte)
- 📱 Interface utilisateur intuitive
- 🗺️ Géolocalisation des vendeurs et livreurs
- 📊 Tableau de bord administrateur

## Configuration requise

- Flutter SDK >=3.0.0 <4.0.0
- Dart SDK >=3.0.0 <4.0.0
- Firebase project configuré

## Installation

1. Cloner le projet
```bash
git clone https://github.com/votre-username/faso-store.git
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Configurer Firebase
- Ajouter le fichier google-services.json pour Android
- Ajouter le fichier GoogleService-Info.plist pour iOS

4. Lancer l'application
```bash
flutter run
```

## Structure du projet

```
lib/
├── models/         # Modèles de données
├── providers/      # Gestion d'état avec Provider
├── screens/        # Écrans de l'application
├── services/       # Services (Firebase, API, etc.)
├── utils/          # Utilitaires et constantes
└── widgets/        # Widgets réutilisables
```

## Technologies utilisées

- Flutter
- Firebase (Auth, Firestore, Storage)
- Provider pour la gestion d'état
- Google Maps pour la géolocalisation
- Stripe pour les paiements

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou à soumettre une pull request.

## Licence

MIT License
