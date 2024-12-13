import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leafora/firebase_database_dir/models/diagnosis.dart';

class DiagnosisService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDiagnosis(DiagnosisModel diagnosis) async {
    await _firestore.collection('diagnoses').doc(diagnosis.diagnosisId).set(diagnosis.toJson());
  }

  Future<DiagnosisModel?> getDiagnosis(String diagnosisId) async {
    DocumentSnapshot doc = await _firestore.collection('diagnoses').doc(diagnosisId).get();
    if (doc.exists) {
      return DiagnosisModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateDiagnosis(String diagnosisId, Map<String, dynamic> updates) async {
    await _firestore.collection('diagnoses').doc(diagnosisId).update(updates);
  }

  Future<void> deleteDiagnosis(String diagnosisId) async {
    await _firestore.collection('diagnoses').doc(diagnosisId).delete();
  }
}
