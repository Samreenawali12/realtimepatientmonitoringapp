import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class authFunction {
  signUp(String email, String password) async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  signOut() async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }
}
