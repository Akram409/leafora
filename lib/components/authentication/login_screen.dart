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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                          letterSpacing: 1.5,
                        ),
                      ),

                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CustomLoader(color: Colors.greenAccent, size: 50.0)
                          : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                        child: Text('Login'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => SignupScreen(),

                              transition: Transition.rightToLeft, duration: Duration(milliseconds: 500));
                        },
                        child: Text("Don't have an account? Sign Up"),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
