import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/disease_type.dart';

class DiseaseTypeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all disease types
  Future<List<DiseaseTypeModel>> fetchDiseaseTypes() async {
    try {
      final snapshot = await _firestore.collection('disease_types').get();
      return snapshot.docs.map((doc) {
        return DiseaseTypeModel.fromJson(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Error fetching disease types: $e');
    }
  }

  // Add a new disease type
  Future<void> addDiseaseType(DiseaseTypeModel diseaseType) async {
    try {
      await _firestore.collection('disease_types').doc(diseaseType.diseaseTypeName).set(diseaseType.toJson());
    } catch (e) {
      throw Exception('Error adding disease type: $e');
    }
  }

  // Update an existing disease type
  Future<void> updateDiseaseType(DiseaseTypeModel diseaseType) async {
    try {
      await _firestore.collection('disease_types').doc(diseaseType.diseaseTypeName).update(diseaseType.toJson());
    } catch (e) {
      throw Exception('Error updating disease type: $e');
    }
  }

  // Delete a disease type
  Future<void> deleteDiseaseType(String diseaseTypeName) async {
    try {
      await _firestore.collection('disease_types').doc(diseaseTypeName).delete();
    } catch (e) {
      throw Exception('Error deleting disease type: $e');
    }
  }
}
