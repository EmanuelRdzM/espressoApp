import 'package:cafeteria_app/app/UI/routes/app_routes.dart';
import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cafeteria_app/app/UI/theme/theme.dart'; // ruta donde guardes buildAppTheme

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: 'Flutter COFFEE',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      routes: appRoutes,
      theme: buildAppTheme(),
    );
  }
}