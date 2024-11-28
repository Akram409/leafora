class DiseaseModel {
  final String diseaseId;
  final String diseaseName;
  final String diseaseImage;
  final String overview;
  final String symptoms;
  final String causes;
  final String commonPests;
  final String treatmentAndManagement;
  final String prevention;
  final String conclusion;
  final int helpful;
  final int notHelpful;

  DiseaseModel({
    required this.diseaseId,
    required this.diseaseName,
    required this.diseaseImage,
    required this.overview,
    required this.symptoms,
    required this.causes,
    required this.commonPests,
    required this.treatmentAndManagement,
    required this.prevention,
    required this.conclusion,
    required this.helpful,
    required this.notHelpful,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      diseaseId: json['diseaseId'],
      diseaseName: json['diseaseName'],
      diseaseImage: json['diseaseImage'] ?? "",
      overview: json['overview'],
      symptoms: json['symptoms'],
      causes: json['causes'],
      commonPests: json['commonpests'],
      treatmentAndManagement: json['treatment_and_management'],
      prevention: json['prevention'],
      conclusion: json['conclusion'],
      helpful: json['helpful'],
      notHelpful: json['not_helpful'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseId': diseaseId,
      'diseaseName': diseaseName,
      'diseaseImage': diseaseImage,
      'overview': overview,
      'symptoms': symptoms,
      'causes': causes,
      'commonpests': commonPests,
      'treatment_and_management': treatmentAndManagement,
      'prevention': prevention,
      'conclusion': conclusion,
      'helpful': helpful,
      'not_helpful': notHelpful,
    };
  }
}
