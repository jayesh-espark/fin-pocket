part of 'calendar_bloc.dart';

@immutable
sealed class CalendarState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CalenderInitial extends CalendarState {}

final class CalendarLoading extends CalendarState {}

final class CalendarLoaded extends CalendarState {
  final CalendarData calendarData;
  final DateTime displayDate;

  CalendarLoaded(this.calendarData, this.displayDate);

  @override
  List<Object?> get props => [calendarData, displayDate];
}

final class CalendarError extends CalendarState {
  final String message;

  CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}
