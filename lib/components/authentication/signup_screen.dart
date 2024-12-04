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
                    children: [
                      Text(
                        'Sign Up',
                        style: GoogleFonts.lobster(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) => _validateField(value, 'name'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) => _validateField(value, 'email'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) => _validateField(value, 'password'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) => _validateField(value, 'phone number'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        validator: (value) => _validateField(value, 'date of birth'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _genderController,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.transgender),
                        ),
                        validator: (value) => _validateField(value, 'gender'),
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CustomLoader(color: Colors.green, size: 40.0)
                          : ElevatedButton(
                        onPressed: _signup,
                        child: Text('Sign Up'),
                      ),
                      TextButton(
                        onPressed: () => Get.offAll(() => LoginScreen()),
                        child: Text("Already have an account? Login"),
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
