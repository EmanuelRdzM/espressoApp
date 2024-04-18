import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String? userId;
  final String? userStoreName;
  final String? userEmail;

  UserModel({
    this.userId,
    this.userStoreName,
    this.userEmail,
  });

  factory UserModel.fromDocument(Map<String, dynamic> doc){
    return UserModel(
      userId: doc[USER_ID], 
      userStoreName: doc[USER_STORE_NAME],
      userEmail: doc[USER_EMAIL],
    );
  }
}

class UserProvider with ChangeNotifier {
  late UserModel _currentUser = UserModel(); // Usuario actual

  UserModel get currentUser => _currentUser;

  // Función para obtener los datos del usuario
  Future<void> getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      _currentUser = UserModel.fromDocument(userData.data()!);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = UserModel(); // Limpia el estado del usuario
    notifyListeners();
  }
}