part of 'plant_disease_cubit.dart';

@immutable
sealed class PlantDiseaseState {}

final class PlantDiseaseInitial extends PlantDiseaseState {}

final class PlantDiseaseImageSelected extends PlantDiseaseState {
  final XFile image;

  PlantDiseaseImageSelected({required this.image});
}

final class PlantDiseaseLoading extends PlantDiseaseState {}

final class PlantDiseaseDetected extends PlantDiseaseState {
  final XFile image;
  final List<String> diseaseInfo;

  PlantDiseaseDetected({required this.image, required this.diseaseInfo});
}

final class PlantDiseaseError extends PlantDiseaseState {
  final dynamic error;

  PlantDiseaseError({required this.error});
}
