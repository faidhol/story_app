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

class MyRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool isLoggedIn = false;
  bool isRegister = false;
  bool isAddStory = false;

  StoryModel? selectedStory;

  Key storyListKey = UniqueKey();

  Future<void> init() async {
    final token = await PreferencesHelper.getToken();
    isLoggedIn = token != null;
    notifyListeners();
  }

  /// 🔥 ACTIONS
  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() async {
    await PreferencesHelper.clear();
    isLoggedIn = false;
    isRegister = false;
    isAddStory = false;
    selectedStory = null;
    notifyListeners();
  }

  void openRegister() {
    isRegister = true;
    notifyListeners();
  }

  void closeRegister() {
    isRegister = false;
    notifyListeners();
  }

  void openAddStory() {
    isAddStory = true;
    notifyListeners();
  }

  void closeAddStory() {
    isAddStory = false;
    notifyListeners();
  }

  void openDetail(StoryModel story) {
    selectedStory = story;
    notifyListeners();
  }

  void closeDetail() {
    selectedStory = null;
    notifyListeners();
  }

  void refreshStories() {
    storyListKey = UniqueKey();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (!isLoggedIn)
          MaterialPage(
            child: LoginPage(
              onLoginSuccess: login,
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
        if (selectedStory != null) {
          closeDetail();
        } else if (isAddStory) {
          closeAddStory();
        } else if (isRegister) {
          closeRegister();
        }
      },
    );
  }

  @override
  Future<bool> popRoute() {
    if (selectedStory != null) {
      closeDetail();
      return Future.value(true);
    } else if (isAddStory) {
      closeAddStory();
      return Future.value(true);
    } else if (isRegister) {
      closeRegister();
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> setNewRoutePath(void configuration) async {}
}

class MyRouteParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(
      RouteInformation routeInformation) async => Object();
}

class _MyAppState extends State<MyApp> {
  late final MyRouterDelegate _routerDelegate;
  final MyRouteParser _parser = MyRouteParser();

  @override
  void initState() {
    super.initState();
    _routerDelegate = MyRouterDelegate();
    _routerDelegate.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _routerDelegate,
      routeInformationParser: _parser,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}