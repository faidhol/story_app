import 'package:flutter/material.dart';
import '../data/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel(this.repository);

  bool isLoading = false;
  String? error;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await repository.login(email, password);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();

      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final success = await repository.register(name, email, password);

      isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      error = e.toString();

      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await repository.logout();
  }

  Future<bool> isLoggedIn() async {
    return await repository.isLoggedIn();
  }
}
