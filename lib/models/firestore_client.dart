import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gottiesclient/models/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreClient implements BaseClient {
  final Firestore _firestore = Firestore.instance;
  final Uuid _uuid = Uuid();

  @override
  Future<List<Article>> getArticles() async {
    final documents = (await _firestore.collection('articles').getDocuments()).documents;
    return mapJsonToArticle(documents);
  }

  @override
  Future<List<Article>> getFilteredArticles(String categoryId) async {
    final categoryRef = _firestore.collection('category').where('id', isEqualTo: categoryId);
    final articleRef = _firestore.collection('articles');
    final documents = (await articleRef.where('category', isEqualTo: categoryRef).getDocuments()).documents;
    return mapJsonToArticle(documents);
  }

  Future<List<Article>> mapJsonToArticle(List<DocumentSnapshot> documents) {
    return Future.wait(
      documents.map((document) async {
        final data = document.data;
        data['id'] = document.documentID;
        final category = await (data['category'] as DocumentReference).get();
        data['category'] = category.data;
        final likeUserIds = (await document.reference.collection('like_users').getDocuments())
            .documents
            .map((e) => e.documentID)
            .toList();
        data['like_users'] = likeUserIds;
        data['category']['id'] = category.documentID;
        return Article.fromJson(data);
      }),
    );
  }

  @override
  Future<void> postArticle(String title, File before, File after, String body, String categoryId, String userId) async {
    // Upload to Cloud Storage
    final result = await Future.wait([
      _uploadToStorage(before),
      _uploadToStorage(after),
    ]);
    final beforeUploadURL = result[0];
    final afterUploadURL = result[1];
    final Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'before': beforeUploadURL,
      'after': afterUploadURL,
      'body': body,
      'category': _firestore.document('category/$categoryId'),
      'user_id': userId,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    };

    return _firestore.collection('articles').add(data);
  }

  /// return 画像URLStringのFuture
  Future<String> _uploadToStorage(File file) async {
    final StorageReference storageReference = FirebaseStorage().ref().child(_uuid.v1());
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });

    final dynamic downloadURL = await (await uploadTask.onComplete).ref.getDownloadURL();
    await streamSubscription.cancel();

    return downloadURL as String;
  }

  @override
  Future<void> deleteArticle(String id, String userID) async {
    final document = _firestore.collection('articles').document(id);
    if ((await document.get()).data['user_id'] as String == userID) {
      await document.delete();
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    final documents = (await _firestore.collection('category').getDocuments()).documents;
    return documents.map((document) {
      final data = document.data;
      data['id'] = document.documentID;
      return Category.fromJson(data);
    }).toList();
  }

  @override
  Future<void> likeArticle(String userID, String articleID) async {
    final emptyData = <String, dynamic>{};
    return Future.wait([
      _firestore
          .collection('articles')
          .document(articleID)
          .collection('like_users')
          .document(userID)
          .setData(emptyData),
      _firestore
          .collection('users')
          .document(userID)
          .collection('like_articles')
          .document(articleID)
          .setData(emptyData),
    ]);
  }

  @override
  Future<void> unlikeArticle(String userID, String articleID) async {
    return Future.wait([
      _firestore.collection('users').document(userID).collection('like_articles').document(articleID).delete(),
      _firestore.collection('articles').document(articleID).collection('like_users').document(userID).delete(),
    ]);
  }
}
