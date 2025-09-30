import 'package:fiin_pocket/app/core/widgets/common_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../blocs/ calender/calendar_bloc.dart';
import '../../core/models/calender_data.dart';
import '../../core/models/daily_financial.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(InitializeCalender(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CalendarLoading) {
          return CommonLoaderScreen();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    context.read<CalendarBloc>().add(NavigateToPreviousMonth());
                  },
                );
              },
            ),
            title: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                DateTime displayDate = DateTime.now();
                if (state is CalendarLoaded) {
                  displayDate = state.displayDate;
                }
                return Text(
                  DateFormat('MMMM yyyy').format(displayDate),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                );
              },
            ),
            centerTitle: true,
            actions: [
              BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      context.read<CalendarBloc>().add(NavigateToNextMonth());
                    },
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              if (state is CalendarLoading) {
                return const Center(child: CommonLoaderScreen());
              } else if (state is CalendarError) {
                return Center(child: Text(state.message));
              } else if (state is CalendarLoaded) {
                return Column(
                  children: [
                    // Financial Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Total revenue',
                            state.calendarData.summary.formatAmount(
                              state.calendarData.summary.totalRevenue,
                            ),
                            Colors.green,
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'Total expenditure',
                            state.calendarData.summary.formatAmount(
                              state.calendarData.summary.totalExpenditure,
                            ),
                            Colors.red,
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'Remaining',
                            state.calendarData.summary.formatAmount(
                              state.calendarData.summary.remaining,
                            ),
                            Colors.green,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Syncfusion Calendar
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SfCalendar(
                          view: CalendarView.month,
                          controller: context
                              .read<CalendarBloc>()
                              .calendarController,
                          firstDayOfWeek: 1,
                          headerHeight: 0,
                          showNavigationArrow: false,
                          todayHighlightColor: Colors.red,
                          cellBorderColor: Colors.transparent,
                          monthViewSettings: MonthViewSettings(
                            showTrailingAndLeadingDates: false,
                            monthCellStyle: MonthCellStyle(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              todayTextStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              trailingDatesTextStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                              leadingDatesTextStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                            ),
                            dayFormat: 'EEE',
                          ),
                          monthCellBuilder: (context, details) {
                            return _buildMonthCell(details, state.calendarData);
                          },
                          onTap: (CalendarTapDetails details) {
                            if (details.date != null) {
                              final dailyFinancial = state.calendarData
                                  .getFinancialForDate(details.date!);
                              if (dailyFinancial != null) {
                                _showFinancialDetails(
                                  context,
                                  details.date!,
                                  dailyFinancial,
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: Text('Initializing...'));
            },
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCell(MonthCellDetails details, CalendarData calendarData) {
    final date = details.date;
    final dailyFinancial = calendarData.getFinancialForDate(date);
    final isToday = _isToday(date);
    final isCurrentMonth = date.month == (calendarData.month.month);

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isToday ? Colors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday
                  ? Colors.white
                  : isCurrentMonth
                  ? Colors.black
                  : Colors.grey[400],
            ),
          ),
          if (dailyFinancial != null && isCurrentMonth) ...[
            const SizedBox(height: 4),
            if ((dailyFinancial.revenue ?? 0) > 0)
              Text(
                dailyFinancial.formatAmount(dailyFinancial.revenue ?? 0),
                style: TextStyle(
                  fontSize: 10,
                  color: isToday ? Colors.white : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if ((dailyFinancial.expenditure ?? 0) > 0)
              Text(
                dailyFinancial.formatAmount(dailyFinancial.expenditure ?? 0),
                style: TextStyle(
                  fontSize: 10,
                  color: isToday ? Colors.white : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final today = DateTime(
      2024,
      8,
      12,
    ); // Replace with DateTime.now() for actual today
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  void _showFinancialDetails(
    BuildContext context,
    DateTime date,
    DailyFinancial financial,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(DateFormat('MMMM dd, yyyy').format(date)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Revenue:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  financial.formatAmount(financial.revenue ?? 0),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expenditure:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  financial.formatAmount(financial.expenditure ?? 0),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  financial.formatAmount(financial.total),
                  style: TextStyle(
                    color: financial.total >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
