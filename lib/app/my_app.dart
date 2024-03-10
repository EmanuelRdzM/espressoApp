
import 'package:cafeteria_app/app/UI/routes/app_routes.dart';
import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent)
    );

    return MaterialApp(
      title: 'Flutter COFFE',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      routes: appRoutes,
      theme: _appTheme(),
    );
  }

  // App theme
  ThemeData _appTheme() {
    return ThemeData(
      primaryColorDark: APP_PRIMARY_COLOR_DARK,
      primaryColorLight: APP_PRIMARY_COLOR_LIGHT,
      primaryColor: APP_PRIMARY_COLOR,
      colorScheme: const ColorScheme.light().copyWith(
        primary: APP_PRIMARY_COLOR,
        secondary: APP_ACCENT_COLOR,
        background: APP_PRIMARY_COLOR,
      ),

      scaffoldBackgroundColor: const Color.fromRGBO(236, 223, 235, 1),

      inputDecorationTheme: InputDecorationTheme(
        
        errorStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
        )
      ),
      
      appBarTheme: const AppBarTheme(
        //toolbarHeight: 50,
        centerTitle: true,
        color: APP_PRIMARY_COLOR,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 230, 230, 230), 
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),
      ),

    );
  }
}