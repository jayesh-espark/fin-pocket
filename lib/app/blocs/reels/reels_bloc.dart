import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/reels_model.dart';
import '../../reposetries/reels_reposetry.dart';

part 'reels_event.dart';
part 'reels_state.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final ReelRepository repository = ReelRepository();
  int page = 1;
  List<ReelsModel> playingReels = [];
  int currentReel = 0;
  ReelsBloc() : super(ReelsInitialState()) {
    on<LoadReels>(_onLoadReels);
    on<LoadMoreReels>(_onLoadMoreReels);
    on<ReelSwapEvent>(_onReelSwapState);
  }

  Future<void> _onLoadReels(LoadReels event, Emitter<ReelsState> emit) async {
    emit(ReelsLoadingState());
    try {
      final reels = await repository.getReels(page: page);
      emit(ReelsLoaded(reels: reels, hasReachedMax: reels.isEmpty));
      playingReels = reels;
    } catch (e) {
      emit(ReelsErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreReels(
    LoadMoreReels event,
    Emitter<ReelsState> emit,
  ) async {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;
      if (currentState.hasReachedMax) return;
      page++;
      try {
        final newReels = await repository.getReels(page: page);
        final updatedReels = [...playingReels, ...newReels];
        playingReels = updatedReels;
        emit(ReelsLoaded(reels: updatedReels, hasReachedMax: newReels.isEmpty));
      } catch (e) {
        emit(ReelsErrorState(message: e.toString()));
      }
    }
  }

  FutureOr<void> _onReelSwapState(
    ReelSwapEvent event,
    Emitter<ReelsState> emit,
  ) {
    currentReel = event.index;
    emit(ReelSwappedState(index: event.index));
    emit(ReelsLoaded(reels: playingReels, hasReachedMax: false));
  }
}
