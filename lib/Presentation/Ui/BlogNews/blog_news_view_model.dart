import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../Core/Base/base_view_model.dart';
import '../../Models/news_card.dart';
import 'blog_news_navigator.dart';

class BlogNewsViewModel extends BaseViewModel<BlogNewsNavigator> {
  List<Article> articles = [];
  String? errorMessage;
  bool isLoading = false;
  bool hasInternet = false;

  Future<void> loadArticles({String langCode = 'en', bool forceRefresh = false}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      hasInternet = connectivityResult != ConnectivityResult.none;

      if (!hasInternet && !forceRefresh) {
        errorMessage = "No internet connection.";
        articles = [];
        return;
      }

      final filePath = langCode == 'ar'
          ? 'Assets/data/articles-ar.json'
          : 'Assets/data/articles.json';

      final jsonString = await rootBundle.loadString(filePath);
      final List<dynamic> jsonData = json.decode(jsonString);

      articles = jsonData
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList();

      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load articles.';
      articles = [];
      print('Error loading articles: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshArticles({String langCode = 'en'}) async {
    await loadArticles(langCode: langCode, forceRefresh: true);
  }

  void goToDetails(int articleId) {
    navigator?.goToArticleDetails(articleId);
  }
}