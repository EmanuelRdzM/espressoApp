import 'package:cafeteria_app/app/UI/screens/contact_screen.dart';
import 'package:cafeteria_app/app/UI/screens/home_screen.dart';
import 'package:cafeteria_app/app/UI/screens/menu_screen/menu_screen.dart';
import 'package:cafeteria_app/app/UI/screens/orders_avaible_screen.dart';
import 'package:cafeteria_app/app/UI/screens/sign_in_screen.dart';
import 'package:cafeteria_app/app/UI/screens/sign_up_screen.dart';
import 'package:cafeteria_app/app/UI/screens/splash_screen/splash_screen.dart';
import 'package:cafeteria_app/app/UI/screens/store_screen.dart';
import 'package:cafeteria_app/app/UI/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'routes.dart';
import 'package:flutter/widgets.dart' show Widget, BuildContext;

Map<String, Widget Function(BuildContext)> get appRoutes =>{
  Routes.splash: (_) => const SplashScreen(),

  /// Session screens
  Routes.login: (_) =>  const SignInScreen(),
  Routes.register: (_) => const SignUpScreen(),

  /// App Navigation Screens
  Routes.welcome: (_) => const WelcomeScreen(),
  Routes.home: (_) => const HomeScreen(),
  Routes.menu: (_) => const MenuScreen(),
  Routes.ordersAvailble: (_) => const OrdersScreen(),
  Routes.inventory: (_) => const InventoryScreen(),
  Routes.contacts: (_) => const ContactScreen(),
};