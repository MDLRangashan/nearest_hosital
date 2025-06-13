import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/hospital/hospital_bloc_exports.dart';
import '../constants/app_constants.dart';
import '../models/hospital.dart';
import 'hospital_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HospitalBloc, HospitalState>(
      builder: (context, state) {
        if (state is HospitalLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HospitalError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Nearby Hospitals Map')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
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
            ),
          );
        } else if (state is HospitalLoaded) {
          final hospitals = state.hospitals;

          if (hospitals.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('No hospitals found')),
            );
          }

          final markers =
              hospitals
                  .map(
                    (hospital) => Marker(
                      markerId: MarkerId(hospital.id),
                      position: LatLng(hospital.latitude, hospital.longitude),
                      infoWindow: InfoWindow(
                        title: hospital.name,
                        snippet:
                            '${hospital.distance.toStringAsFixed(1)} km • ${hospital.rating}★',
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
                      ),
                    ),
                  )
                  .toSet();

          final avgLat =
              hospitals.map((h) => h.latitude).reduce((a, b) => a + b) /
              hospitals.length;
          final avgLng =
              hospitals.map((h) => h.longitude).reduce((a, b) => a + b) /
              hospitals.length;

          return Scaffold(
            appBar: AppBar(title: const Text('Nearby Hospitals Map')),
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(avgLat, avgLng),
                zoom: AppConstants.defaultZoom,
              ),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () {
                if (_mapController != null && hospitals.isNotEmpty) {
                  final userLocation = LatLng(
                    hospitals[0].latitude - hospitals[0].distance / 111,
                    hospitals[0].longitude,
                  );

                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      userLocation,
                      AppConstants.defaultZoom,
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }
      },
    );
  }
}
