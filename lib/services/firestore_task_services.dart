import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/task_model.dart';

class FirestoreTaskService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  CollectionReference get _taskCollection =>
      _firestore.collection("tasks");

  String get currentUserId =>
      _auth.currentUser!.uid;

  /// Get all tasks of current user
  Future<List<TaskModel>> getTasks() async {
    try {
      final snapshot = await _taskCollection
          .where("uid", isEqualTo: currentUserId)
          .orderBy("createdAt", descending: true)
          .get();

      print(snapshot.docs.length);

      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("TASK ERROR:");
      print(e);
      rethrow;
    }
  }

  /// Add task
  Future<void> addTask(TaskModel task) async {
    print("========== ADD TASK ==========");
    print(task.toMap());

    await _taskCollection.doc(task.id).set(task.toMap());

    print("Task Saved!");
  }

  /// Update task
  Future<void> updateTask(TaskModel task) async {
    await _taskCollection.doc(task.id).update(task.toMap());
  }

  /// Delete task
  Future<void> deleteTask(String id) async {
    await _taskCollection.doc(id).delete();
  }
}