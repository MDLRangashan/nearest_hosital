import 'package:equatable/equatable.dart';

abstract class GymEvent extends Equatable {
  const GymEvent();

  @override
  List<Object> get props => [];
}

class FetchGyms extends GymEvent {}

class SortGymsByDistance extends GymEvent {}

class SortGymsByRating extends GymEvent {}

class FilterGymsByFacility extends GymEvent {
  final String facility;

  const FilterGymsByFacility(this.facility);

  @override
  List<Object> get props => [facility];
}

class SearchGyms extends GymEvent {
  final String query;

  const SearchGyms(this.query);

  @override
  List<Object> get props => [query];
}
