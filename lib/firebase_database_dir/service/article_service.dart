import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/article.dart';


class ArticleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createArticle(ArticleModel article) async {
    await _firestore.collection('articles').doc(article.articleId).set(article.toJson());
  }

  Future<ArticleModel?> getArticle(String articleId) async {
    DocumentSnapshot doc = await _firestore.collection('articles').doc(articleId).get();
    if (doc.exists) {
      return ArticleModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateArticle(String articleId, Map<String, dynamic> updates) async {
    await _firestore.collection('articles').doc(articleId).update(updates);
  }

  Future<void> deleteArticle(String articleId) async {
    await _firestore.collection('articles').doc(articleId).delete();
  }
}
