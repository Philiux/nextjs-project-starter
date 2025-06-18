class Location {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String district; // Quartier
  final String additionalInfo; // Informations supplémentaires pour trouver le lieu

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.district,
    this.additionalInfo = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'district': district,
      'additionalInfo': additionalInfo,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      city: map['city'],
      district: map['district'],
      additionalInfo: map['additionalInfo'] ?? '',
    );
  }

  // Calculer la distance entre deux points (en kilomètres)
  double distanceTo(Location other) {
    const double earthRadius = 6371; // Rayon de la Terre en km
    final double lat1 = _toRadians(latitude);
    final double lon1 = _toRadians(longitude);
    final double lat2 = _toRadians(other.latitude);
    final double lon2 = _toRadians(other.longitude);

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = _haversin(dLat) +
        _cos(lat1) * _cos(lat2) * _haversin(dLon);
    final double c = 2 * _asin(_sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (3.141592653589793 / 180);
  }

  double _haversin(double theta) {
    final double sinHalf = _sin(theta / 2);
    return sinHalf * sinHalf;
  }

  double _sin(double x) => x.sin();
  double _cos(double x) => x.cos();
  double _asin(double x) => x.asin();
  double _sqrt(double x) => x.sqrt();

  bool isInSameCity(Location other) {
    return city.toLowerCase() == other.city.toLowerCase();
  }
}
