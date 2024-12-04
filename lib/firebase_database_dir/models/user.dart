class UserModel {
  String? userName;
  String? userId;
  Map<String, String>? userImage;
  String? userEmail;
  String? userPhone;
  String? userAddress;
  String? gender;
  String? dob;
  String? plan;
  String? status;
  String? otp;
  String? fcmToken;
  String? role;
  List<String>? notification;
  List<String>? bookmarks;
  List<MyPlants>? myPlants;
  List<String>? diagnosisHistory;
  List<String>? postArticle;

  UserModel({
    this.userName,
    this.userId,
    this.userImage,
    this.userEmail,
    this.userPhone,
    this.userAddress,
    this.gender,
    this.dob,
    this.plan,
    this.status,
    this.otp,
    this.fcmToken,
    this.role,
    this.notification,
    this.bookmarks,
    this.myPlants,
    this.diagnosisHistory,
    this.postArticle,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
      userId: json['userId'],
      userImage: json['userImage'] != null
          ? Map<String, String>.from(json['userImage'])
          : null,
      userEmail: json['userEmail'],
      userPhone: json['userPhone'],
      userAddress: json['userAddress'],
      gender: json['gender'],
      dob: json['dob'],
      plan: json['plan'],
      status: json['status'],
      otp: json['otp'],
      fcmToken: json['fcm_token'],
      role: json['role'],
      notification: json['notification']?.cast<String>(),
      bookmarks: json['bookmarks']?.cast<String>(),
      myPlants: json['my_plants'] != null
          ? (json['my_plants'] as List)
          .map((plant) => MyPlants.fromJson(plant))
          .toList()
          : null,
      diagnosisHistory: json['diagnosis_history']?.cast<String>(),
      postArticle: json['post_article']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['userId'] = userId;
    data['userImage'] = userImage;
    data['userEmail'] = userEmail;
    data['userPhone'] = userPhone;
    data['userAddress'] = userAddress;
    data['gender'] = gender;
    data['dob'] = dob;
    data['plan'] = plan;
    data['status'] = status;
    data['otp'] = otp;
    data['fcm_token'] = fcmToken;
    data['role'] = role;
    data['notification'] = notification;
    data['bookmarks'] = bookmarks;
    if (myPlants != null) {
      data['my_plants'] = myPlants!.map((plant) => plant.toJson()).toList();
    }
    data['diagnosis_history'] = diagnosisHistory;
    data['post_article'] = postArticle;
    return data;
  }
}

class MyPlants {
  String? plantId;
  String? plantType;

  MyPlants({this.plantId, this.plantType});

  MyPlants.fromJson(Map<String, dynamic> json) {
    plantId = json['plantId'];
    plantType = json['plantType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantId'] = plantId;
    data['plantType'] = plantType;
    return data;
  }
}
