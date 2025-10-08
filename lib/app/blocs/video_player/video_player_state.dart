part of 'video_player_bloc.dart';

abstract class VideoPlayerState {}

class VideoPlayerInitial extends VideoPlayerState {}

class VideoPlayerLoading extends VideoPlayerState {}

class VideoPlayerReady extends VideoPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  VideoPlayerReady({
    required this.isPlaying,
    required this.position,
    required this.duration,
  });
}

class VideoPlayerError extends VideoPlayerState {
  final String message;
  VideoPlayerError(this.message);
}
