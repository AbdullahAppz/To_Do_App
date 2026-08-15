import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/firestore_user_service.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreUserService _service = FirestoreUserService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadUser() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      _user = await _service.getUser();

      print("====== PROVIDER ======");
      print(_user!.name);
      print(_user!.email);
      print(_user!.uid);
      print("======================");

    } catch (e) {
      print(e);
      _error = e.toString();
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();
      _user = await _service.getUser();
      await _service.updateUser(user);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}