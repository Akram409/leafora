class UserModel {
  final String userId;
  final String userName;
  final String userEmail;
  final String userImage;
  final String userPhone;
  final String userAddress;
  final String gender;
  final String dob;
  final bool plan;
  final bool status;
  final int? otp;
  final String fcmToken;
  final String role;
  final List<String>? notification;
  final List<String>? bookmarks;
  final List<Map<String, String>>? myPlants;
  final List<String>? diagnosisHistory;
  final List<String>? postArticle;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.userPhone,
    required this.userAddress,
    required this.gender,
    required this.dob,
    required this.plan,
    required this.status,
    this.otp,
    required this.fcmToken,
    required this.role,
    this.notification,
    this.bookmarks,
    this.myPlants,
    this.diagnosisHistory,
    this.postArticle,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      userImage: json['userImage'] ?? "",
      userPhone: json['userPhone'],
      userAddress: json['userAddress'] ?? "",
      gender: json['gender'],
      dob: json['dob'],
      plan: json['plan'],
      status: json['status'],
      otp: json['otp'],
      fcmToken: json['fcm_token'] ?? "",
      role: json['role'],
      notification: json['notification'] != null ? List<String>.from(json['notification']) : null,
      bookmarks: json['bookmarks'] != null ? List<String>.from(json['bookmarks']) : null,
      myPlants: json['my_plants'] != null
          ? List<Map<String, String>>.from(json['my_plants'].map((plant) => Map<String, String>.from(plant)))
          : null,
      diagnosisHistory: json['diagnosis_history'] != null ? List<String>.from(json['diagnosis_history']) : null,
      postArticle: json['post_article'] != null ? List<String>.from(json['post_article']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userImage': userImage,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'gender': gender,
      'dob': dob,
      'plan': plan,
      'status': status,
      'otp': otp,
      'fcm_token': fcmToken,
      'role': role,
      'notification': notification,
      'bookmarks': bookmarks,
      'my_plants': myPlants,
      'diagnosis_history': diagnosisHistory,
      'post_article': postArticle,
    };
  }
}
