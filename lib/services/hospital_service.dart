import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hospital.dart';
import 'location_service.dart';
import 'package:geolocator/geolocator.dart';
import '../config/api_config.dart';

class HospitalService {
  final LocationService _locationService = LocationService();

  final String apiKey = ApiConfig.googlePlacesApiKey;

  Future<List<Hospital>> getNearbyHospitals() async {
    try {
      Position currentPosition = await _locationService.getCurrentLocation();

      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${currentPosition.latitude},${currentPosition.longitude}'
          '&radius=5000'
          '&type=hospital'
          '&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          List<Hospital> hospitals = [];

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

            List<String> services = _mapTypesToServices(place['types']);

            hospitals.add(
              Hospital(
                id: place['place_id'],
                name: place['name'],
                address: place['vicinity'] ?? 'Address not available',
                phoneNumber: phoneNumber,
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
                services: services,
                isOpen: place['opening_hours']?['open_now'] ?? false,
                distance: distance,
              ),
            );
          }

          hospitals.sort((a, b) => a.distance.compareTo(b.distance));

          return hospitals;
        } else {
          throw 'API Error: ${data['status']}';
        }
      } else {
        throw 'Failed to load hospitals: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Error fetching hospitals: $e';
    }
  }

  List<String> _mapTypesToServices(List<dynamic> types) {
    Map<String, String> typeToService = {
      'hospital': 'General Healthcare',
      'doctor': 'Doctor Services',
      'health': 'Healthcare',
      'pharmacy': 'Pharmacy',
      'physiotherapist': 'Physiotherapy',
      'dentist': 'Dental Services',
    };

    List<String> services = [];
    for (var type in types) {
      if (typeToService.containsKey(type)) {
        services.add(typeToService[type]!);
      }
    }

    if (services.isEmpty) {
      services.add('Medical Services');
    }

    return services;
  }
}
