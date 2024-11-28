class PlantTypeModel {
  final String plantTypeName;
  final List<Map<String, String>> plants;

  PlantTypeModel({
    required this.plantTypeName,
    required this.plants,
  });

  // create a PlantType
  factory PlantTypeModel.fromJson(String plantTypeName, Map<String, dynamic> json) {
    return PlantTypeModel(
      plantTypeName: plantTypeName,
      plants: List<Map<String, String>>.from(
        json['plants'].entries.map((entry) => {'plantId': entry.key}),
      ),
    );
  }

  // Converts the PlantTypeModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'plants': {
        for (var plant in plants) plant['plantId']: {'plantId': plant['plantId']},
      },
    };
  }
}
