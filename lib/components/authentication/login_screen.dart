// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:leafora/components/shared/widgets/custom_toast.dart';
// import '../../../services/auth_service.dart';
// import 'signup_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   final AuthService _authService = AuthService();
//
//
//
//
//
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//         .hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     } else if (value.length < 6) {
//       return 'Password must be at least 6 characters long';
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Card(
//               elevation: 4.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Login',
//                         style: GoogleFonts.lobster(
//                           fontSize: 36,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.blueAccent,
//                           letterSpacing: 1.5,
//                         ),
//                       ),
//
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           prefixIcon: Icon(Icons.email),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         validator: _validateEmail,
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: Icon(Icons.lock),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         obscureText: true,
//                         validator: _validatePassword,
//                       ),
//                       SizedBox(height: 20),
//                       _isLoading
//                           ? CustomLoader(color: Colors.greenAccent, size: 50.0)
//                           : ElevatedButton(
//                         onPressed: "",
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             side: BorderSide(color: Colors.blueAccent, width: 2),
//                           ),
//                         ),
//                         child: Text('Login'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Get.to(() => SignupScreen(),
//                               transition: Transition.rightToLeft, duration: Duration(milliseconds: 500));
//                         },
//                         child: Text("Don't have an account? Sign Up"),
//                       ),
//
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
