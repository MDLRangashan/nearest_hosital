class AppConstants {
  // App info
  static const String appName = 'Nearby Hospitals';

  // Map
  static const double defaultZoom = 14.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 10.0;

  // UI
  static const double defaultPadding = 16.0;
  static const double cardRadius = 16.0;
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
}
