import 'package:image_picker/image_picker.dart';

abstract class AbstractPlantDiseaseRepository {
  Future<List<String>> detectPlantDisease(XFile image);
}

class GeminiPlantDiseaseRepository implements AbstractPlantDiseaseRepository {
  @override
  Future<List<String>> detectPlantDisease(XFile image) async {
    // Simulate API call or logic to detect diseases.
    return Future.delayed(const Duration(seconds: 2), () => ['Disease 1', 'Disease 2']);
  }
}
