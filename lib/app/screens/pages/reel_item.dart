import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../blocs/video_player/video_player_bloc.dart';
import '../../model/reels_model.dart';

class ReelVideoItem extends StatelessWidget {
  final ReelsModel reel;
  final bool isActive;

  const ReelVideoItem({super.key, required this.reel, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
      builder: (context, state) {
        final bloc = context.read<VideoPlayerBloc>();

        if (state is VideoPlayerLoading || bloc.controller == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is VideoPlayerError) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }

        if (state is VideoPlayerReady && bloc.controller!.value.isInitialized) {
          return GestureDetector(
            onTap: () => bloc.add(TogglePlayPauseEvent()),
            child: Stack(
              children: [
                // Video
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      height: bloc.controller!.value.size.height,
                      width: bloc.controller!.value.size.width,
                      child: VideoPlayer(bloc.controller!),
                    ),
                  ),
                ),

                // Play overlay
                if (!state.isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),

                // Progress bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    bloc.controller!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.redAccent,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.black26,
                    ),
                  ),
                ),

                // Caption & User Info
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 80,
                  child: Text(
                    '@${reel.userName ?? "user"}\n${reel.caption ?? ""}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                // Right-side icons
                Positioned(
                  right: 16,
                  bottom: 80,
                  child: Column(
                    children: const [
                      Icon(Icons.favorite, color: Colors.white, size: 36),
                      SizedBox(height: 16),
                      Icon(Icons.comment, color: Colors.white, size: 36),
                      SizedBox(height: 16),
                      Icon(Icons.share, color: Colors.white, size: 36),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
