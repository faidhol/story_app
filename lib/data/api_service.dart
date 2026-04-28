import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {'name': name, 'email': email, 'password': password},
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getStories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDetailStory(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return _handleResponse(response);
  }

  Future<bool> uploadStory({
    required String token,
    required File file,
    required String description,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/stories'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath('photo', file.path));

      request.fields['description'] = description;

      var response = await request.send();

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Terjadi kesalahan');
    }
  }
}
