import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/plant_type.dart';

class PlantTypeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all plant types
  Future<List<PlantTypeModel>> fetchPlantTypes() async {
    try {
      final snapshot = await _firestore.collection('plant_types').get();
      return snapshot.docs.map((doc) {
        return PlantTypeModel.fromJson(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error fetching plant types: $e');
    }
  }

  // Add a new plant type
  Future<void> addPlantType(PlantTypeModel plantType) async {
    try {
      await _firestore.collection('plant_types').doc(plantType.plantTypeName).set(plantType.toJson());
    } catch (e) {
      throw Exception('Error adding plant type: $e');
    }
  }

  // Update an existing plant type
  Future<void> updatePlantType(PlantTypeModel plantType) async {
    try {
      await _firestore.collection('plant_types').doc(plantType.plantTypeName).update(plantType.toJson());
    } catch (e) {
      throw Exception('Error updating plant type: $e');
    }
  }

  // Delete a plant type
  Future<void> deletePlantType(String plantTypeName) async {
    try {
      await _firestore.collection('plant_types').doc(plantTypeName).delete();
    } catch (e) {
      throw Exception('Error deleting plant type: $e');
    }
  }
}
