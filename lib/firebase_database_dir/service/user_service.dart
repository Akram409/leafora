import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection("users");

  Future<String?> getUserToken(String? userId) async {
    try {
      final querySnapshot =
      await _userCollection.where('userId', isEqualTo: userId).get();

      // Fetch the first document and extract the `fcm_token` field
      if (querySnapshot.docs.isNotEmpty) {
        final docData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        return docData?['fcm_token'] as String?;
      }
      return null;
    } catch (e) {
      print("Error fetching user token: $e");
      return null;
    }
  }


  // Update FCM token for the user
  Future<void> updateFcmToken(String userId, String fcmToken) async {
    try {
      DocumentReference userRef = _userCollection.doc(userId);

      await userRef.update({
        'fcm_token': fcmToken,
      });

      print("FCM token updated successfully for user: $userId");
    } catch (e) {
      print("Failed to update FCM token: $e");
      rethrow;
    }
  }

  Future<void> removeInvalidToken(String? invalidToken) async {
    try {
      // Query for the document where the token matches
      final querySnapshot = await _userCollection.where('fcm_token', isEqualTo: invalidToken).get();

      for (var doc in querySnapshot.docs) {
        // Remove the token field from the document
        await doc.reference.update({'fcm_token': FieldValue.delete()});
        print("Removed invalid token from user document: ${doc.id}");
      }
    } catch (e) {
      print("Error removing invalid token: $e");
    }
  }

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
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
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

  Stream<List<Map<String, dynamic>>> getBookmarks(
      String userId, String? bookmarkType) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        List<Map<String, dynamic>> bookmarks =
            List<Map<String, dynamic>>.from(doc['bookmarks'] ?? []);

        if (bookmarkType != null) {
          return bookmarks
              .where((bookmark) => bookmark['bookmarkType'] == bookmarkType)
              .toList();
        }

        return bookmarks;
      } else {
        return [];
      }
    });
  }

  Future<void> addToBookmarksOrPlants({
    required String userId,
    required String id,
    required String type, // "article" or "plant"
    required String name,
    required String imageUrl,
    required String plantScientificName,
    required String plantGenus,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      if (type == "article") {
        // Add to bookmarks
        await userRef.update({
          'bookmarks': FieldValue.arrayUnion([
            {
              'bookmarkId': id,
              'bookmarkImage': imageUrl,
              'bookmarkName': name,
              'bookmarkType': 'article'
            }
          ])
        });
      } else if (type == "plant") {
        await userRef.update({
          'bookmarks': FieldValue.arrayUnion([
            {
              'bookmarkId': id,
              'bookmarkImage': imageUrl,
              'bookmarkName': name,
              'bookmarkType': 'plant',
              'plantScientificName': plantScientificName,
              'plantGenus': plantGenus
            }
          ])
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
    String? plantScientificName,
    String? plantGenus,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      if (type == "article") {
        // Remove from bookmarks
        await userRef.update({
          'bookmarks': FieldValue.arrayRemove([
            {
              'bookmarkId': id,
              'bookmarkImage': imageUrl,
              'bookmarkName': name,
              'bookmarkType': 'article'
            }
          ])
        });
        print("Article ID removed from bookmarks for user: $userId");
      } else if (type == "plant") {
        // Remove from myPlants
        print(id);
        await userRef.update({
          'bookmarks': FieldValue.arrayRemove([
            {
              'bookmarkId': id,
              'bookmarkImage': imageUrl,
              'bookmarkName': name,
              'bookmarkType': 'plant',
              'plantScientificName': plantScientificName,
              'plantGenus': plantGenus
            }
          ])
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
        final bookmarks =
            List<Map<String, dynamic>>.from(userDoc['bookmarks'] ?? []);
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
        final plants =
            List<Map<String, dynamic>>.from(userDoc['bookmarks'] ?? []);
        return plants.any((plant) => plant['bookmarkId'] == plantId);
      }
      return false;
    } catch (e) {
      print("Error checking bookmark state for plant: $e");
      return false;
    }
  }

  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      // Query the user collection to find users with the specified role
      final querySnapshot = await _userCollection.where('role', isEqualTo: role).get();

      // Map the query results to a list of UserModel instances
      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching users by role: $e");
      throw Exception("Failed to fetch users with role $role: $e");
    }
  }

  Future<void> updateUserPlanAndPaymentHistory(String userId, String newPlan, Map<String, dynamic> paymentResponse) async {
    try {
      // Get a reference to the user document
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Convert payment response to JSON string
      String paymentDataJson = jsonEncode(paymentResponse);

      // Update the 'plan' field and add to 'paymentHistory'
      await userRef.update({
        'plan': newPlan,
        'paymentHistory': FieldValue.arrayUnion([paymentDataJson]),
      });

      print("User plan updated and payment history saved successfully for user: $userId");
    } catch (e) {
      print("Error updating user plan and payment history: $e");
      throw Exception("Failed to update user plan and payment history: $e");
    }
  }

}
