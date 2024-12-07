class DiseaseTypeModel {
  final String diseaseTypeName;
  final Map<String, Disease> diseases;

  DiseaseTypeModel({required this.diseaseTypeName, required this.diseases});

  factory DiseaseTypeModel.fromJson(Map<String, dynamic> json, String diseaseTypeName) {
    var diseases = <String, Disease>{};
    if (json['diseases'] != null) {
      json['diseases'].forEach((key, value) {
        diseases[key] = Disease.fromJson(value);
      });
    }
    return DiseaseTypeModel(
      diseaseTypeName: diseaseTypeName,
      diseases: diseases,
    );
  }

  // Convert the model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'diseaseTypeName': diseaseTypeName,
      'diseases': diseases.map((key, disease) => MapEntry(key, disease.toJson())),
    };
  }
}

class Disease {
  final String diseaseId;

  Disease({required this.diseaseId});

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['diseaseId'] ?? '',
    );
  }

  // Convert the Disease model to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'diseaseId': diseaseId,
    };
  }
}
