import 'dart:io';
import '../api_service.dart';
import '../models/story_model.dart';
import '../../utils/preferences_helper.dart';

class StoryRepository {
  final ApiService _apiService;

  StoryRepository(this._apiService);

  Future<List<StoryModel>> getStories() async {
    try {
      final token = await PreferencesHelper.getToken();

      if (token == null) {
        throw Exception('Token tidak ditemukan, silakan login ulang');
      }

      final response = await _apiService.getStories(token);

      final List list = response['listStory'];

      return list.map((e) => StoryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil story: $e');
    }
  }

  Future<StoryModel> getDetailStory(String id) async {
    try {
      final token = await PreferencesHelper.getToken();

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _apiService.getDetailStory(id, token);

      return StoryModel.fromJson(response['story']);
    } catch (e) {
      throw Exception('Gagal mengambil detail story: $e');
    }
  }

  Future<bool> addStory({
    required File file,
    required String description,
  }) async {
    try {
      final token = await PreferencesHelper.getToken();

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final success = await _apiService.uploadStory(
        token: token,
        file: file,
        description: description,
      );

      return success;
    } catch (e) {
      throw Exception('Gagal upload story: $e');
    }
  }
}
