import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/hospital.dart';
import '../../services/hospital_service.dart';
import 'hospital_event.dart';
import 'hospital_state.dart';

class HospitalBloc extends Bloc<HospitalEvent, HospitalState> {
  final HospitalService _hospitalService;

  HospitalBloc({required HospitalService hospitalService})
    : _hospitalService = hospitalService,
      super(HospitalInitial()) {
    on<FetchHospitals>(_onFetchHospitals);
    on<SortHospitalsByDistance>(_onSortByDistance);
    on<SortHospitalsByRating>(_onSortByRating);
    on<FilterHospitalsByService>(_onFilterByService);
    on<SearchHospitals>(_onSearchHospitals);
  }

  Future<void> _onFetchHospitals(
    FetchHospitals event,
    Emitter<HospitalState> emit,
  ) async {
    emit(HospitalLoading());
    try {
      final hospitals = await _hospitalService.getNearbyHospitals();
      emit(HospitalLoaded(hospitals: hospitals, filteredHospitals: hospitals));
    } catch (e) {
      emit(HospitalError(e.toString()));
    }
  }

  void _onSortByDistance(
    SortHospitalsByDistance event,
    Emitter<HospitalState> emit,
  ) {
    final currentState = state;
    if (currentState is HospitalLoaded) {
      final sortedHospitals = List<Hospital>.from(
        currentState.filteredHospitals,
      )..sort((a, b) => a.distance.compareTo(b.distance));

      emit(
        currentState.copyWith(
          filteredHospitals: sortedHospitals,
          sortByDistance: true,
        ),
      );
    }
  }

  void _onSortByRating(
    SortHospitalsByRating event,
    Emitter<HospitalState> emit,
  ) {
    final currentState = state;
    if (currentState is HospitalLoaded) {
      final sortedHospitals = List<Hospital>.from(
        currentState.filteredHospitals,
      )..sort((a, b) => b.rating.compareTo(a.rating));

      emit(
        currentState.copyWith(
          filteredHospitals: sortedHospitals,
          sortByDistance: false,
        ),
      );
    }
  }

  void _onFilterByService(
    FilterHospitalsByService event,
    Emitter<HospitalState> emit,
  ) {
    final currentState = state;
    if (currentState is HospitalLoaded) {
      final String service = event.service;

      List<Hospital> filteredList =
          service.isEmpty
              ? List<Hospital>.from(currentState.hospitals)
              : currentState.hospitals
                  .where(
                    (hospital) => hospital.services.any(
                      (s) => s.toLowerCase().contains(service.toLowerCase()),
                    ),
                  )
                  .toList();

      // Apply existing search filter if any
      if (currentState.searchQuery.isNotEmpty) {
        filteredList =
            filteredList
                .where(
                  (hospital) =>
                      hospital.name.toLowerCase().contains(
                        currentState.searchQuery.toLowerCase(),
                      ) ||
                      hospital.address.toLowerCase().contains(
                        currentState.searchQuery.toLowerCase(),
                      ),
                )
                .toList();
      }

      // Apply sorting
      if (currentState.sortByDistance) {
        filteredList.sort((a, b) => a.distance.compareTo(b.distance));
      } else {
        filteredList.sort((a, b) => b.rating.compareTo(a.rating));
      }

      emit(
        currentState.copyWith(
          filteredHospitals: filteredList,
          filterService: service,
        ),
      );
    }
  }

  void _onSearchHospitals(SearchHospitals event, Emitter<HospitalState> emit) {
    final currentState = state;
    if (currentState is HospitalLoaded) {
      final String query = event.query;

      // First apply service filter
      List<Hospital> filteredList =
          currentState.filterService.isEmpty
              ? List<Hospital>.from(currentState.hospitals)
              : currentState.hospitals
                  .where(
                    (hospital) => hospital.services.any(
                      (s) => s.toLowerCase().contains(
                        currentState.filterService.toLowerCase(),
                      ),
                    ),
                  )
                  .toList();

      // Then apply search query
      if (query.isNotEmpty) {
        filteredList =
            filteredList
                .where(
                  (hospital) =>
                      hospital.name.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      hospital.address.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }

      // Apply sorting
      if (currentState.sortByDistance) {
        filteredList.sort((a, b) => a.distance.compareTo(b.distance));
      } else {
        filteredList.sort((a, b) => b.rating.compareTo(a.rating));
      }

      emit(
        currentState.copyWith(
          filteredHospitals: filteredList,
          searchQuery: query,
        ),
      );
    }
  }
}
