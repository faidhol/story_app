import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utils/preferences_helper.dart';

class ApiService {
  final String baseUrl = "https://story-api.dicoding.dev/v1";

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }

  Future<List<dynamic>> getStories(int page, int size) async {
    final token = await PreferencesHelper.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/stories?page=$page&size=$size"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["listStory"];
    } else {
      throw Exception(data["message"]);
    }
  }

  Future<bool> addStory({
    required File file,
    required String description,
    double? lat,
    double? lon,
  }) async {
    final token = await PreferencesHelper.getToken();

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/stories"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.fields["description"] = description;

    if (lat != null) request.fields["lat"] = lat.toString();
    if (lon != null) request.fields["lon"] = lon.toString();

    request.files.add(
      await http.MultipartFile.fromPath("photo", file.path),
    );

    final response = await request.send();

    return response.statusCode == 201;
  }
}