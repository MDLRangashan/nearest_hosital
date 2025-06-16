class Gym {
  final String id;
  final String name;
  final String address;
  final double rating;
  final bool isOpen;
  final String imageUrl;
  final double distance;
  final List<String> facilities;
  final String phone;
  final double latitude;
  final double longitude;

  Gym({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.isOpen,
    required this.imageUrl,
    required this.distance,
    required this.facilities,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      isOpen: json['isOpen'] as bool,
      imageUrl: json['imageUrl'] as String,
      distance: (json['distance'] as num).toDouble(),
      facilities: List<String>.from(json['facilities'] as List),
      phone: json['phone'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'rating': rating,
      'isOpen': isOpen,
      'imageUrl': imageUrl,
      'distance': distance,
      'facilities': facilities,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
