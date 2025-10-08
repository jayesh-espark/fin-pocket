part of 'video_player_bloc.dart';

abstract class VideoPlayerEvent {}

class InitializeVideoEvent extends VideoPlayerEvent {
  final String videoUrl;
  InitializeVideoEvent(this.videoUrl);
}

class SwapVideoEvent extends VideoPlayerEvent {
  final String videoUrl;
  SwapVideoEvent(this.videoUrl);
}

class PlayVideoEvent extends VideoPlayerEvent {}

class PauseVideoEvent extends VideoPlayerEvent {}

class TogglePlayPauseEvent extends VideoPlayerEvent {}

class DisposeVideoEvent extends VideoPlayerEvent {}

class VideoProgressUpdateEvent extends VideoPlayerEvent {}
