abstract class JoggingTrackEvent {}

class FetchJoggingTracks extends JoggingTrackEvent {
  final double latitude;
  final double longitude;

  FetchJoggingTracks({required this.latitude, required this.longitude});
}

class SortJoggingTracksByDistance extends JoggingTrackEvent {}

class SortJoggingTracksByRating extends JoggingTrackEvent {}

class FilterJoggingTracksByFacility extends JoggingTrackEvent {
  final String facility;

  FilterJoggingTracksByFacility(this.facility);
}

class SearchJoggingTracks extends JoggingTrackEvent {
  final String query;

  SearchJoggingTracks(this.query);
}
