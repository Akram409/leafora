// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:leafora/components/shared/widgets/custom_toast.dart';
// import 'package:leafora/components/shared/widgets/loading_indicator.dart';
// import 'package:leafora/firebase_database_dir/models/user.dart';
// import 'package:leafora/services/cloudinary_service.dart';
// import 'package:leafora/services/notification_service.dart';
// import '../../../services/auth_service.dart';
// import 'login_screen.dart';
//
// class SignupScreen extends StatefulWidget {
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final AuthService _authService = AuthService();
//   // For Upload Image in Cloudinary
//   FilePickerResult? _filePickerResult;
//
//   void _openFilePicker() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//         allowedExtensions: ["jpg", "jpeg", "png", "mp4"],
//         type: FileType.custom);
//     setState(() {
//       _filePickerResult = result;
//     });
//   }
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _universityIdController = TextEditingController();
//   final TextEditingController _semesterController = TextEditingController();
//   final TextEditingController _sectionController = TextEditingController();
//   final TextEditingController _departmentController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//
//   bool _isLoading = false;
//
//   Future<void> _signup() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         Map<String, String>? userImage;
//
//         // Upload the image if a file is selected
//         if (_filePickerResult != null) {
//           userImage = await uploadToCloudinary(_filePickerResult);
//
//           if (userImage == null) {
//             CustomToast.show(
//               "❌ Failed to upload image. Please try again.",
//               bgColor: Colors.red,
//               textColor: Colors.white,
//             );
//             setState(() {
//               _isLoading = false;
//             });
//             return;
//           }
//         }
//         // Retrieve FCM token
//         final fcmToken = await NotificationService.instance.getToken();
//         print("from signup page: ${fcmToken}");
//
//         final userModel = UserModel(
//           name: _nameController.text.trim(),
//           universityId: _universityIdController.text.trim(),
//           semester: int.parse(_semesterController.text.trim()),
//           section: _sectionController.text.trim(),
//           department: _departmentController.text.trim(),
//           email: _emailController.text.trim(),
//           phoneNumber: _phoneController.text.trim(),
//           age: int.parse(_ageController.text.trim()),
//           role: 'student',
//           userImage: userImage,
//           fcmToken: fcmToken,
//         );
//
//         await _authService.createUser(
//           _emailController.text.trim(),
//           _passwordController.text.trim(),
//           userModel,
//         );
//
//         CustomToast.show(
//           "🎉 Signup Successful!",
//           bgColor: Colors.green,
//           textColor: Colors.white,
//         );
//
//         Get.offAll(() => LoginScreen());
//       } catch (e) {
//         CustomToast.show(
//           "❌ Signup failed: ${e.toString()}",
//           bgColor: Colors.red,
//           textColor: Colors.white,
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a password';
//     } else if (value.length < 6) {
//       return 'Password must be at least 6 characters long';
//     } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$')
//         .hasMatch(value)) {
//       return 'Password must contain letters and numbers';
//     }
//     return null;
//   }
//
//   String? _validateField(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter $fieldName';
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16.0,25,16,0),
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
//                     children: [
//                       Text(
//                         'Sign Up',
//                         style: GoogleFonts.lobster(
//                           fontSize: 36,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.blueAccent,
//                           letterSpacing: 1.5,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       GestureDetector(
//                         onTap: _openFilePicker,
//                         child: CircleAvatar(
//                           radius: 60,
//                           backgroundColor: Colors.grey[200],
//                           child: ClipOval(
//                             child: _filePickerResult != null
//                                 ? Image.file(
//                               File(_filePickerResult!.files.single.path!),
//                               fit: BoxFit.cover,
//                               width: 120,
//                               height: 120,
//                             )
//                                 : Image.asset(
//                               "assets/images/profile.png",
//                               fit: BoxFit.cover,
//                               width: 120,
//                               height: 120,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Name',
//                           prefixIcon: Icon(Icons.person),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         validator: (value) => _validateField(value, 'name'),
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: _universityIdController,
//                         decoration: InputDecoration(
//                           labelText: 'University ID',
//                           prefixIcon: Icon(Icons.school),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         validator: (value) => _validateField(value, 'university ID'),
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: _semesterController,
//                         decoration: InputDecoration(
//                           labelText: 'Semester',
//                           prefixIcon: Icon(Icons.calendar_month),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) => _validateField(value, 'semester'),
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: _sectionController,
//                         decoration: InputDecoration(
//                           labelText: 'Section',
//                           prefixIcon: Icon(Icons.group),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         validator: (value) => _validateField(value, 'section'),
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: _departmentController,
//                         decoration: InputDecoration(
//                           labelText: 'Department',
//                           prefixIcon: Icon(Icons.account_balance),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         validator: (value) => _validateField(value, 'department'),
//                       ),
//                       SizedBox(height: 10),
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
//                         validator: (value) => _validateField(value, 'email'),
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
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: _phoneController,
//                         decoration: InputDecoration(
//                           labelText: 'Phone Number',
//                           prefixIcon: Icon(Icons.phone),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         keyboardType: TextInputType.phone,
//                         validator: (value) => _validateField(value, 'phone number'),
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: _ageController,
//                         decoration: InputDecoration(
//                           labelText: 'Age',
//                           prefixIcon: Icon(Icons.cake),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) => _validateField(value, 'age'),
//                       ),
//                       SizedBox(height: 20),
//                       _isLoading
//                           ? CustomLoader(color: Colors.greenAccent, size: 40.0)
//                           : ElevatedButton(
//                         onPressed: _signup,
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             side: BorderSide(
//                                 color: Colors.blueAccent, width: 2),
//                           ),
//                         ),
//                         child: Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.2,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           // Using Get.offAll to navigate to the LoginScreen
//                           Get.offAll(() => LoginScreen());
//                         },
//                         child: Text("Already have an account? Login"),
//                       ),
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
