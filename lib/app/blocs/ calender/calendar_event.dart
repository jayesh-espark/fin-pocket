part of 'calendar_bloc.dart';

@immutable
sealed class CalenderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InitializeCalender extends CalenderEvent {
  BuildContext context;
  InitializeCalender(this.context);
}

final class NavigateToPreviousMonth extends CalenderEvent {}

final class NavigateToNextMonth extends CalenderEvent {}

final class SelectDate extends CalenderEvent {
  final DateTime date;
  SelectDate(this.date);
  @override
  List<Object?> get props => [date];
}
