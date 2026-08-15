import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("==============");
      print("NAME: $name");
      print("EMAIL: $email");
      print("UID: ${credential.user!.uid}");
      print("==============");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "uid": credential.user!.uid,
        "name": name,
        "email": email,
        "avatar": "",
      });

      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        "uid",
        credential.user!.uid,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        "uid",
        credential.user!.uid,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove("uid");
  }
}