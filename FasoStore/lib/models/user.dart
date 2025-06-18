import 'location.dart';

enum UserRole { buyer, seller, admin, courier }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final UserRole role;
  final String? photoUrl;
  final Location? shopLocation; // Localisation de la boutique pour les vendeurs
  final bool isAvailable; // Disponibilité pour les coursiers
  final double? rating; // Note moyenne (vendeurs et coursiers)
  final int completedDeliveries; // Nombre de livraisons effectuées (coursiers)

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.photoUrl,
    this.shopLocation,
    this.isAvailable = true,
    this.rating,
    this.completedDeliveries = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.toString(),
      'photoUrl': photoUrl,
      'shopLocation': shopLocation?.toMap(),
      'isAvailable': isAvailable,
      'rating': rating,
      'completedDeliveries': completedDeliveries,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      role: UserRole.values.firstWhere(
        (role) => role.toString() == map['role'],
        orElse: () => UserRole.buyer,
      ),
      photoUrl: map['photoUrl'],
      shopLocation: map['shopLocation'] != null 
          ? Location.fromMap(map['shopLocation'])
          : null,
      isAvailable: map['isAvailable'] ?? true,
      rating: map['rating']?.toDouble(),
      completedDeliveries: map['completedDeliveries'] ?? 0,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    UserRole? role,
    String? photoUrl,
    Location? shopLocation,
    bool? isAvailable,
    double? rating,
    int? completedDeliveries,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      shopLocation: shopLocation ?? this.shopLocation,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      completedDeliveries: completedDeliveries ?? this.completedDeliveries,
    );
  }
}
