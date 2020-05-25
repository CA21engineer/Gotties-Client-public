import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gottiesclient/models/models.dart';
import 'package:http/http.dart' as http;

class ApiClient implements BaseClient {
  // TODO: APIの仕様が決まれば追記
  final String _baseUrl = 'http://localhost:8080';

  final FirestoreClient _firestoreRepository = FirestoreClient();

  @override
  Future<List<Article>> getArticles() async {
    List<Article> lists;
    try {
      final response = await http.get('$_baseUrl/articles');
      final jsonMap = await _handleResponse(response);
      final articlesFromFirestore = await _firestoreRepository.getArticles();

      // いいね情報を取得して詰める
      final List<Map<String, dynamic>> jsonMapLikeUsers = jsonMap.map((json) {
        final String id = json['id'] as String;
        final likeUserIds = articlesFromFirestore.firstWhere((element) => element.id == id).likeUserIds;
        json['like_users'] = likeUserIds;
        return json;
      }).toList();

      lists = jsonMapLikeUsers.map((json) => Article.fromJson(json)).toList();
    } on SocketException {
      throw FetchDataException('Error occured while Communication with Server ');
    }
    return lists;
  }

  @override
  Future<List<Article>> getFilteredArticles(String categoryId) {
    // TODO: implement getFilteredArticles
    throw UnimplementedError();
  }

  @override
  Future<void> postArticle(String title, File before, File after, String body, String categoryId, String userId) async {
    // base64 encode
    final beforeImageBytes = before.readAsBytesSync();
    final beforeImageString = base64Encode(beforeImageBytes);
    final afterImageBytes = after.readAsBytesSync();
    final afterImageString = base64Encode(afterImageBytes);

    final Map<String, String> headers = {'content-type': 'application/json'};
    final String _body = json.encode({
      'title': title,
      'before': beforeImageString,
      'after': afterImageString,
      'body': body,
      'category_id': categoryId,
      'user_id': userId,
    });
    try {
      final response = await http.post('$_baseUrl/articles', headers: headers, body: _body);
      await _handleResponse(response);
    } on SocketException {
      throw FetchDataException('Error occured while Communication with Server ');
    }
  }

  @override
  Future<List<Category>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

  @override
  Future<void> likeArticle(String userID, String articleID) async {
    return _firestoreRepository.likeArticle(userID, articleID);
  }

  @override
  Future<void> unlikeArticle(String userID, String articleID) async {
    return _firestoreRepository.unlikeArticle(userID, articleID);
  }

  Future<List<Map<String, dynamic>>> _handleResponse(http.Response response) async {
    debugPrint('Status Code -> $response.statusCode');
    switch (response.statusCode) {
      case 200:
        debugPrint('json -> ${response.body}');
        final jsonMap = (await jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
        return jsonMap;
      case 201:
        return <Map<String, dynamic>>[];
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteArticle(String id, String userID) {
    // TODO: implement deleteArticle
    throw UnimplementedError();
  }
}
