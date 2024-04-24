import 'package:cafeteria_app/app/constants/constants.dart';
import 'package:cafeteria_app/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaAutServices{

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> signUpwithEmailAndPassword(String email, String password) async{
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use'){
        showToast(message: 'The email addres is already in use.');
      }else{
        showToast(message: 'An error ocurred: ${e.code}.');
      }
    }
  return null;
  }

  Future<void> signUpFireStore({
    required User user,
    required String userStoreName,
  }) async{
    
    await _firestore.collection(C_USERS).doc(user.uid).set(
      <String, dynamic>{
        USER_ID: user.uid,
        USER_STORE_NAME: userStoreName,
        USER_EMAIL: user.email,
      }
    );

  }

  Future<User?> signInpwithEmailAndPassword(String email, String password) async{
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        showToast(message: 'User not found for this Emai');
        //print('Firebase Authentication Exception: ${e.code}/////////////');

      } else if(e.code == 'wrong-password'){
        showToast(message: 'Wrong Password');
        //print('Firebase Authentication Exception: ${e.code}/////////////');

      } else if(e.code == 'invalid-credential'){
        showToast(message: 'Invalid email or password');
        //print('Firebase Authentication Exception: ${e.code}/////////////');

      } else if(e.code == 'invalid-email'){
        showToast(message: 'Invalid email');
        //print('Firebase Authentication Exception: ${e.code}/////////////');

      }else{
        showToast(message: 'An error  ocurred: ${e.code}.');
      }
    }
  return null;
  }

}
