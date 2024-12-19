import 'package:firebase_auth/firebase_auth.dart';
import 'package:leafora/firebase_database_dir/service/user_service.dart';
import '../firebase_database_dir/models/user.dart' as app_user;


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in method
  Future<app_user.UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Fetch user details from the database
      app_user.UserModel? user = await _userService.getUser(userCredential.user!.uid);

      if (user != null) {
        // Print the user data after fetching from Firestore
        print("User Data from Firestore: ${user}");
      } else {
        print("User not found in Firestore.");
      }

      return user;
    } catch (e) {
      print("Sign-in error: $e");
      rethrow;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Sign-out error: $e");
      rethrow;
    }
  }

  // Check if the user is an admin
  Future<bool> isAdmin(String uid) async {
    try {
      final user = await _userService.getUser(uid);
      if (user != null) {
        // Check if user has 'admin' role
        return user.role?.toLowerCase() == 'admin';
      } else {
        print("User not found in database.");
        return false;
      }
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      final user = await _userService.getUser(uid);

      if (user != null) {
        return user.role?.toLowerCase();
      } else {
        print("User not found in database.");
        return null;
      }
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  String? get userId {
    return FirebaseAuth.instance.currentUser?.uid;
  }


  // Fetch current user's data from Firestore
  Future<app_user.UserModel?> getCurrentUserData() async {
    try {
      // Get the current logged-in user
      User? user = _auth.currentUser;

      if (user != null) {
        // Fetch user data from Firestore using the user's UID
        app_user.UserModel? userModel = await _userService.getUser(user.uid);

        if (userModel != null) {
          print("Fetched User Data: $userModel");
          return userModel;
        } else {
          print("User not found in Firestore.");
          return null;
        }
      } else {
        print("No user is currently logged in.");
        return null;
      }
    } catch (e) {
      print("Error fetching current user data: $e");
      return null;
    }
  }


  // Check if user is logged in
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<String?> getUserName(String uid) async {
    try {
      final user = await _userService.getUser(uid);
      if (user != null) {
        return user.userName;
      } else {
        print("User not found in database.");
        return null;
      }
    } catch (e) {
      print("Error fetching user name: $e");
      return null;
    }
  }


  // Get current user
  User? get currentUser => _auth.currentUser;

  // Create a new user in Firebase Auth and Firestore
  Future<void> createUser(String email, String password, app_user.UserModel user) async {
    try {
      // Create the user with Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update the user model with the Firebase UID
      final newUser = app_user.UserModel(
        userId: userCredential.user!.uid,
        userName: user.userName,
        userEmail: user.userEmail,
        userImage: user.userImage,
        userPhone: user.userPhone,
        userAddress: user.userAddress,
        gender: user.gender,
        dob: user.dob,
        plan: user.plan,
        status: user.status,
        otp: user.otp,
        fcmToken: user.fcmToken,
        role: user.role,
        notification: user.notification ?? [],
        bookmarks: user.bookmarks ?? [],
        myPlants: user.myPlants ?? [],
        diagnosisHistory: user.diagnosisHistory ?? [],
        postArticle: user.postArticle ?? [],
      );

      // Store the updated user model in Firestore
      await _userService.createUser(newUser);
      print("User created successfully: ${newUser.userId}");
    } catch (e) {
      print("Error creating user: $e");
      rethrow;
    }
  }

}
