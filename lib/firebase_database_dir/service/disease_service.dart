import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/disease.dart';

class DiseaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDisease(DiseaseModel disease) async {
    await _firestore.collection('diseases').doc(disease.diseaseId).set(disease.toJson());
  }

  Future<DiseaseModel?> getDisease(String diseaseId) async {
    DocumentSnapshot doc = await _firestore.collection('diseases').doc(diseaseId).get();
    if (doc.exists) {
      return DiseaseModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateDisease(String diseaseId, Map<String, dynamic> updates) async {
    await _firestore.collection('diseases').doc(diseaseId).update(updates);
  }

  Future<void> deleteDisease(String diseaseId) async {
    await _firestore.collection('diseases').doc(diseaseId).delete();
  }

  Stream<List<DiseaseModel>> streamAllDiseases() {
    return _firestore.collection('diseases').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return DiseaseModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Stream filtered by diseaseType
  Stream<List<DiseaseModel>> streamDiseasesByType(String diseaseType) {
    return _firestore
        .collection('diseases')
        .where('diseaseType', isEqualTo: diseaseType)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return DiseaseModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

// Stream filtered by diseaseName
  Stream<List<DiseaseModel>> getFilteredDiseasesStream(String query) {
    return _firestore
        .collection('diseases')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DiseaseModel.fromJson(doc.data() as Map<String, dynamic>);
      }).where((disease) {
        final lowerCaseQuery = query.toLowerCase();
        return disease.diseaseName.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }
}
