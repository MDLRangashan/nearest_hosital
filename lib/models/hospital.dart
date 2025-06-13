class Hospital {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final double rating;
  final String imageUrl;
  final List<String> services;
  final bool isOpen;
  final double distance;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.imageUrl,
    required this.services,
    required this.isOpen,
    required this.distance,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      rating: json['rating'].toDouble(),
      imageUrl: json['imageUrl'],
      services: List<String>.from(json['services']),
      isOpen: json['isOpen'],
      distance: json['distance'].toDouble(),
    );
  }
}
