part of 'home_page_bloc.dart';

@immutable
sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

final class HomePageLoadingState extends HomePageState {}

final class OnPageChangedState extends HomePageState {
  final int pageIndex;
  OnPageChangedState({required this.pageIndex});
}
