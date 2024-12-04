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
}
