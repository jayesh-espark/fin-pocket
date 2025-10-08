import 'package:fiin_pocket/app/screens/pages/user_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/pages/calender_page.dart';
import '../../screens/pages/chart_pie_page.dart';
import '../../screens/pages/expense_traker_page.dart';
import '../../screens/pages/reels_page.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  List<Widget> pages = [
    ExpenseTrackerPage(),
    CalenderPage(),
    ReelsPage(),
    ChartPieScreen(),
    UserProfilePage(),
  ];
  int currentIndex = 0;
  HomePageBloc() : super(HomePageInitial()) {
    on<OnPageChanged>(_onPageChanged);
  }

  _onPageChanged(OnPageChanged event, Emitter<HomePageState> emit) {
    currentIndex = event.pageIndex;
    emit(OnPageChangedState(pageIndex: currentIndex));
  }
}
