part of 'reels_bloc.dart';

abstract class ReelsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReelsInitialState extends ReelsState {}

class ReelsLoadingState extends ReelsState {}

class ReelSwappedState extends ReelsState {
  final int index;
  ReelSwappedState({required this.index});

  @override
  List<Object?> get props => [index];
}

class ReelsLoaded extends ReelsState {
  final List<ReelsModel> reels;
  final bool hasReachedMax;
  ReelsLoaded({required this.reels, required this.hasReachedMax});
}

class ReelsTogglePlayPauseState extends ReelsState {
  final bool isPlaying;
  ReelsTogglePlayPauseState({required this.isPlaying});

  @override
  List<Object?> get props => [isPlaying];
}

class ReelsErrorState extends ReelsState {
  final String message;

  ReelsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
