import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/jogging_track.dart';
import '../../services/jogging_track_service.dart';
import 'jogging_track_event.dart';
import 'jogging_track_state.dart';

class JoggingTrackBloc extends Bloc<JoggingTrackEvent, JoggingTrackState> {
  final JoggingTrackService joggingTrackService;

  JoggingTrackBloc({required this.joggingTrackService})
    : super(JoggingTrackInitial()) {
    on<FetchJoggingTracks>(_onFetchJoggingTracks);
    on<SortJoggingTracksByDistance>(_onSortJoggingTracksByDistance);
    on<SortJoggingTracksByRating>(_onSortJoggingTracksByRating);
    on<FilterJoggingTracksByFacility>(_onFilterJoggingTracksByFacility);
    on<SearchJoggingTracks>(_onSearchJoggingTracks);
  }

  Future<void> _onFetchJoggingTracks(
    FetchJoggingTracks event,
    Emitter<JoggingTrackState> emit,
  ) async {
    emit(JoggingTrackLoading());
    try {
      final joggingTracks = await joggingTrackService.getNearbyJoggingTracks(
        event.latitude,
        event.longitude,
      );
      emit(JoggingTrackLoaded(joggingTracks: joggingTracks));
    } catch (e) {
      emit(JoggingTrackError(e.toString()));
    }
  }

  void _onSortJoggingTracksByDistance(
    SortJoggingTracksByDistance event,
    Emitter<JoggingTrackState> emit,
  ) {
    if (state is JoggingTrackLoaded) {
      final currentState = state as JoggingTrackLoaded;
      final sortedTracks = List<JoggingTrack>.from(currentState.joggingTracks)
        ..sort((a, b) => a.distance.compareTo(b.distance));
      emit(
        currentState.copyWith(joggingTracks: sortedTracks, sortByRating: false),
      );
    }
  }

  void _onSortJoggingTracksByRating(
    SortJoggingTracksByRating event,
    Emitter<JoggingTrackState> emit,
  ) {
    if (state is JoggingTrackLoaded) {
      final currentState = state as JoggingTrackLoaded;
      final sortedTracks = List<JoggingTrack>.from(currentState.joggingTracks)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      emit(
        currentState.copyWith(joggingTracks: sortedTracks, sortByRating: true),
      );
    }
  }

  void _onFilterJoggingTracksByFacility(
    FilterJoggingTracksByFacility event,
    Emitter<JoggingTrackState> emit,
  ) {
    if (state is JoggingTrackLoaded) {
      final currentState = state as JoggingTrackLoaded;
      final filteredTracks =
          currentState.joggingTracks
              .where((track) => track.facilities.contains(event.facility))
              .toList();
      emit(
        currentState.copyWith(
          joggingTracks: filteredTracks,
          selectedFacility: event.facility,
        ),
      );
    }
  }

  void _onSearchJoggingTracks(
    SearchJoggingTracks event,
    Emitter<JoggingTrackState> emit,
  ) {
    if (state is JoggingTrackLoaded) {
      final currentState = state as JoggingTrackLoaded;
      final searchQuery = event.query.toLowerCase();
      final filteredTracks =
          currentState.joggingTracks
              .where(
                (track) =>
                    track.name.toLowerCase().contains(searchQuery) ||
                    track.address.toLowerCase().contains(searchQuery),
              )
              .toList();
      emit(
        currentState.copyWith(
          joggingTracks: filteredTracks,
          searchQuery: event.query,
        ),
      );
    }
  }
}
