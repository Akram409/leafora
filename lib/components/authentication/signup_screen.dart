import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:leafora/components/shared/widgets/custom_toast.dart';
import 'package:leafora/components/shared/widgets/loading_indicator.dart';
import 'package:leafora/firebase_database_dir/models/user.dart';
import 'package:leafora/services/cloudinary_service.dart';
import 'package:leafora/services/notification_service.dart';
import '../../../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  FilePickerResult? _filePickerResult;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png"],
        type: FileType.custom);
    setState(() {
      _filePickerResult = result;
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Map<String, String>? userImage;

        // Upload the image if a file is selected
        if (_filePickerResult != null) {
          dynamic uploadedImage = await uploadToCloudinary(_filePickerResult);
          if (uploadedImage != null) {
            userImage = uploadedImage;
          } else {
            CustomToast.show(
              "❌ Failed to upload image. Please try again.",
              bgColor: Colors.red,
              textColor: Colors.white,
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }

        // Retrieve FCM token
        final fcmToken = await NotificationService.instance.getToken();

        final userModel = UserModel(
          userName: _nameController.text.trim(),
          userEmail: _emailController.text.trim(),
          userImage: userImage,
          userPhone: _phoneController.text.trim(),
          userAddress: "",
          gender: _genderController.text.trim(),
          dob: _dobController.text.trim(),
          plan: "basic",
          status: "unverified",
          otp: null,
          fcmToken: fcmToken ?? "",
          role: 'user',
          notification: [],
          bookmarks: [],
          myPlants: [],
          diagnosisHistory: [],
          postArticle: [],
        );


        await _authService.createUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          userModel,
        );

        CustomToast.show(
          "🎉 Signup Successful!",
          bgColor: Colors.green,
          textColor: Colors.white,
        );

        Get.offAll(() => LoginScreen());
      } catch (e) {
        CustomToast.show(
          "❌ Signup failed: ${e.toString()}",
          bgColor: Colors.red,
          textColor: Colors.white,
        );
        print(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  @override
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
          // Signup Content
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
                        image: AssetImage('assets/images/login_card_bg.jpg'),
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
                              'Sign Up',
                              style: GoogleFonts.lobster(
                                fontSize: MediaQuery.sizeOf(context).width * 0.15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _openFilePicker,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[200],
                                child: ClipOval(
                                  child: _filePickerResult != null
                                      ? Image.file(
                                    File(_filePickerResult!.files.single.path!),
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  )
                                      : Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(_nameController, 'Name', Icons.person),
                            const SizedBox(height: 10),
                            _buildTextField(_emailController, 'Email', Icons.email),
                            const SizedBox(height: 10),
                            _buildTextField(_passwordController, 'Password', Icons.lock,
                                obscureText: true),
                            const SizedBox(height: 10),
                            _buildTextField(_phoneController, 'Phone Number', Icons.phone),
                            const SizedBox(height: 10),
                            _buildTextField(_dobController, 'Date of Birth', Icons.cake),
                            const SizedBox(height: 10),
                            _buildTextField(_genderController, 'Gender', Icons.transgender),
                            const SizedBox(height: 20),
                            _isLoading
                                ? CustomLoader(color: Colors.green, size: 40.0)
                                : ElevatedButton(
                              onPressed: _signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: Colors.green[800]!,
                                    width: 2,
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
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: MediaQuery.sizeOf(context).width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.offAll(() => LoginScreen()),
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
                                      text: "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Login",
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

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon),
        prefixIconColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.green,
            width: 2,
            // shape: Box Border
          ),
        ),
      ),
    );
  }
}
