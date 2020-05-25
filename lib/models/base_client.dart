import 'dart:io';

import 'package:gottiesclient/models/entities/entities.dart';

abstract class BaseClient {
  Future<List<Article>> getArticles();

  Future<List<Article>> getFilteredArticles(String categoryId);

  Future<void> postArticle(String title, File before, File after, String body, String categoryId, String userId);

  Future<void> deleteArticle(String id, String userID);

  Future<List<Category>> getCategories();

  /// いいね関係
  Future<void> likeArticle(String userID, String articleID);

  Future<void> unlikeArticle(String userID, String articleID);
}
