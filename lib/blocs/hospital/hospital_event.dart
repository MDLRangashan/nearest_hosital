import 'package:equatable/equatable.dart';

abstract class HospitalEvent extends Equatable {
  const HospitalEvent();

  @override
  List<Object> get props => [];
}

class FetchHospitals extends HospitalEvent {}

class SortHospitalsByDistance extends HospitalEvent {}

class SortHospitalsByRating extends HospitalEvent {}

class FilterHospitalsByService extends HospitalEvent {
  final String service;

  const FilterHospitalsByService(this.service);

  @override
  List<Object> get props => [service];
}

class SearchHospitals extends HospitalEvent {
  final String query;

  const SearchHospitals(this.query);

  @override
  List<Object> get props => [query];
}
