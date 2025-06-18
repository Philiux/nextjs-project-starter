enum VehicleType {
  moto,
  tricycle,
  voiture,
  camionnette,
}

class DeliveryVehicle {
  final String id;
  final String matricule;
  final VehicleType type;
  final double capaciteKg;
  final double capaciteM3;
  final String? photoUrl;
  final bool isActive;
  final String proprietaireId;
  final List<String> zonesAutorisees;
  final DateTime dateAjout;
  final DateTime? dernierControle;
  final Map<String, dynamic>? documentsValidite;

  DeliveryVehicle({
    required this.id,
    required this.matricule,
    required this.type,
    required this.capaciteKg,
    required this.capaciteM3,
    this.photoUrl,
    this.isActive = true,
    required this.proprietaireId,
    required this.zonesAutorisees,
    required this.dateAjout,
    this.dernierControle,
    this.documentsValidite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matricule': matricule,
      'type': type.toString(),
      'capaciteKg': capaciteKg,
      'capaciteM3': capaciteM3,
      'photoUrl': photoUrl,
      'isActive': isActive,
      'proprietaireId': proprietaireId,
      'zonesAutorisees': zonesAutorisees,
      'dateAjout': dateAjout.toIso8601String(),
      'dernierControle': dernierControle?.toIso8601String(),
      'documentsValidite': documentsValidite,
    };
  }

  factory DeliveryVehicle.fromMap(Map<String, dynamic> map) {
    return DeliveryVehicle(
      id: map['id'],
      matricule: map['matricule'],
      type: VehicleType.values.firstWhere(
        (t) => t.toString() == map['type'],
        orElse: () => VehicleType.moto,
      ),
      capaciteKg: map['capaciteKg'],
      capaciteM3: map['capaciteM3'],
      photoUrl: map['photoUrl'],
      isActive: map['isActive'] ?? true,
      proprietaireId: map['proprietaireId'],
      zonesAutorisees: List<String>.from(map['zonesAutorisees']),
      dateAjout: DateTime.parse(map['dateAjout']),
      dernierControle: map['dernierControle'] != null 
          ? DateTime.parse(map['dernierControle'])
          : null,
      documentsValidite: map['documentsValidite'],
    );
  }

  // Vérifier si les documents sont à jour
  bool get documentsValides {
    if (documentsValidite == null) return false;
    final now = DateTime.now();
    
    bool isValid = true;
    documentsValidite!.forEach((doc, date) {
      final expiration = DateTime.parse(date);
      if (expiration.isBefore(now)) {
        isValid = false;
      }
    });
    
    return isValid;
  }

  // Vérifier si le véhicule peut opérer dans une zone donnée
  bool peutOpererDansZone(String zoneId) {
    return zonesAutorisees.contains(zoneId);
  }

  // Vérifier si le véhicule peut transporter un certain poids
  bool peutTransporterPoids(double poidsKg) {
    return poidsKg <= capaciteKg;
  }

  // Vérifier si le véhicule peut transporter un certain volume
  bool peutTransporterVolume(double volumeM3) {
    return volumeM3 <= capaciteM3;
  }

  // Obtenir le coût par km selon le type de véhicule
  double getCoutParKm() {
    switch (type) {
      case VehicleType.moto:
        return 100;  // 100 FCFA/km
      case VehicleType.tricycle:
        return 150;  // 150 FCFA/km
      case VehicleType.voiture:
        return 200;  // 200 FCFA/km
      case VehicleType.camionnette:
        return 300;  // 300 FCFA/km
    }
  }

  // Vérifier si le véhicule nécessite un contrôle
  bool get necessiteControle {
    if (dernierControle == null) return true;
    
    final delaiControle = const Duration(days: 90); // Contrôle tous les 3 mois
    final dateProchainControle = dernierControle!.add(delaiControle);
    return DateTime.now().isAfter(dateProchainControle);
  }

  // Créer une copie avec des modifications
  DeliveryVehicle copyWith({
    String? id,
    String? matricule,
    VehicleType? type,
    double? capaciteKg,
    double? capaciteM3,
    String? photoUrl,
    bool? isActive,
    String? proprietaireId,
    List<String>? zonesAutorisees,
    DateTime? dateAjout,
    DateTime? dernierControle,
    Map<String, dynamic>? documentsValidite,
  }) {
    return DeliveryVehicle(
      id: id ?? this.id,
      matricule: matricule ?? this.matricule,
      type: type ?? this.type,
      capaciteKg: capaciteKg ?? this.capaciteKg,
      capaciteM3: capaciteM3 ?? this.capaciteM3,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      proprietaireId: proprietaireId ?? this.proprietaireId,
      zonesAutorisees: zonesAutorisees ?? this.zonesAutorisees,
      dateAjout: dateAjout ?? this.dateAjout,
      dernierControle: dernierControle ?? this.dernierControle,
      documentsValidite: documentsValidite ?? this.documentsValidite,
    );
  }
}
