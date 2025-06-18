import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/delivery.dart';
import '../models/location.dart';
import '../models/order.dart';
import '../models/user.dart';

class DeliveryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DeliveryFee _deliveryFee = const DeliveryFee();

  // Singleton pattern
  static final DeliveryService _instance = DeliveryService._internal();
  factory DeliveryService() => _instance;
  DeliveryService._internal();

  // Créer une nouvelle livraison
  Future<Delivery> createDelivery({
    required Order order,
    required Location pickupLocation,
    required Location deliveryLocation,
    required DeliveryType type,
    String? notes,
  }) async {
    try {
      final String deliveryId = _firestore.collection('deliveries').doc().id;
      final double fee = calculateDeliveryFee(pickupLocation, deliveryLocation);

      final delivery = Delivery(
        id: deliveryId,
        order: order,
        pickupLocation: pickupLocation,
        deliveryLocation: deliveryLocation,
        type: type,
        createdAt: DateTime.now(),
        deliveryFee: fee,
        notes: notes,
      );

      await _firestore.collection('deliveries').doc(deliveryId).set(delivery.toMap());
      return delivery;
    } catch (e) {
      print('Erreur lors de la création de la livraison: $e');
      rethrow;
    }
  }

  // Calculer les frais de livraison
  double calculateDeliveryFee(Location pickup, Location delivery) {
    final double distance = pickup.distanceTo(delivery);
    final bool isRushHour = _isRushHour();
    return _deliveryFee.calculate(distance, isRushHour: isRushHour);
  }

  // Vérifier si c'est l'heure de pointe
  bool _isRushHour() {
    final now = DateTime.now();
    final hour = now.hour;
    
    // Heures de pointe: 7h-9h et 17h-19h
    return (hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19);
  }

  // Obtenir les livreurs disponibles dans la même ville
  Future<List<UserModel>> getAvailableCouriers(Location pickupLocation) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: UserRole.courier.toString())
          .where('isAvailable', isEqualTo: true)
          .where('city', isEqualTo: pickupLocation.city)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Erreur lors de la recherche des livreurs: $e');
      return [];
    }
  }

  // Assigner un livreur à une livraison
  Future<void> assignCourier(String deliveryId, UserModel courier) async {
    try {
      await _firestore.collection('deliveries').doc(deliveryId).update({
        'courierId': courier.id,
        'status': DeliveryStatus.accepted.toString(),
        'acceptedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Erreur lors de l\'assignation du livreur: $e');
      rethrow;
    }
  }

  // Mettre à jour le statut d'une livraison
  Future<void> updateDeliveryStatus(String deliveryId, DeliveryStatus status) async {
    try {
      final Map<String, dynamic> updateData = {
        'status': status.toString(),
      };

      switch (status) {
        case DeliveryStatus.pickedUp:
          updateData['pickedUpAt'] = DateTime.now().toIso8601String();
          break;
        case DeliveryStatus.delivered:
          updateData['deliveredAt'] = DateTime.now().toIso8601String();
          break;
        default:
          break;
      }

      await _firestore.collection('deliveries').doc(deliveryId).update(updateData);
    } catch (e) {
      print('Erreur lors de la mise à jour du statut: $e');
      rethrow;
    }
  }

  // Stream des livraisons pour un livreur
  Stream<List<Delivery>> getCourierDeliveries(String courierId) {
    return _firestore
        .collection('deliveries')
        .where('courierId', isEqualTo: courierId)
        .where('status', whereIn: [
          DeliveryStatus.accepted.toString(),
          DeliveryStatus.pickedUp.toString(),
          DeliveryStatus.inTransit.toString(),
        ])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Delivery.fromMap(
                  doc.data(),
                  Order.fromMap(doc.data()['order']),
                  null, // Le courier sera chargé séparément si nécessaire
                ))
            .toList());
  }

  // Stream des livraisons pour un client
  Stream<List<Delivery>> getCustomerDeliveries(String customerId) {
    return _firestore
        .collection('deliveries')
        .where('order.customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Delivery.fromMap(
                  doc.data(),
                  Order.fromMap(doc.data()['order']),
                  null,
                ))
            .toList());
  }
}
