import '../../models/jogging_track.dart';

abstract class JoggingTrackState {}

class JoggingTrackInitial extends JoggingTrackState {}

class JoggingTrackLoading extends JoggingTrackState {}

class JoggingTrackLoaded extends JoggingTrackState {
  final List<JoggingTrack> joggingTracks;
  final String? selectedFacility;
  final String? searchQuery;
  final bool sortByRating;

  JoggingTrackLoaded({
    required this.joggingTracks,
    this.selectedFacility,
    this.searchQuery,
    this.sortByRating = false,
  });

  JoggingTrackLoaded copyWith({
    List<JoggingTrack>? joggingTracks,
    String? selectedFacility,
    String? searchQuery,
    bool? sortByRating,
  }) {
    return JoggingTrackLoaded(
      joggingTracks: joggingTracks ?? this.joggingTracks,
      selectedFacility: selectedFacility ?? this.selectedFacility,
      searchQuery: searchQuery ?? this.searchQuery,
      sortByRating: sortByRating ?? this.sortByRating,
    );
  }
}

class JoggingTrackError extends JoggingTrackState {
  final String message;

  JoggingTrackError(this.message);
}
