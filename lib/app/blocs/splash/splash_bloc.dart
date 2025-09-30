import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/utills/navigation_utils.dart';
import '../../router/AppRouter.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<NavigateToHomeEvent>(_handleNavigateToHome);
  }
  _handleNavigateToHome(event, emit) {
    emit(NavigateToHomeState());
  }
}
