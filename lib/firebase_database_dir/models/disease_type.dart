class DiseaseTypeModel {
  final String diseaseTypeName;
  final List<Map<String, String>> diseases;

  DiseaseTypeModel({
    required this.diseaseTypeName,
    required this.diseases,
  });

  factory DiseaseTypeModel.fromJson(String diseaseTypeName, Map<String, dynamic> json) {
    return DiseaseTypeModel(
      diseaseTypeName: diseaseTypeName,
      diseases: List<Map<String, String>>.from(
        json['diseases'].values.map((disease) => {'diseaseId': disease['diseaseId']}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseases': {
        for (var disease in diseases) disease['diseaseId']: {'diseaseId': disease['diseaseId']}
      },
    };
  }
}
