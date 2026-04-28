import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/story_model.dart';
import '../data/repository/story_repository.dart';

class StoryViewModel extends ChangeNotifier {
  final StoryRepository repository;

  StoryViewModel(this.repository);

  List<StoryModel> stories = [];
  StoryModel? detailStory;

  bool isLoading = false;
  bool isUploading = false;

  String? error;

  Future<void> fetchStories() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await repository.getStories();
      stories = result;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDetail(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      detailStory = await repository.getDetailStory(id);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addStory({
    required File file,
    required String description,
  }) async {
    isUploading = true;
    error = null;
    notifyListeners();

    try {
      final success = await repository.addStory(
        file: file,
        description: description,
      );

      if (success) {
        await fetchStories();
      }

      isUploading = false;
      notifyListeners();

      return success;
    } catch (e) {
      error = e.toString();

      isUploading = false;
      notifyListeners();

      return false;
    }
  }
}
