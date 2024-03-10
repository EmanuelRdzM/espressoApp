import 'dart:async';

import 'package:cafeteria_app/app/domain/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FirebaseAuth _auth; 
  User? _user;

  final Completer<void> _completer = Completer();

  AuthenticationRepositoryImpl(this._auth){
    init();
  }

  @override
  Future<User?> get user async{
    await _completer.future;
    return _user;
  }

  void init() async{
    _auth.authStateChanges().listen(
      (User? user) {
        if(!_completer.isCompleted){
          _completer.complete();
        }
        _user = user;
      },
    );

  }

}