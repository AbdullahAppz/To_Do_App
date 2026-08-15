import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class FirestoreUserService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> get userDoc =>
      _firestore.collection("users").doc(uid);

  Future<void> createUser({
    required String name,
    required String email,
  }) async {
    await userDoc.set({
      "uid": uid,
      "name": name,
      "email": email,
      "avatar": "",
    });
  }
  Future<UserModel> getUser() async {
    print("========== USER DEBUG ==========");
    print("Current UID: $uid");

    final doc = await userDoc.get();

    print("Document exists: ${doc.exists}");

    if (doc.exists) {
      print("Firestore Data:");
      print(doc.data());
    }

    if (!doc.exists) {
      throw Exception("User profile not found.");
    }

    return UserModel.fromFirestore(doc);
  }

  Future<void> updateUser(UserModel user) async {
    await userDoc.update(user.toMap());
  }
}