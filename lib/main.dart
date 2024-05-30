//import 'package:cafeteria_app/app/UI/inject_dependencies.dart';
import 'package:cafeteria_app/app/data/user.dart';
import 'package:cafeteria_app/app/my_app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp())
  );
}

Future<void> initialize() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}