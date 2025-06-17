import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/jogging_track.dart';
import '../constants/app_constants.dart';

class JoggingTrackCard extends StatelessWidget {
  final JoggingTrack joggingTrack;
  final VoidCallback onTap;

  const JoggingTrackCard({
    Key? key,
    required this.joggingTrack,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppConstants.defaultPadding / 2,
        horizontal: AppConstants.defaultPadding,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.cardRadius),
                    topRight: Radius.circular(AppConstants.cardRadius),
                  ),
                  child: Image.network(
                    joggingTrack.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.directions_run, size: 50),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: joggingTrack.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      joggingTrack.isOpen ? 'Open' : 'Closed',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    joggingTrack.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: joggingTrack.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 16,
                        ignoreGestures: true,
                        itemBuilder:
                            (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (_) {},
                      ),
                      const SizedBox(width: 8),
                      Text(
                        joggingTrack.rating.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          joggingTrack.address,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${joggingTrack.distance.toStringAsFixed(1)} km away',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.straighten,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${joggingTrack.length.toStringAsFixed(1)} km track',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        joggingTrack.facilities.map((facility) {
                          return Chip(
                            label: Text(
                              facility,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.blue[50],
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
