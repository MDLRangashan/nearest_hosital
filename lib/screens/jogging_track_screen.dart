import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../blocs/jogging_track/jogging_track_bloc_exports.dart';
import '../constants/app_constants.dart';
import '../widgets/jogging_track_card.dart';
import 'jogging_track_detail_screen.dart';
import 'map_screen.dart';

class JoggingTrackScreen extends StatefulWidget {
  const JoggingTrackScreen({Key? key}) : super(key: key);

  @override
  State<JoggingTrackScreen> createState() => _JoggingTrackScreenState();
}

class _JoggingTrackScreenState extends State<JoggingTrackScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFacility;
  bool _sortByRating = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        context.read<JoggingTrackBloc>().add(
          FetchJoggingTracks(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error getting location. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogging Tracks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jogging tracks...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<JoggingTrackBloc>().add(
                      SearchJoggingTracks(value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFacility,
                        decoration: InputDecoration(
                          hintText: 'Filter by facility',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items:
                            ['Jogging Track', 'Park', 'Point of Interest'].map((
                              facility,
                            ) {
                              return DropdownMenuItem(
                                value: facility,
                                child: Text(facility),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFacility = value;
                          });
                          if (value != null) {
                            context.read<JoggingTrackBloc>().add(
                              FilterJoggingTracksByFacility(value),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        _sortByRating ? Icons.star : Icons.sort,
                        color: _sortByRating ? Colors.amber : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _sortByRating = !_sortByRating;
                        });
                        if (_sortByRating) {
                          context.read<JoggingTrackBloc>().add(
                            SortJoggingTracksByRating(),
                          );
                        } else {
                          context.read<JoggingTrackBloc>().add(
                            SortJoggingTracksByDistance(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<JoggingTrackBloc, JoggingTrackState>(
              builder: (context, state) {
                if (state is JoggingTrackLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is JoggingTrackError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is JoggingTrackLoaded) {
                  if (state.joggingTracks.isEmpty) {
                    return const Center(child: Text('No jogging tracks found'));
                  }
                  return ListView.builder(
                    itemCount: state.joggingTracks.length,
                    itemBuilder: (context, index) {
                      final joggingTrack = state.joggingTracks[index];
                      return JoggingTrackCard(
                        joggingTrack: joggingTrack,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => JoggingTrackDetailScreen(
                                    joggingTrack: joggingTrack,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
