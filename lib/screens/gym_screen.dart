import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/gym/gym_bloc_exports.dart';
import '../constants/app_constants.dart';
import '../widgets/gym_card.dart';
import 'gym_detail_screen.dart';
import 'map_screen.dart';

class GymScreen extends StatefulWidget {
  const GymScreen({Key? key}) : super(key: key);

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen> {
  String _searchQuery = '';
  String _selectedFilter = '';
  bool _isSortingByDistance = true;

  @override
  void initState() {
    super.initState();
    context.read<GymBloc>().add(FetchGyms());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Gyms'),
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
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for gyms...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.buttonRadius,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                context.read<GymBloc>().add(SearchGyms(value));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Filter by Facility',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.buttonRadius,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    value: _selectedFilter.isEmpty ? null : _selectedFilter,
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('All Facilities'),
                      ),
                      ...AppConstants.availableFacilities.map(
                        (facility) => DropdownMenuItem(
                          value: facility,
                          child: Text(facility),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value ?? '';
                      });
                      context.read<GymBloc>().add(
                        FilterGymsByFacility(value ?? ''),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                BlocBuilder<GymBloc, GymState>(
                  buildWhen: (previous, current) {
                    if (previous is GymLoaded && current is GymLoaded) {
                      return previous.sortByDistance != current.sortByDistance;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    bool isSortByDistance = true;
                    if (state is GymLoaded) {
                      isSortByDistance = state.sortByDistance;
                    }

                    return ElevatedButton.icon(
                      icon: Icon(isSortByDistance ? Icons.place : Icons.star),
                      label: Text(isSortByDistance ? 'Distance' : 'Rating'),
                      onPressed: () {
                        if (isSortByDistance) {
                          context.read<GymBloc>().add(SortGymsByRating());
                        } else {
                          context.read<GymBloc>().add(SortGymsByDistance());
                        }
                        setState(() {
                          _isSortingByDistance = !_isSortingByDistance;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<GymBloc, GymState>(
              builder: (context, state) {
                if (state is GymLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GymError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<GymBloc>().add(FetchGyms());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is GymLoaded) {
                  final gyms = state.filteredGyms;

                  if (gyms.isEmpty) {
                    return const Center(child: Text('No gyms found'));
                  }

                  return ListView.builder(
                    itemCount: gyms.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final gym = gyms[index];
                      return GymCard(
                        gym: gym,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GymDetailScreen(gym: gym),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Something went wrong. Please try again.'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
