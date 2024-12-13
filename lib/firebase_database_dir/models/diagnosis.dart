class DiagnosisModel {
  final String diagnosisId;
  Map<String, String>? diagnosisImage;
  final String diagnosisResults;
  final String userId;
  final String checkAt;

  DiagnosisModel({
    required this.diagnosisId,
    required this.diagnosisImage,
    required this.diagnosisResults,
    required this.userId,
    required this.checkAt,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      diagnosisId: json['diagnosisId'],
      diagnosisImage: json['diagnosisImage'] != null
          ? Map<String, String>.from(json['diagnosisImage'])
          : null,
      diagnosisResults: json['diagnosisResults'],
      userId: json['userId'],
      checkAt: json['checkAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diagnosisId': diagnosisId,
      'diagnosisImage': diagnosisImage,
      'diagnosisResults': diagnosisResults,
      'userId': userId,
      'checkAt': checkAt,
    };
  }
}
