class PlantModel {
  final String plantId;
  final String plantImage;
  final String plantName;
  final String scientificName;
  final String plantType;
  final String genus;
  final String plantDescription;
  final List<Map<String, String>> conditions;
  final List<Map<String, String>> care;
  final String commonDisease;
  final String specialFeature;
  final String uses;
  final String funFact;
  final int helpful;
  final int notHelpful;
  final String authorId;
  final String authorName;
  final String? authorImage;

  PlantModel({
    required this.plantId,
    required this.plantImage,
    required this.plantName,
    required this.scientificName,
    required this.plantType,
    required this.genus,
    required this.plantDescription,
    required this.conditions,
    required this.care,
    required this.commonDisease,
    required this.specialFeature,
    required this.uses,
    required this.funFact,
    required this.helpful,
    required this.notHelpful,
    required this.authorId,
    required this.authorName,
    this.authorImage,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      plantId: json['plantId'],
      plantImage: json['plantImage'] ?? "",
      plantName: json['plantName'],
      scientificName: json['scientificName'],
      plantType: json['plantType'],
      genus: json['genus'],
      plantDescription: json['plantDescription'],
      conditions: List<Map<String, String>>.from(
        json['conditions'].map((condition) => Map<String, String>.from(condition)),
      ),
      care: List<Map<String, String>>.from(
        json['care'].map((careItem) => Map<String, String>.from(careItem)),
      ),
      commonDisease: json['common_disease'],
      specialFeature: json['specialFeature'],
      uses: json['uses'],
      funFact: json['funFact'],
      helpful: json['helpful'],
      notHelpful: json['not_helpful'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantId': plantId,
      'plantImage': plantImage,
      'plantName': plantName,
      'scientificName': scientificName,
      'plantType': plantType,
      'genus': genus,
      'plantDescription': plantDescription,
      'conditions': conditions,
      'care': care,
      'common_disease': commonDisease,
      'specialFeature': specialFeature,
      'uses': uses,
      'funFact': funFact,
      'helpful': helpful,
      'not_helpful': notHelpful,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
    };
  }
}
