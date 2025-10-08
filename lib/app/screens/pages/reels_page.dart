import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/reels/reels_bloc.dart';
import '../../blocs/video_player/video_player_bloc.dart';
import 'reel_item.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<ReelsBloc>().add(LoadReels());

    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != context.read<ReelsBloc>().currentReel) {
        context.read<ReelsBloc>().add(ReelSwapEvent(index: newPage));
      }
      if (newPage >= context.read<ReelsBloc>().playingReels.length - 2) {
        context.read<ReelsBloc>().add(LoadMoreReels());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    context.read<VideoPlayerBloc>().add(DisposeVideoEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<ReelsBloc, ReelsState>(
          listener: (context, state) {
            if (state is ReelsLoaded) {
              final index = context.read<ReelsBloc>().currentReel;
              final reel = state.reels[index];
              context.read<VideoPlayerBloc>().add(
                InitializeVideoEvent(reel.videoUrl ?? ""),
              );
            }
          },
          child: BlocBuilder<ReelsBloc, ReelsState>(
            builder: (context, state) {
              if (state is ReelsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReelsErrorState) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is ReelsLoaded) {
                return PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: state.reels.length,
                  itemBuilder: (context, index) {
                    final reel = state.reels[index];
                    log("Reel ${index + 1}: ${reel.caption}");

                    // Trigger lazy loading
                    if (index >=
                        context.read<ReelsBloc>().playingReels.length - 2) {
                      context.read<ReelsBloc>().add(LoadMoreReels());
                    }

                    return ReelVideoItem(
                      reel: reel,
                      isActive: index == context.read<ReelsBloc>().currentReel,
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
