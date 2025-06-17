import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/jogging_track.dart';
import '../constants/app_constants.dart';

class JoggingTrackDetailScreen extends StatelessWidget {
  final JoggingTrack joggingTrack;

  const JoggingTrackDetailScreen({Key? key, required this.joggingTrack})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                joggingTrack.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.directions_run, size: 50),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          joggingTrack.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              joggingTrack.isOpen ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          joggingTrack.isOpen ? 'Open' : 'Closed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          joggingTrack.address,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${joggingTrack.distance.toStringAsFixed(1)} km away',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.straighten, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${joggingTrack.length.toStringAsFixed(1)} km track',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Facilities',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        joggingTrack.facilities.map((facility) {
                          return Chip(
                            label: Text(facility),
                            backgroundColor: Colors.blue[50],
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(joggingTrack.name)}',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse('tel:${joggingTrack.phone}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
