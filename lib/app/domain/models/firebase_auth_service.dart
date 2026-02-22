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


  Future<bool> changeEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        showToast(message: 'No hay usuario autenticado.');
        return false;
      }

      final String? currentEmail = user.email;
      if (currentEmail == null) {
        showToast(message: 'El usuario no tiene un email asociado.');
        return false;
      }

      // 1) Re-autenticar con la credencial de email/password
      final credential = EmailAuthProvider.credential(
        email: currentEmail,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // 2) Actualizar el email en Firebase Auth
      await user.updateEmail(newEmail);

      // Opcional: enviar verificación si usas emailVerified
      try {
        await user.sendEmailVerification();
      } catch (_) {
        // si falla el envio de verificación, no interrumpimos la operación principal
      }

      // 3) Actualizar el documento en Firestore (si guardas el email ahí)
      try {
        await _firestore.collection(C_USERS).doc(user.uid).update({
          USER_EMAIL: newEmail,
        });
      } catch (e) {
        // Si hay error al actualizar Firestore, avisar pero ya cambió en Auth
        showToast(message: 'Email actualizado en Auth pero fallo al actualizar Firestore.');
      }

      showToast(message: 'Correo actualizado correctamente. Revisa verificación si aplica.');
      return true;
    } on FirebaseAuthException catch (e) {
      // Manejo de errores comunes
      if (e.code == 'wrong-password') {
        showToast(message: 'La contraseña ingresada es incorrecta.');
      } else if (e.code == 'invalid-email') {
        showToast(message: 'El nuevo correo no es válido.');
      } else if (e.code == 'email-already-in-use') {
        showToast(message: 'El correo ya está en uso por otra cuenta.');
      } else if (e.code == 'requires-recent-login') {
        // Esto normalmente se evita porque reauthenticateWithCredential lo soluciona
        showToast(message: 'Necesitas iniciar sesión de nuevo.');
      } else {
        showToast(message: 'Error al actualizar correo: ${e.code}');
      }
      return false;
    } catch (e) {
      showToast(message: 'Ocurrió un error: $e');
      return false;
    }
  }

}
