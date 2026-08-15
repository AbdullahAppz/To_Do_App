import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String avatar;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      avatar: data["avatar"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "avatar": avatar,
    };
  }
}