import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafora/components/shared/widgets/custom_toast.dart';
import 'package:leafora/components/shared/widgets/loading_indicator.dart';
import 'package:leafora/layout/home_page.dart';
import '../../../services/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();


  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          String? role = await _authService.getUserRole(user.userId!);
          if (role != null) {
            switch (role) {
              case 'admin':
                CustomToast.show(
                  'Login Successful - Admin!',
                  bgColor: Colors.green,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                );
                Get.offAll(() => HomePage(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 500));
                break;
              case 'experts':
                CustomToast.show(
                  'Login Successful - Driver!',
                  bgColor: Colors.greenAccent,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                );
                Get.offAll(() => HomePage(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 500));
                break;
              case 'user':
                CustomToast.show(
                  'Login Successful - Welcome!!',
                  bgColor: Colors.blue,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                );
                Get.offAll(() => HomePage(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 500));
                break;
              default:
                CustomToast.show(
                  "⚠️ Error: Unknown role!",
                  bgColor: Colors.orange,
                  textColor: Colors.white,
                );
                break;
            }
          } else {
            CustomToast.show(
              "⚠️ Error: User role not found!",
              bgColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } else {
          CustomToast.show(
            "⚠️ Error: User not found!",
            bgColor: Colors.orange,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        String errorMessage;
        print(e.toString());
        switch (e) {
          case "user_not_found":
            errorMessage = "⚠️ Error: User not found!";
            break;
          case "incorrect_password":
            errorMessage = "❌ Error: Incorrect password!";
            break;
          case "network_error":
            errorMessage = "🌐 Error: Network issue. Please try again!";
            break;
          default:
            errorMessage = "❌ Credential is incorrect";
        }

        CustomToast.show(
          errorMessage,
          bgColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Login Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 9.0,
                  shadowColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg4.png'),
                        fit: BoxFit.cover,

                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.2),
                          BlendMode.lighten,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: GoogleFonts.lobster(
                                fontSize: MediaQuery.sizeOf(context).width * 0.15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                                ),
                                prefixIcon: Icon(Icons.email),
                                prefixIconColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                    style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                    style: BorderStyle.solid
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200]?.withOpacity(0.5),
                              ),
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500
                                ),
                                prefixIcon: Icon(Icons.lock),
                                prefixIconColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200]?.withOpacity(0.5),
                              ),
                              obscureText: true,
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 20),
                            _isLoading
                                ? CustomLoader(color: Colors.greenAccent, size: 50.0)
                                : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 12
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                      color: Colors.green[800]!,
                                      width: 2
                                  ),
                                ),
                                elevation: 2,
                                shadowColor: Colors.green[900],
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.3,
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: MediaQuery.sizeOf(context).width * 0.05,
                                  color: Colors.white, // Ensure white text
                                  fontWeight: FontWeight.w600, // Semi-bold weight
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => SignupScreen(),
                                    transition: Transition.rightToLeft,
                                    duration: const Duration(milliseconds: 500));
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green[700],
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Don't have an account? ",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Sign Up",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}