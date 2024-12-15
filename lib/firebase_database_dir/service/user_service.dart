import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      // Ensure userId is set
      if (user.userId == null || user.userId!.isEmpty) {
        throw Exception("User ID cannot be null or empty.");
      }

      // Add userId to the user data (if not already added in `toJson`)
      final userData = user.toJson();
      userData['userId'] = user.userId;

      // Save the user to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .set(userData);

      print("User saved to Firestore with ID: ${user.userId}");
    } catch (e) {
      print("Error saving user: $e");
      throw Exception("Failed to create user: $e");
    }
  }

  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(userId).update(updates);
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  Future<void> addToBookmarksOrPlants({
    required String userId,
    required String id,
    required String type, // "article" or "plant"
    required String name,
    required String imageUrl,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      if (type == "article") {
        // Add to bookmarks
        await userRef.update({
          'bookmarks': FieldValue.arrayUnion([{'bookmarkId': id, 'bookmarkImage': imageUrl,'bookmarkName': name,'bookmarkType': 'article'}])
        });
      }
      else if (type == "plant") {
        await userRef.update({
          'bookmarks': FieldValue.arrayUnion([{'bookmarkId': id, 'bookmarkImage': imageUrl,'bookmarkName': name,'bookmarkType': 'plant'}])
        });
      } else {
        throw Exception("Invalid type. Must be 'article' or 'plant'.");
      }
    } catch (e) {
      print("Error adding $type ID: $e");
      throw Exception("Failed to add $type ID: $e");
    }
  }

  Future<void> removeFromBookmarksOrPlants({
    required String userId,
    required String id,
    required String type, // "article" or "plant"
    required String name,
    required String imageUrl,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      if (type == "article") {
        // Remove from bookmarks
        await userRef.update({
          'bookmarks': FieldValue.arrayRemove([{'bookmarkId': id, 'bookmarkImage': imageUrl,'bookmarkName': name,'bookmarkType': 'article'}])
        });
        print("Article ID removed from bookmarks for user: $userId");
      } else if (type == "plant") {
        // Remove from myPlants
        await userRef.update({
          'bookmarks': FieldValue.arrayRemove([{'bookmarkId': id, 'bookmarkImage': imageUrl,'bookmarkName': name,'bookmarkType': 'plant'}])
        });
        print("Plant ID removed from myPlants for user: $userId");
      } else {
        throw Exception("Invalid type. Must be 'article' or 'plant'.");
      }
    } catch (e) {
      print("Error removing $type ID: $e");
      throw Exception("Failed to remove $type ID: $e");
    }
  }

  Future<bool> isArticleBookmarked(String userId, String articleId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final bookmarks = List<Map<String, dynamic>>.from(userDoc['bookmarks'] ?? []);
        return bookmarks.any((bookmark) => bookmark['bookmarkId'] == articleId);
      }
      return false;
    } catch (e) {
      print("Error checking bookmark state: $e");
      return false;
    }
  }

  Future<bool> isPlantBookmarked(String userId, String plantId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final plants = List<Map<String, dynamic>>.from(userDoc['bookmarks'] ?? []);
        return plants.any((plant) => plant['bookmarkId'] == plantId);
      }
      return false;
    } catch (e) {
      print("Error checking bookmark state for plant: $e");
      return false;
    }
  }


}
