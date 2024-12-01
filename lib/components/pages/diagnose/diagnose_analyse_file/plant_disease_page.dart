import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafora/components/pages/diagnose/diagnose_file/plant_disease_cubit.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:lottie/lottie.dart';

class PlantDiseasePage extends StatelessWidget {
  const PlantDiseasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Plant Health Detector"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<PlantDiseaseCubit, PlantDiseaseState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildContent(context, state),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PlantDiseaseState state) {
    return switch (state) {
      PlantDiseaseInitial() => _buildImageUploadOptions(context),
      PlantDiseaseImageSelected() => _buildImagePreview(context, state.image),
      PlantDiseaseLoading() => _buildLoadingIndicator(context),
      PlantDiseaseDetected() =>
        _buildDiseaseResults(context, state.diseaseInfo),
      PlantDiseaseError() => _buildErrorView(context, state.error),
    };
  }

  Widget _buildImageUploadOptions(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.7,
            // height: 120,
            child: Lottie.asset(
              "assets/images/scan.json",
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Upload a Plant Image',
            style: GoogleFonts.lora(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text(
                  'Gallery',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => _pickImage(context, ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.4,
                    50,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text(
                  'Camera',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => _pickImage(context, ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.4,
                    50, // Minimum height
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      context.read<PlantDiseaseCubit>().setPicture(image);
    }
  }

  Widget _buildImagePreview(BuildContext context, XFile image) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(image.path),
            width: screenWidth * 1,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 26),
        ElevatedButton.icon(
          icon: const Icon(Icons.search),
          label: const Text(
            'Detect Plant Disease',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () =>
              context.read<PlantDiseaseCubit>().detectDisease(image),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 17),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.6,
              50,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton.icon(
          icon: const Icon(Icons.cancel_outlined),
          label: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => context.read<PlantDiseaseCubit>().resetState(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            textStyle: const TextStyle(fontSize: 17),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.4,
              50,
            ),
          ),
        ),
        TextButton(
          onPressed: () => context.read<PlantDiseaseCubit>().resetState(),
          child: const Text(
            '',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.9,
            child: Lottie.asset(
              "assets/images/finding.json",
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Analyzing Plant Health...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseResults(BuildContext context, List<String> diseaseInfo) {
    final currentState = context.read<PlantDiseaseCubit>().state;
    var screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        if (currentState is PlantDiseaseDetected) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(currentState.image.path),
              width: MediaQuery.of(context).size.width,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Markdown(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          data: diseaseInfo.first,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.restart_alt_outlined),
          label: const Text(
            'Detect Another Plant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => context.read<PlantDiseaseCubit>().resetState(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 17),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.4,
              50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, dynamic error) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.9,
            // height: 120,
            child: Lottie.asset(
              "assets/images/not-found.json",
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(error.toString()),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.repeat),
            label: const Text(
              'Try Again',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => context.read<PlantDiseaseCubit>().resetState(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              textStyle: const TextStyle(fontSize: 18),
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.4,
                50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
