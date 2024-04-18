import 'package:cafeteria_app/app/UI/routes/routes.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/widgets/icon_progres_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: IconProgressInidcator()
      ),
    );
  }

  void _checkAuthStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await Provider.of<UserProvider>(context, listen: false).getCurrentUser();
        Navigator.of(context).pushReplacementNamed(Routes.welcome);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
    });
  }
}

class _LoadingIndicator extends StatefulWidget {
  @override
  __LoadingIndicatorState createState() => __LoadingIndicatorState();
}

class __LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          int dots = (_controller.value * 3).ceil();
          return Text('.' * dots, style: const TextStyle(fontSize: 24));
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}