import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/location_data.dart';

class DeliveryZoneSettings {
  final String country;
  final String region;
  final double baseFee;
  final double kmFee;
  final bool isActive;
  final DateTime updatedAt;

  DeliveryZoneSettings({
    required this.country,
    required this.region,
    required this.baseFee,
    required this.kmFee,
    this.isActive = true,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'region': region,
      'baseFee': baseFee,
      'kmFee': kmFee,
      'isActive': isActive,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeliveryZoneSettings.fromMap(Map<String, dynamic> map) {
    return DeliveryZoneSettings(
      country: map['country'],
      region: map['region'],
      baseFee: map['baseFee'].toDouble(),
      kmFee: map['kmFee'].toDouble(),
      isActive: map['isActive'] ?? true,
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

class DeliveryZonesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'delivery_zones';

  // Singleton pattern
  static final DeliveryZonesService _instance = DeliveryZonesService._internal();
  factory DeliveryZonesService() => _instance;
  DeliveryZonesService._internal();

  // Obtenir les paramètres pour une zone spécifique
  Future<DeliveryZoneSettings?> getZoneSettings(String country, String region) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc('${country}_$region')
          .get();

      if (doc.exists) {
        return DeliveryZoneSettings.fromMap(doc.data()!);
      }

      // Retourner les paramètres par défaut si aucun n'existe
      return DeliveryZoneSettings(
        country: country,
        region: region,
        baseFee: 500, // 500 FCFA de base
        kmFee: 100,   // 100 FCFA par km
      );
    } catch (e) {
      print('Erreur lors de la récupération des paramètres de zone: $e');
      return null;
    }
  }

  // Mettre à jour les paramètres d'une zone
  Future<void> updateZoneSettings(DeliveryZoneSettings settings) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('${settings.country}_${settings.region}')
          .set(settings.toMap());
    } catch (e) {
      print('Erreur lors de la mise à jour des paramètres de zone: $e');
      rethrow;
    }
  }

  // Obtenir tous les paramètres de zone pour un pays
  Future<List<DeliveryZoneSettings>> getCountrySettings(String country) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('country', isEqualTo: country)
          .get();

      return snapshot.docs
          .map((doc) => DeliveryZoneSettings.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des paramètres du pays: $e');
      return [];
    }
  }

  // Calculer les frais de livraison entre deux points
  Future<double> calculateDeliveryFee(String country, String region, double distance) async {
    try {
      final settings = await getZoneSettings(country, region);
      if (settings != null && settings.isActive) {
        return settings.baseFee + (settings.kmFee * distance);
      }
      throw Exception('Zone de livraison non disponible');
    } catch (e) {
      print('Erreur lors du calcul des frais de livraison: $e');
      rethrow;
    }
  }

  // Vérifier si la livraison est possible entre deux points
  Future<bool> isDeliveryPossible(String fromCountry, String fromRegion, String toCountry, String toRegion) async {
    try {
      // Vérifier si les deux zones sont actives
      final fromSettings = await getZoneSettings(fromCountry, fromRegion);
      final toSettings = await getZoneSettings(toCountry, toRegion);

      if (fromSettings == null || toSettings == null) {
        return false;
      }

      // Pour l'instant, on n'autorise que les livraisons dans le même pays
      if (fromCountry != toCountry) {
        return false;
      }

      return fromSettings.isActive && toSettings.isActive;
    } catch (e) {
      print('Erreur lors de la vérification de la possibilité de livraison: $e');
      return false;
    }
  }

  // Initialiser les paramètres par défaut pour toutes les zones
  Future<void> initializeDefaultSettings() async {
    try {
      for (var country in CountryData.countries.keys) {
        final regions = CountryData.getRegions(country);
        for (var region in regions) {
          final settings = DeliveryZoneSettings(
            country: country,
            region: region,
            baseFee: 500,  // 500 FCFA de base
            kmFee: 100,    // 100 FCFA par km
          );
          await updateZoneSettings(settings);
        }
      }
    } catch (e) {
      print('Erreur lors de l\'initialisation des paramètres par défaut: $e');
      rethrow;
    }
  }

  // Obtenir la liste des zones actives pour un pays
  Future<List<String>> getActiveRegions(String country) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('country', isEqualTo: country)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => DeliveryZoneSettings.fromMap(doc.data()).region)
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des zones actives: $e');
      return [];
    }
  }
}
