import 'package:fiin_pocket/app/blocs/splash/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/blocs/expense/expense_bloc.dart';
import 'app/blocs/home_page/home_page_bloc.dart';
import 'app/core/themes/app_theme.dart';
import 'app/router/AppRouter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HomePageBloc())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.splashScreen, // start with login screen
      ),
    );
  }
}
