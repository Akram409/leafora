import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/plant.dart';

class PlantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPlant(PlantModel plant) async {
    await _firestore.collection('plants').doc(plant.plantId).set(plant.toJson());
  }

  Future<PlantModel?> getPlant(String plantId) async {
    DocumentSnapshot doc = await _firestore.collection('plants').doc(plantId).get();
    if (doc.exists) {
      return PlantModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updatePlant(String plantId, Map<String, dynamic> updates) async {
    await _firestore.collection('plants').doc(plantId).update(updates);
  }

  Future<void> deletePlant(String plantId) async {
    await _firestore.collection('plants').doc(plantId).delete();
  }

  Stream<List<PlantModel>> getAllPlantsStream() {
    return _firestore.collection('plants').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return PlantModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

}
