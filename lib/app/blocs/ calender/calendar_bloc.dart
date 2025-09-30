import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../core/json_management.dart';
import '../../core/models/calender_data.dart';
import '../../core/models/financial_summary.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalenderEvent, CalendarState> {
  final CalendarController _calendarController = CalendarController();

  CalendarController get calendarController => _calendarController;

  CalendarBloc() : super(CalenderInitial()) {
    on<InitializeCalender>(_onInitializeCalendar);
    on<NavigateToPreviousMonth>(_onNavigateToPreviousMonth);
    on<NavigateToNextMonth>(_onNavigateToNextMonth);
    on<SelectDate>(_onSelectDate);
  }

  Future<void> _onInitializeCalendar(
    InitializeCalender event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      final calendarData = await _getSampleData(event.context);
      emit(CalendarLoaded(calendarData, calendarData.month));
    } catch (e) {
      emit(CalendarError('Failed to load calendar data: $e'));
    }
  }

  Future<void> _onNavigateToPreviousMonth(
    NavigateToPreviousMonth event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarLoaded) {
      _calendarController.backward!();
      final currentState = state as CalendarLoaded;
      emit(
        CalendarLoaded(
          currentState.calendarData,
          _calendarController.displayDate!,
        ),
      );
    }
  }

  Future<void> _onNavigateToNextMonth(
    NavigateToNextMonth event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarLoaded) {
      _calendarController.forward!();
      final currentState = state as CalendarLoaded;
      emit(
        CalendarLoaded(
          currentState.calendarData,
          _calendarController.displayDate!,
        ),
      );
    }
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<CalendarState> emit,
  ) async {
    // No state change needed for date selection, as it triggers a dialog
  }

  Future<CalendarData> _getSampleData(BuildContext context) async {
    final dailyFinancials = await JsonManagement().loadExpenses(context);
    final summary = FinancialSummary(
      totalRevenue: 41234000,
      totalExpenditure: -21234000,
      remaining: 20000000,
    );
    return CalendarData(
      month: DateTime(2024, 8),
      summary: summary,
      dailyFinancials: dailyFinancials,
    );
  }

  @override
  Future<void> close() {
    _calendarController.dispose();
    return super.close();
  }
}
