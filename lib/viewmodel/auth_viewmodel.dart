import '../data/repository/auth_repository.dart';

class AuthViewModel {
  final AuthRepository repository;

  AuthViewModel(this.repository);

  String? error;

  Future<bool> login(String email, String password) async {
    error = null;

    try {
      await repository.login(email, password);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    error = null;

    try {
      final success = await repository.register(name, email, password);
      return success;
    } catch (e) {
      error = e.toString();
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