import 'package:flutter/material.dart';
import '../models/delivery.dart';
import '../models/location.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../services/delivery_service.dart';

class DeliveryProvider with ChangeNotifier {
  final DeliveryService _deliveryService = DeliveryService();
  List<Delivery> _activeDeliveries = [];
  List<UserModel> _availableCouriers = [];
  bool _isLoading = false;
  String? _error;

  List<Delivery> get activeDeliveries => _activeDeliveries;
  List<UserModel> get availableCouriers => _availableCouriers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Créer une nouvelle livraison
  Future<Delivery?> createDelivery({
    required Order order,
    required Location pickupLocation,
    required Location deliveryLocation,
    required DeliveryType type,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _error = null;

      final delivery = await _deliveryService.createDelivery(
        order: order,
        pickupLocation: pickupLocation,
        deliveryLocation: deliveryLocation,
        type: type,
        notes: notes,
      );

      _activeDeliveries.add(delivery);
      notifyListeners();
      return delivery;
    } catch (e) {
      _error = 'Erreur lors de la création de la livraison: $e';
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Calculer les frais de livraison
  double calculateDeliveryFee(Location pickup, Location delivery) {
    return _deliveryService.calculateDeliveryFee(pickup, delivery);
  }

  // Rechercher des livreurs disponibles
  Future<void> findAvailableCouriers(Location pickupLocation) async {
    try {
      _setLoading(true);
      _error = null;

      _availableCouriers = await _deliveryService.getAvailableCouriers(pickupLocation);
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de la recherche des livreurs: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Assigner un livreur
  Future<void> assignCourier(String deliveryId, UserModel courier) async {
    try {
      _setLoading(true);
      _error = null;

      await _deliveryService.assignCourier(deliveryId, courier);
      
      final index = _activeDeliveries.indexWhere((d) => d.id == deliveryId);
      if (index != -1) {
        // Mettre à jour la livraison localement
        final updatedDelivery = Delivery(
          id: _activeDeliveries[index].id,
          order: _activeDeliveries[index].order,
          pickupLocation: _activeDeliveries[index].pickupLocation,
          deliveryLocation: _activeDeliveries[index].deliveryLocation,
          type: _activeDeliveries[index].type,
          status: DeliveryStatus.accepted,
          courier: courier,
          createdAt: _activeDeliveries[index].createdAt,
          acceptedAt: DateTime.now(),
          deliveryFee: _activeDeliveries[index].deliveryFee,
          notes: _activeDeliveries[index].notes,
        );
        _activeDeliveries[index] = updatedDelivery;
      }
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de l\'assignation du livreur: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour le statut d'une livraison
  Future<void> updateDeliveryStatus(String deliveryId, DeliveryStatus status) async {
    try {
      _setLoading(true);
      _error = null;

      await _deliveryService.updateDeliveryStatus(deliveryId, status);
      
      final index = _activeDeliveries.indexWhere((d) => d.id == deliveryId);
      if (index != -1) {
        // Mettre à jour le statut localement
        final updatedDelivery = Delivery(
          id: _activeDeliveries[index].id,
          order: _activeDeliveries[index].order,
          pickupLocation: _activeDeliveries[index].pickupLocation,
          deliveryLocation: _activeDeliveries[index].deliveryLocation,
          type: _activeDeliveries[index].type,
          status: status,
          courier: _activeDeliveries[index].courier,
          createdAt: _activeDeliveries[index].createdAt,
          acceptedAt: _activeDeliveries[index].acceptedAt,
          pickedUpAt: status == DeliveryStatus.pickedUp ? DateTime.now() : null,
          deliveredAt: status == DeliveryStatus.delivered ? DateTime.now() : null,
          deliveryFee: _activeDeliveries[index].deliveryFee,
          notes: _activeDeliveries[index].notes,
        );
        _activeDeliveries[index] = updatedDelivery;
      }
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors de la mise à jour du statut: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Écouter les livraisons d'un livreur
  void listenToCourierDeliveries(String courierId) {
    _deliveryService.getCourierDeliveries(courierId).listen(
      (deliveries) {
        _activeDeliveries = deliveries;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Erreur lors de l\'écoute des livraisons: $e';
        notifyListeners();
      },
    );
  }

  // Écouter les livraisons d'un client
  void listenToCustomerDeliveries(String customerId) {
    _deliveryService.getCustomerDeliveries(customerId).listen(
      (deliveries) {
        _activeDeliveries = deliveries;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Erreur lors de l\'écoute des livraisons: $e';
        notifyListeners();
      },
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
