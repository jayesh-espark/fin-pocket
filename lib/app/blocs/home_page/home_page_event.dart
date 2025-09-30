part of 'home_page_bloc.dart';

@immutable
sealed class HomePageEvent {}

final class OnPageChanged extends HomePageEvent {
  final int pageIndex;
  OnPageChanged({required this.pageIndex});
}
