// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:leafora/firebase_database_dir/service/user_service.dart';
// import '../firebase_database_dir/models/user.dart' as app_user;
//
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseService _databaseService = DatabaseService();
//
//   // Stream for auth state changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   // Sign in method
//   Future<app_user.UserModel?> signIn(String email, String password) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//
//       // Fetch user details from the database
//       app_user.UserModel? user = await _databaseService.getUser(userCredential.user!.uid);
//
//       if (user != null) {
//         // Print the user data after fetching from Firestore
//         print("User Data from Firestore: ${user}");
//       } else {
//         print("User not found in Firestore.");
//       }
//
//       return user;
//     } catch (e) {
//       print("Sign-in error: $e");
//       rethrow;
//     }
//   }
//
//   // Sign out method
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       print("Sign-out error: $e");
//       rethrow;
//     }
//   }
//
//   // Check if the user is an admin
//   Future<bool> isAdmin(String uid) async {
//     try {
//       final user = await _databaseService.getUser(uid);
//       if (user != null) {
//         // Check if user has 'admin' role
//         return user.role.toLowerCase() == 'admin';
//       } else {
//         print("User not found in database.");
//         return false;
//       }
//     } catch (e) {
//       print("Error checking admin status: $e");
//       return false;
//     }
//   }
//
//   Future<String?> getUserRole(String uid) async {
//     try {
//       final user = await _databaseService.getUser(uid);
//
//       if (user != null) {
//         return user.role.toLowerCase();
//       } else {
//         print("User not found in database.");
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching user role: $e");
//       return null;
//     }
//   }
//
//   // Check if user is logged in
//   Future<User?> getCurrentUser() async {
//     return _auth.currentUser;
//   }
//
//   Future<String?> getUserName(String uid) async {
//     try {
//       final user = await _databaseService.getUser(uid);
//       if (user != null) {
//         return user.name; // Assuming 'name' is a field in the UserModel
//       } else {
//         print("User not found in database.");
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching user name: $e");
//       return null;
//     }
//   }
//
//
//   // Get current user
//   User? get currentUser => _auth.currentUser;
//
//   // Create a new user in Firebase Auth and Firestore
//   Future<void> createUser(String email, String password, app_user.UserModel user) async {
//     try {
//       // Create the user with Firebase Auth
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//
//       // Set the Firebase UID in the UserModel
//       user.userId = userCredential.user!.uid;
//
//       // Now store the user in Firestore with the userId
//       await _databaseService.createUser(userCredential.user!.uid, user);
//       print("User created successfully: ${user.name}");
//     } catch (e) {
//       print("Error creating user: $e");
//       rethrow;
//     }
//   }
// }
