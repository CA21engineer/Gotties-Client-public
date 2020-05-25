import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gottiesclient/models/entities/article.dart';
import 'package:gottiesclient/models/models.dart';
import 'package:gottiesclient/models/stores/stores.dart';

class ArticleRepository extends ChangeNotifier {
  ArticleRepository(LoginStore loginStore, BaseClient client)
      : assert(client != null),
        assert(loginStore != null),
        _loginStore = loginStore,
        _client = client {
    getArticles();
  }

  final BaseClient _client;
  final LoginStore _loginStore;
  List<Article> articles;

  String get userID => _loginStore.user?.uid;

  // TODO: try catchはStoreで
  Future<void> getArticles() async {
    articles = await _client.getArticles();
    notifyListeners();
  }

  Future<void> postArticle(String title, File before, File after, String body, String categoryId) async {
    if (!_loginStore.isLoggedIn) {
      await _loginStore.loginAnonymously();
    }
    await _client.postArticle(title, before, after, body, categoryId, userID ?? '');
  }

  Future<void> deleteArticle(Article article) async {
    if (userID == article.userID) {
      throw UnauthorisedException();
    }
    await _client.deleteArticle(article.id, userID);
    articles = articles.where((element) => element.id != article.id).toList();
    notifyListeners();
  }

  Future<void> likeArticle(String articleID) async {
    if (userID == null) {
      throw UnauthorisedException();
    }
    await _client.likeArticle(userID, articleID);
    articles.forEach((article) {
      if (article.id == articleID) {
        article.likeUserIds.add(_loginStore.user.uid);
      }
    });
    notifyListeners();
  }

  bool isLike(String articleId) {
    if (userID == null) {
      return false;
    }
    final article = articles.firstWhere((article) => article.id == articleId);
    final isLike = article.likeUserIds.contains(userID);
    return isLike;
  }

  Future<void> unlikeArticle(String articleID) async {
    if (userID == null) {
      throw UnauthorisedException();
    }
    await _client.unlikeArticle(userID, articleID);
    articles.forEach((article) {
      if (article.id == articleID) {
        article.likeUserIds.remove(userID);
      }
    });
    notifyListeners();
  }

  Future<void> filterArticles(Category category) async {
    articles = await _client.getFilteredArticles(category.id);
    notifyListeners();
  }

  bool isMyArticle(Article article) {
    return article.userID == userID;
  }
}
