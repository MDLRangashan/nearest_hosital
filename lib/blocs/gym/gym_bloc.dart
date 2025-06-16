import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/gym.dart';
import '../../services/gym_service.dart';
import 'gym_event.dart';
import 'gym_state.dart';

class GymBloc extends Bloc<GymEvent, GymState> {
  final GymService _gymService;

  GymBloc({required GymService gymService})
    : _gymService = gymService,
      super(GymInitial()) {
    on<FetchGyms>(_onFetchGyms);
    on<SortGymsByDistance>(_onSortByDistance);
    on<SortGymsByRating>(_onSortByRating);
    on<FilterGymsByFacility>(_onFilterByFacility);
    on<SearchGyms>(_onSearchGyms);
  }

  Future<void> _onFetchGyms(FetchGyms event, Emitter<GymState> emit) async {
    emit(GymLoading());
    try {
      final gyms = await _gymService.getNearbyGyms();
      emit(GymLoaded(gyms: gyms, filteredGyms: gyms));
    } catch (e) {
      emit(GymError(e.toString()));
    }
  }

  void _onSortByDistance(SortGymsByDistance event, Emitter<GymState> emit) {
    final currentState = state;
    if (currentState is GymLoaded) {
      final sortedGyms = List<Gym>.from(currentState.filteredGyms)
        ..sort((a, b) => a.distance.compareTo(b.distance));

      emit(
        currentState.copyWith(filteredGyms: sortedGyms, sortByDistance: true),
      );
    }
  }

  void _onSortByRating(SortGymsByRating event, Emitter<GymState> emit) {
    final currentState = state;
    if (currentState is GymLoaded) {
      final sortedGyms = List<Gym>.from(currentState.filteredGyms)
        ..sort((a, b) => b.rating.compareTo(a.rating));

      emit(
        currentState.copyWith(filteredGyms: sortedGyms, sortByDistance: false),
      );
    }
  }

  void _onFilterByFacility(FilterGymsByFacility event, Emitter<GymState> emit) {
    final currentState = state;
    if (currentState is GymLoaded) {
      final String facility = event.facility;

      List<Gym> filteredList =
          facility.isEmpty
              ? List<Gym>.from(currentState.gyms)
              : currentState.gyms
                  .where(
                    (gym) => gym.facilities.any(
                      (f) => f.toLowerCase().contains(facility.toLowerCase()),
                    ),
                  )
                  .toList();

      if (currentState.searchQuery.isNotEmpty) {
        filteredList =
            filteredList
                .where(
                  (gym) =>
                      gym.name.toLowerCase().contains(
                        currentState.searchQuery.toLowerCase(),
                      ) ||
                      gym.address.toLowerCase().contains(
                        currentState.searchQuery.toLowerCase(),
                      ),
                )
                .toList();
      }

      if (currentState.sortByDistance) {
        filteredList.sort((a, b) => a.distance.compareTo(b.distance));
      } else {
        filteredList.sort((a, b) => b.rating.compareTo(a.rating));
      }

      emit(
        currentState.copyWith(
          filteredGyms: filteredList,
          filterFacility: facility,
        ),
      );
    }
  }

  void _onSearchGyms(SearchGyms event, Emitter<GymState> emit) {
    final currentState = state;
    if (currentState is GymLoaded) {
      final String query = event.query;

      List<Gym> filteredList =
          currentState.filterFacility.isEmpty
              ? List<Gym>.from(currentState.gyms)
              : currentState.gyms
                  .where(
                    (gym) => gym.facilities.any(
                      (f) => f.toLowerCase().contains(
                        currentState.filterFacility.toLowerCase(),
                      ),
                    ),
                  )
                  .toList();

      if (query.isNotEmpty) {
        filteredList =
            filteredList
                .where(
                  (gym) =>
                      gym.name.toLowerCase().contains(query.toLowerCase()) ||
                      gym.address.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }

      if (currentState.sortByDistance) {
        filteredList.sort((a, b) => a.distance.compareTo(b.distance));
      } else {
        filteredList.sort((a, b) => b.rating.compareTo(a.rating));
      }

      emit(
        currentState.copyWith(filteredGyms: filteredList, searchQuery: query),
      );
    }
  }
}
