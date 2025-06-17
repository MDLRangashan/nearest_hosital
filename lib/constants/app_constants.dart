class AppConstants {
  // App info
  static const String appName = 'Nearby Places';

  // Map
  static const double defaultZoom = 14.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 10.0;

  // UI
  static const double defaultPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;

  // Filter
  static const List<String> availableServices = [
    'Emergency',
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Surgery',
    'Obstetrics',
    'Family Medicine',
    'Mental Health',
    'Dental',
    'Oncology',
    'Rehabilitation',
    'Dermatology',
    'Orthopedics',
    'Ophthalmology',
  ];

  static const List<String> availableFacilities = [
    'Emergency',
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Surgery',
    'Obstetrics',
    'Family Medicine',
    'Mental Health',
    'Dental',
    'Oncology',
    'Rehabilitation',
    'Dermatology',
    'Orthopedics',
    'Ophthalmology',
  ];

  static const String googlePlacesApiBaseUrl =
      'https://maps.googleapis.com/maps/api/place';
  static const String googlePlacesApiKey =
      'AIzaSyAiOszXrtE3sBzxbrb7l2xRjmGqsi_6RzQ'; // Replace with your actual API key
}
