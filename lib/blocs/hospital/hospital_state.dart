import 'package:equatable/equatable.dart';
import '../../models/hospital.dart';

abstract class HospitalState extends Equatable {
  const HospitalState();

  @override
  List<Object> get props => [];
}

class HospitalInitial extends HospitalState {}

class HospitalLoading extends HospitalState {}

class HospitalLoaded extends HospitalState {
  final List<Hospital> hospitals;
  final List<Hospital> filteredHospitals;
  final String filterService;
  final String searchQuery;
  final bool sortByDistance;

  const HospitalLoaded({
    required this.hospitals,
    required this.filteredHospitals,
    this.filterService = '',
    this.searchQuery = '',
    this.sortByDistance = true,
  });

  HospitalLoaded copyWith({
    List<Hospital>? hospitals,
    List<Hospital>? filteredHospitals,
    String? filterService,
    String? searchQuery,
    bool? sortByDistance,
  }) {
    return HospitalLoaded(
      hospitals: hospitals ?? this.hospitals,
      filteredHospitals: filteredHospitals ?? this.filteredHospitals,
      filterService: filterService ?? this.filterService,
      searchQuery: searchQuery ?? this.searchQuery,
      sortByDistance: sortByDistance ?? this.sortByDistance,
    );
  }

  @override
  List<Object> get props => [
    hospitals,
    filteredHospitals,
    filterService,
    searchQuery,
    sortByDistance,
  ];
}

class HospitalError extends HospitalState {
  final String message;

  const HospitalError(this.message);

  @override
  List<Object> get props => [message];
}
