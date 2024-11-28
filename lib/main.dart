import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:leafora/components/authentication/splash_screen.dart';
import 'package:leafora/layout/home_page.dart';


void main() async {
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Load environment variables
//   await dotenv.load(fileName: ".env");
//   // Print environment variables to confirm they're loaded
//   print("API Key: ${dotenv.env['FIREBASE_API_KEY']}");
//   print("App ID: ${dotenv.env['FIREBASE_APP_ID']}");
//   print("Project ID: ${dotenv.env['FIREBASE_PROJECT_ID']}");
//   // Initialize Firebase
//   try {
//     await Firebase.initializeApp(
//       name: "student-management-96e8a",
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   } catch (e) {
//     print('Error initializing Firebase: $e');
//   }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LeaFora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: HomePage(),
    );
  }
}