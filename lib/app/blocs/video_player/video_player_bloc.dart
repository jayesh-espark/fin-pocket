import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerController? controller;
  StreamSubscription? _progressSubscription;

  VideoPlayerBloc() : super(VideoPlayerInitial()) {
    on<InitializeVideoEvent>(_onInitializeVideo);
    on<SwapVideoEvent>(_onSwapVideo);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<PauseVideoEvent>(_onPauseVideo);
    on<DisposeVideoEvent>(_onDisposeVideo);
    on<VideoProgressUpdateEvent>(_onVideoProgressUpdate);
  }

  Future<void> _onInitializeVideo(
    InitializeVideoEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    try {
      emit(VideoPlayerLoading());
      await controller?.dispose();

      controller = VideoPlayerController.networkUrl(Uri.parse(event.videoUrl));
      log("event.videoUrl => ${event.videoUrl}");
      await controller!.initialize();
      emit(
        VideoPlayerReady(
          isPlaying: true,
          position: Duration.zero,
          duration: controller!.value.duration,
        ),
      );
      controller!.play();

      // Listen for position updates
      _progressSubscription?.cancel();
      _progressSubscription = Stream.periodic(const Duration(milliseconds: 300))
          .listen((_) {
            if (!isClosed &&
                controller != null &&
                controller!.value.isInitialized) {
              add(VideoProgressUpdateEvent());
            }
          });
    } catch (e) {
      emit(VideoPlayerError('Failed to load video: ${e.toString()}'));
    }
  }

  Future<void> _onSwapVideo(
    SwapVideoEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    add(InitializeVideoEvent(event.videoUrl));
  }

  void _onTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<VideoPlayerState> emit,
  ) {
    if (controller == null || state is! VideoPlayerReady) return;
    final currentState = state as VideoPlayerReady;

    if (currentState.isPlaying) {
      controller!.pause();
    } else {
      controller!.play();
    }

    emit(
      VideoPlayerReady(
        isPlaying: !currentState.isPlaying,
        position: controller!.value.position,
        duration: controller!.value.duration,
      ),
    );
  }

  void _onPauseVideo(PauseVideoEvent event, Emitter<VideoPlayerState> emit) {
    if (controller == null || state is! VideoPlayerReady) return;
    controller!.pause();
    emit(
      VideoPlayerReady(
        isPlaying: false,
        position: controller!.value.position,
        duration: controller!.value.duration,
      ),
    );
  }

  void _onVideoProgressUpdate(
    VideoProgressUpdateEvent event,
    Emitter<VideoPlayerState> emit,
  ) {
    if (controller == null || state is! VideoPlayerReady) return;
    emit(
      VideoPlayerReady(
        isPlaying: controller!.value.isPlaying,
        position: controller!.value.position,
        duration: controller!.value.duration,
      ),
    );
  }

  Future<void> _onDisposeVideo(
    DisposeVideoEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await controller?.pause();
    await controller?.dispose();
    controller = null;
    _progressSubscription?.cancel();
    emit(VideoPlayerInitial());
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    controller?.dispose();
    return super.close();
  }
}
