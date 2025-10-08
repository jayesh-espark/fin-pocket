part of 'reels_bloc.dart';

abstract class ReelsEvent extends Equatable {
  const ReelsEvent();
  @override
  List<Object> get props => [];
}

class LoadReels extends ReelsEvent {}

class ReelSwapEvent extends ReelsEvent {
  final int index;
  const ReelSwapEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class LoadMoreReels extends ReelsEvent {}
