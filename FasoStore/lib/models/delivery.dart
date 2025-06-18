import 'package:flutter/material.dart';
import 'location.dart';
import 'user.dart';
import 'order.dart';

enum DeliveryStatus {
  pending,    // En attente d'un livreur
  accepted,   // Accepté par un livreur
  pickedUp,   // Colis récupéré
  inTransit,  // En cours de livraison
  delivered,  // Livré
  cancelled,  // Annulé
}

enum DeliveryType {
  courier,    // Livraison par coursier
  pickup,     // Récupération en boutique
}

class DeliveryFee {
  final double baseFee;      // Frais de base
  final double perKmFee;     // Frais par kilomètre
  final double rushHourFee;  // Frais supplémentaires heures de pointe

  const DeliveryFee({
    this.baseFee = 500,     // 500 FCFA de base
    this.perKmFee = 100,    // 100 FCFA par km
    this.rushHourFee = 200, // 200 FCFA supplémentaires en heure de pointe
  });

  double calculate(double distance, {bool isRushHour = false}) {
    double total = baseFee + (distance * perKmFee);
    if (isRushHour) total += rushHourFee;
    return total;
  }
}

class Delivery {
  final String id;
  final Order order;
  final Location pickupLocation;
  final Location deliveryLocation;
  final DeliveryType type;
  final DeliveryStatus status;
  final UserModel? courier;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final double deliveryFee;
  final String? notes;

  Delivery({
    required this.id,
    required this.order,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.type,
    this.status = DeliveryStatus.pending,
    this.courier,
    required this.createdAt,
    this.acceptedAt,
    this.pickedUpAt,
    this.deliveredAt,
    required this.deliveryFee,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': order.id,
      'pickupLocation': pickupLocation.toMap(),
      'deliveryLocation': deliveryLocation.toMap(),
      'type': type.toString(),
      'status': status.toString(),
      'courierId': courier?.id,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'deliveryFee': deliveryFee,
      'notes': notes,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map, Order order, UserModel? courier) {
    return Delivery(
      id: map['id'],
      order: order,
      pickupLocation: Location.fromMap(map['pickupLocation']),
      deliveryLocation: Location.fromMap(map['deliveryLocation']),
      type: DeliveryType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => DeliveryType.courier,
      ),
      status: DeliveryStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => DeliveryStatus.pending,
      ),
      courier: courier,
      createdAt: DateTime.parse(map['createdAt']),
      acceptedAt: map['acceptedAt'] != null ? DateTime.parse(map['acceptedAt']) : null,
      pickedUpAt: map['pickedUpAt'] != null ? DateTime.parse(map['pickedUpAt']) : null,
      deliveredAt: map['deliveredAt'] != null ? DateTime.parse(map['deliveredAt']) : null,
      deliveryFee: map['deliveryFee'],
      notes: map['notes'],
    );
  }

  bool get isInSameCity => pickupLocation.isInSameCity(deliveryLocation);

  double get distance => pickupLocation.distanceTo(deliveryLocation);

  String get statusText {
    switch (status) {
      case DeliveryStatus.pending:
        return 'En attente';
      case DeliveryStatus.accepted:
        return 'Accepté';
      case DeliveryStatus.pickedUp:
        return 'Colis récupéré';
      case DeliveryStatus.inTransit:
        return 'En cours de livraison';
      case DeliveryStatus.delivered:
        return 'Livré';
      case DeliveryStatus.cancelled:
        return 'Annulé';
    }
  }

  Color get statusColor {
    switch (status) {
      case DeliveryStatus.pending:
        return Colors.orange;
      case DeliveryStatus.accepted:
        return Colors.blue;
      case DeliveryStatus.pickedUp:
        return Colors.purple;
      case DeliveryStatus.inTransit:
        return Colors.amber;
      case DeliveryStatus.delivered:
        return Colors.green;
      case DeliveryStatus.cancelled:
        return Colors.red;
    }
  }
}
