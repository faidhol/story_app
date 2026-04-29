import 'dart:io';
import '../api_service.dart';
import '../models/story_model.dart';

class StoryRepository {
  final ApiService apiService;

  StoryRepository(this.apiService);

  Future<List<StoryModel>> getStories(int page, int size) async {
    final data = await apiService.getStories(page, size);

    return data.map((e) => StoryModel.fromJson(e)).toList();
  }

  Future<bool> addStory({
    required File file,
    required String description,
    double? lat,
    double? lon,
  }) async {
    return await apiService.addStory(
      file: file,
      description: description,
      lat: lat,
      lon: lon,
    );
  }
}