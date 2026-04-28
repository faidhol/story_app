import '../api_service.dart';
import '../models/user_model.dart';
import '../../utils/preferences_helper.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);

      final user = UserModel.fromJson(response['loginResult']);

      await PreferencesHelper.saveToken(user.token);

      return user;
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _apiService.register(name, email, password);

      return !response['error'];
    } catch (e) {
      throw Exception('Register gagal: $e');
    }
  }

  Future<void> logout() async {
    await PreferencesHelper.clear();
  }

  Future<String?> getToken() async {
    return await PreferencesHelper.getToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
