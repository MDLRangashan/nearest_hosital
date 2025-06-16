import 'package:equatable/equatable.dart';
import '../../models/gym.dart';

abstract class GymState extends Equatable {
  const GymState();

  @override
  List<Object> get props => [];
}

class GymInitial extends GymState {}

class GymLoading extends GymState {}

class GymLoaded extends GymState {
  final List<Gym> gyms;
  final List<Gym> filteredGyms;
  final String filterFacility;
  final String searchQuery;
  final bool sortByDistance;

  const GymLoaded({
    required this.gyms,
    required this.filteredGyms,
    this.filterFacility = '',
    this.searchQuery = '',
    this.sortByDistance = true,
  });

  GymLoaded copyWith({
    List<Gym>? gyms,
    List<Gym>? filteredGyms,
    String? filterFacility,
    String? searchQuery,
    bool? sortByDistance,
  }) {
    return GymLoaded(
      gyms: gyms ?? this.gyms,
      filteredGyms: filteredGyms ?? this.filteredGyms,
      filterFacility: filterFacility ?? this.filterFacility,
      searchQuery: searchQuery ?? this.searchQuery,
      sortByDistance: sortByDistance ?? this.sortByDistance,
    );
  }

  @override
  List<Object> get props => [
    gyms,
    filteredGyms,
    filterFacility,
    searchQuery,
    sortByDistance,
  ];
}

class GymError extends GymState {
  final String message;

  const GymError(this.message);

  @override
  List<Object> get props => [message];
}
