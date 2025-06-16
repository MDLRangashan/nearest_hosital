import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gym.dart';
import 'location_service.dart';
import 'package:geolocator/geolocator.dart';
import '../config/api_config.dart';

class GymService {
  final LocationService _locationService = LocationService();
  final String apiKey = ApiConfig.googlePlacesApiKey;

  Future<List<Gym>> getNearbyGyms() async {
    try {
      Position currentPosition = await _locationService.getCurrentLocation();

      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${currentPosition.latitude},${currentPosition.longitude}'
          '&radius=5000'
          '&type=gym'
          '&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          List<Gym> gyms = [];

          for (var place in data['results']) {
            final detailsResponse = await http.get(
              Uri.parse(
                'https://maps.googleapis.com/maps/api/place/details/json'
                '?place_id=${place['place_id']}'
                '&fields=formatted_phone_number'
                '&key=$apiKey',
              ),
            );

            var phoneNumber = '(Not available)';
            if (detailsResponse.statusCode == 200) {
              final detailsData = json.decode(detailsResponse.body);
              if (detailsData['status'] == 'OK' &&
                  detailsData['result'] != null &&
                  detailsData['result']['formatted_phone_number'] != null) {
                phoneNumber = detailsData['result']['formatted_phone_number'];
              }
            }

            double distance = _locationService.calculateDistance(
              currentPosition.latitude,
              currentPosition.longitude,
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            );

            List<String> facilities = _mapTypesToFacilities(place['types']);

            gyms.add(
              Gym(
                id: place['place_id'],
                name: place['name'],
                address: place['vicinity'] ?? 'Address not available',
                phone: phoneNumber,
                latitude: place['geometry']['location']['lat'],
                longitude: place['geometry']['location']['lng'],
                rating: place['rating']?.toDouble() ?? 0.0,
                imageUrl:
                    place['photos'] != null
                        ? 'https://maps.googleapis.com/maps/api/place/photo'
                            '?maxwidth=400'
                            '&photo_reference=${place['photos'][0]['photo_reference']}'
                            '&key=$apiKey'
                        : 'https://via.placeholder.com/400x200?text=No+Image',
                facilities: facilities,
                isOpen: place['opening_hours']?['open_now'] ?? false,
                distance: distance,
              ),
            );
          }

          gyms.sort((a, b) => a.distance.compareTo(b.distance));

          return gyms;
        } else {
          throw 'API Error: ${data['status']}';
        }
      } else {
        throw 'Failed to load gyms: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Error fetching gyms: $e';
    }
  }

  List<String> _mapTypesToFacilities(List<dynamic> types) {
    Map<String, String> typeToFacility = {
      'gym': 'Fitness Center',
      'health': 'Health & Wellness',
      'spa': 'Spa Services',
      'pool': 'Swimming Pool',
      'sports_complex': 'Sports Complex',
      'stadium': 'Stadium',
    };

    List<String> facilities = [];
    for (var type in types) {
      if (typeToFacility.containsKey(type)) {
        facilities.add(typeToFacility[type]!);
      }
    }

    if (facilities.isEmpty) {
      facilities.add('Fitness Facilities');
    }

    return facilities;
  }
}
