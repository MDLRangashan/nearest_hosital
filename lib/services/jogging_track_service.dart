import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/jogging_track.dart';
import '../constants/app_constants.dart';

class JoggingTrackService {
  Future<List<JoggingTrack>> getNearbyJoggingTracks(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.googlePlacesApiBaseUrl}/nearbysearch/json?'
          'location=$latitude,$longitude'
          '&radius=5000'
          '&type=park'
          '&keyword=jogging track'
          '&key=${AppConstants.googlePlacesApiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        final joggingTracks = await Future.wait(
          results.map((place) async {
            // Get place details for additional information
            final detailsResponse = await http.get(
              Uri.parse(
                '${AppConstants.googlePlacesApiBaseUrl}/details/json?'
                'place_id=${place['place_id']}'
                '&fields=name,formatted_address,rating,opening_hours,formatted_phone_number,photos'
                '&key=${AppConstants.googlePlacesApiKey}',
              ),
            );

            final details = json.decode(detailsResponse.body)['result'];

            // Get the first photo reference if available
            String imageUrl = '';
            if (place['photos'] != null && place['photos'].isNotEmpty) {
              final photoReference = place['photos'][0]['photo_reference'];
              imageUrl =
                  '${AppConstants.googlePlacesApiBaseUrl}/photo?maxwidth=400&photoreference=$photoReference&key=${AppConstants.googlePlacesApiKey}';
            }

            // Calculate distance
            final distance = _calculateDistance(
              latitude,
              longitude,
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            );

            // Get phone number
            String phoneNumber = '';
            if (details['formatted_phone_number'] != null) {
              phoneNumber = details['formatted_phone_number'];
            }

            // Get opening hours
            bool isOpen = false;
            if (details['opening_hours'] != null) {
              isOpen = details['opening_hours']['open_now'] ?? false;
            }

            // Estimate track length (this is a placeholder - you might want to get this from a different API or database)
            final length = 2.0; // Default length in kilometers

            return JoggingTrack(
              id: place['place_id'],
              name: place['name'],
              address: place['vicinity'] ?? 'Address not available',
              phone: phoneNumber,
              latitude: place['geometry']['location']['lat'],
              longitude: place['geometry']['location']['lng'],
              rating: (place['rating'] ?? 0.0).toDouble(),
              isOpen: isOpen,
              imageUrl: imageUrl,
              distance: distance,
              facilities: _getFacilities(place),
              length: length,
            );
          }),
        );

        return joggingTracks;
      } else {
        throw Exception('Failed to load jogging tracks');
      }
    } catch (e) {
      throw Exception('Error fetching jogging tracks: $e');
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  List<String> _getFacilities(Map<String, dynamic> place) {
    final facilities = <String>[];

    // Add basic facilities that are common in jogging tracks
    facilities.add('Jogging Track');

    // Add additional facilities based on place details
    if (place['types'] != null) {
      if (place['types'].contains('park')) {
        facilities.add('Park');
      }
      if (place['types'].contains('point_of_interest')) {
        facilities.add('Point of Interest');
      }
    }

    return facilities;
  }
}
