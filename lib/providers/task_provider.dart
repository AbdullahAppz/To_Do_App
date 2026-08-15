import 'package:flutter/material.dart';

import '../model/task_model.dart';
import '../services/firestore_task_services.dart';

class TaskProvider extends ChangeNotifier {
  final FirestoreTaskService _service = FirestoreTaskService();

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// Load all tasks
  Future<void> loadTasks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _tasks = await _service.getTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new task
  Future<void> addTask(TaskModel task) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print("Provider received:");
      print(task.toMap());

      await _service.addTask(task);

      _tasks = await _service.getTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update existing task
  Future<void> updateTask(TaskModel task) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.updateTask(task);

      _tasks = await _service.getTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete task
  Future<void> deleteTask(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.deleteTask(id);

      _tasks = await _service.getTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}