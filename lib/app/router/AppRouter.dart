import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/ calender/calendar_bloc.dart';
import '../blocs/expense/expense_bloc.dart';
import '../blocs/splash/splash_bloc.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  // Named routes
  static const String homeScreen = '/homeScreen';
  static const String splashScreen = '/splashScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SplashBloc(),
            child: SplashScreen(),
          ),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ExpenseBloc()),
              BlocProvider(create: (context) => CalendarBloc()),
            ],
            child: HomeScreen(),
          ),
        );
      default:
        // If route not found, show a 404 page
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
