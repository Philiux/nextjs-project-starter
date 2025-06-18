import 'package:flutter/material.dart';
import '../services/delivery_zones_service.dart';

class DeliveryZonesProvider with ChangeNotifier {
  final DeliveryZonesService _service = DeliveryZonesService();
  
  Map<String, List<DeliveryZoneSettings>> _zonesByCountry = {};
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<DeliveryZoneSettings> getZonesForCountry(String country) {
    return _zonesByCountry[country] ?? [];
  }

  // Charger les paramètres pour un pays spécifique
  Future<void> loadCountrySettings(String country) async {
    try {
      _setLoading(true);
      _error = null;

      final settings = await _service.getCountrySettings(country);
      _zonesByCountry[country] = settings;
      
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des paramètres: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour les paramètres d'une zone
  Future<void> updateZoneSettings(DeliveryZoneSettings settings) async {
    try {
      _setLoading(true);
      _error = null;

      await _service.updateZoneSettings(settings);
      
      // Mettre à jour la liste locale
      final countrySettings = _zonesByCountry[settings.country] ?? [];
      final index = countrySettings.indexWhere(
        (zone) => zone.region == settings.region,
      );
      
      if (index != -1) {
        countrySettings[index] = settings;
      } else {
        countrySettings.add(settings);
      }
      
      _zonesByCountry[settings.country] = countrySettings;
      
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de la mise à jour des paramètres: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Calculer les frais de livraison
  Future<double> calculateDeliveryFee(String country, String region, double distance) async {
    try {
      _error = null;
      return await _service.calculateDeliveryFee(country, region, distance);
    } catch (e) {
      _error = 'Erreur lors du calcul des frais: $e';
      notifyListeners();
      rethrow;
    }
  }

  // Vérifier si la livraison est possible
  Future<bool> isDeliveryPossible(
    String fromCountry,
    String fromRegion,
    String toCountry,
    String toRegion,
  ) async {
    try {
      _error = null;
      return await _service.isDeliveryPossible(
        fromCountry,
        fromRegion,
        toCountry,
        toRegion,
      );
    } catch (e) {
      _error = 'Erreur lors de la vérification: $e';
      notifyListeners();
      return false;
    }
  }

  // Initialiser les paramètres par défaut
  Future<void> initializeDefaultSettings() async {
    try {
      _setLoading(true);
      _error = null;

      await _service.initializeDefaultSettings();
      
      // Recharger les paramètres pour tous les pays
      for (var country in ['Burkina Faso', 'Mali', 'Niger']) {
        await loadCountrySettings(country);
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de l\'initialisation: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Obtenir les régions actives pour un pays
  Future<List<String>> getActiveRegions(String country) async {
    try {
      _error = null;
      return await _service.getActiveRegions(country);
    } catch (e) {
      _error = 'Erreur lors de la récupération des régions actives: $e';
      notifyListeners();
      return [];
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Vérifier si une zone est active
  bool isZoneActive(String country, String region) {
    final zones = _zonesByCountry[country] ?? [];
    final zone = zones.firstWhere(
      (z) => z.region == region,
      orElse: () => DeliveryZoneSettings(
        country: country,
        region: region,
        baseFee: 500,
        kmFee: 100,
        isActive: false,
      ),
    );
    return zone.isActive;
  }

  // Obtenir les paramètres d'une zone
  DeliveryZoneSettings? getZoneSettings(String country, String region) {
    final zones = _zonesByCountry[country] ?? [];
    try {
      return zones.firstWhere((z) => z.region == region);
    } catch (e) {
      return null;
    }
  }

  // Activer/désactiver une zone
  Future<void> toggleZoneStatus(String country, String region) async {
    final currentSettings = getZoneSettings(country, region);
    if (currentSettings != null) {
      final newSettings = DeliveryZoneSettings(
        country: country,
        region: region,
        baseFee: currentSettings.baseFee,
        kmFee: currentSettings.kmFee,
        isActive: !currentSettings.isActive,
      );
      await updateZoneSettings(newSettings);
    }
  }
}
