import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TaskModel(
      id: doc.id,
      uid: data["uid"] ?? "",
      title: data["title"] ?? "",
      description: data["description"] ?? "",
      isCompleted: data["isCompleted"] ?? false,
      createdAt: data["createdAt"] != null
          ? (data["createdAt"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "uid": uid,
      "title": title,
      "description": description,
      "isCompleted": isCompleted,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }
}