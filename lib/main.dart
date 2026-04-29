import 'package:flutter/material.dart';
import 'utils/preferences_helper.dart';
import 'view/auth/login_page.dart';
import 'view/auth/register_page.dart';
import 'view/story/story_list_page.dart';
import 'view/story/add_story_page.dart';
import 'view/story/story_detail_page.dart';
import 'data/models/story_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isLoggedIn = false;

  bool isRegister = false;
  bool isAddStory = false;

  StoryModel? selectedStory;

  /// 🔥 key untuk trigger reload StoryListPage
  Key storyListKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    final token = await PreferencesHelper.getToken();

    setState(() {
      isLoggedIn = token != null;
      isLoading = false;
    });
  }

  void loginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() async {
    await PreferencesHelper.clear();
    setState(() {
      isLoggedIn = false;
      isRegister = false;
      isAddStory = false;
      selectedStory = null;
    });
  }

  void openRegister() {
    setState(() {
      isRegister = true;
    });
  }

  void closeRegister() {
    setState(() {
      isRegister = false;
    });
  }

  void openAddStory() {
    setState(() {
      isAddStory = true;
    });
  }

  void closeAddStory() {
    setState(() {
      isAddStory = false;
    });
  }

  void openDetail(StoryModel story) {
    setState(() {
      selectedStory = story;
    });
  }

  void closeDetail() {
    setState(() {
      selectedStory = null;
    });
  }

  void refreshStories() {
    setState(() {
      storyListKey = UniqueKey(); // 🔥 force rebuild list
    });
  }

  void handleSystemBack() {
    if (selectedStory != null) {
      closeDetail();
    } else if (isAddStory) {
      closeAddStory();
    } else if (isRegister) {
      closeRegister();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          handleSystemBack();
        },
        child: Navigator(
          pages: [
            if (!isLoggedIn)
              MaterialPage(
                child: LoginPage(
                  onLoginSuccess: loginSuccess,
                  onRegister: openRegister,
                ),
              ),

            if (!isLoggedIn && isRegister)
              MaterialPage(
                child: RegisterPage(onBack: closeRegister),
              ),

            if (isLoggedIn)
              MaterialPage(
                child: StoryListPage(
                  key: storyListKey, 
                  onLogout: logout,
                  onAddStory: openAddStory,
                  onDetail: openDetail,
                ),
              ),

            if (isAddStory)
              MaterialPage(
                child: AddStoryPage(
                  onBack: closeAddStory,
                  onSuccess: refreshStories,
                ),
              ),

            if (selectedStory != null)
              MaterialPage(
                child: StoryDetailPage(
                  story: selectedStory!,
                  onBack: closeDetail,
                ),
              ),
          ],

          onDidRemovePage: (page) {
            handleSystemBack();
          },
        ),
      ),
    );
  }
}