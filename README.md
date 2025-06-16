<<<<<<< HEAD
# Nearby Hospitals Finder

A Flutter application to help users find hospitals in their vicinity.

## Features

- Find hospitals near your current location
- View hospitals on a map
- Sort hospitals by distance or rating
- Filter hospitals by service type
- Detailed hospital information including services, contact details, and more
- Call hospitals directly from the app
- Get directions to hospitals

## Setup Instructions

1. Clone the repository
2. Install dependencies:
   ```
   flutter pub get
   ```

3. Set up Google Maps API key:
   - Get a Google Maps API key from the [Google Cloud Console](https://console.cloud.google.com/)
   - Enable Maps SDK for Android and iOS
   - Add your API key to:
     - Android: `android/app/src/main/AndroidManifest.xml`
     - iOS: `ios/Runner/AppDelegate.swift`

4. Set up Google Places API for real hospital data:
   - Enable the Places API in your Google Cloud Console project
   - Copy `lib/config/api_config.template.dart` to `lib/config/api_config.dart`
   - Add your Google Places API key to the `api_config.dart` file
   - Make sure your API key has the Places API enabled

5. Run the app:
   ```
   flutter run
   ```

## Project Structure

- **lib/models/**: Data models
- **lib/blocs/**: BLoC state management
- **lib/screens/**: App screens
- **lib/services/**: Services for API calls and location
- **lib/widgets/**: Reusable UI components
- **lib/constants/**: App constants
- **lib/themes/**: App theming
- **lib/config/**: Configuration files including API keys

## Technical Implementation

- Uses BLoC pattern for state management
- Google Maps integration
- Google Places API for real hospital data
- Geolocator for user location
- Service-based architecture
- Component-based UI design

## Requirements

- Flutter 3.0.0 or higher
- Dart 3.0.0 or higher
- Android SDK 21+ or iOS 11+

## Note about API Keys

The app uses Google Places API to fetch real hospital data. You must obtain your own API key and set up billing in Google Cloud Console. The free tier of the Places API allows 200 API calls per day, which should be sufficient for testing purposes.
=======
# nearest_hosital
>>>>>>> 8a3ff7d9d4af6d78dff10083a2cad432557117dc
