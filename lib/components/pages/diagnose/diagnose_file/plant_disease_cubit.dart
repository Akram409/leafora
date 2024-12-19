import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafora/components/pages/diagnose/diagnose_file/plant_disease_repository.dart';
import 'package:meta/meta.dart';

part 'plant_disease_state.dart';

class PlantDiseaseCubit extends Cubit<PlantDiseaseState> {
  final AbstractPlantDiseaseRepository plantDiseaseRepository;

  PlantDiseaseCubit(this.plantDiseaseRepository) : super(PlantDiseaseInitial());

  void resetState() {

    emit(PlantDiseaseInitial());
  }

  void setPicture(XFile image) {
    emit(PlantDiseaseImageSelected(image: image));
  }

  Future<void> detectDisease(XFile image) async {
    try {
      emit(PlantDiseaseLoading());
      final results = await plantDiseaseRepository.detectPlantDisease(image);
      emit(PlantDiseaseDetected(image:image,diseaseInfo: results));
    } catch (e) {
      emit(PlantDiseaseError(error: e));
    }
  }
}
