import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/hospital/hospital_bloc_exports.dart';
import '../constants/app_constants.dart';
import '../widgets/hospital_card.dart';
import 'hospital_detail_screen.dart';
import 'map_screen.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({Key? key}) : super(key: key);

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  String _searchQuery = '';
  String _selectedFilter = '';
  bool _isSortingByDistance = true;

  @override
  void initState() {
    super.initState();
    // Fetch hospitals when the screen is opened
    context.read<HospitalBloc>().add(FetchHospitals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Hospitals"),
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
                hintText: 'Search for hospitals...',
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
                context.read<HospitalBloc>().add(SearchHospitals(value));
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
                      labelText: 'Filter by Service',
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
                        child: Text('All Services'),
                      ),
                      ...AppConstants.availableServices.map(
                        (service) => DropdownMenuItem(
                          value: service,
                          child: Text(service),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value ?? '';
                      });
                      context.read<HospitalBloc>().add(
                        FilterHospitalsByService(value ?? ''),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                BlocBuilder<HospitalBloc, HospitalState>(
                  buildWhen: (previous, current) {
                    if (previous is HospitalLoaded &&
                        current is HospitalLoaded) {
                      return previous.sortByDistance != current.sortByDistance;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    bool isSortByDistance = true;
                    if (state is HospitalLoaded) {
                      isSortByDistance = state.sortByDistance;
                    }

                    return ElevatedButton.icon(
                      icon: Icon(isSortByDistance ? Icons.place : Icons.star),
                      label: Text(isSortByDistance ? 'Distance' : 'Rating'),
                      onPressed: () {
                        if (isSortByDistance) {
                          context.read<HospitalBloc>().add(
                            SortHospitalsByRating(),
                          );
                        } else {
                          context.read<HospitalBloc>().add(
                            SortHospitalsByDistance(),
                          );
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
            child: BlocBuilder<HospitalBloc, HospitalState>(
              builder: (context, state) {
                if (state is HospitalLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HospitalError) {
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
                            context.read<HospitalBloc>().add(FetchHospitals());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is HospitalLoaded) {
                  final hospitals = state.filteredHospitals;

                  if (hospitals.isEmpty) {
                    return const Center(child: Text('No hospitals found'));
                  }

                  return ListView.builder(
                    itemCount: hospitals.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final hospital = hospitals[index];
                      return HospitalCard(
                        hospital: hospital,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      HospitalDetailScreen(hospital: hospital),
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
