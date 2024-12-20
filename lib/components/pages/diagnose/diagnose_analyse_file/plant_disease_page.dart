import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafora/components/pages/diagnose/diagnose_file/plant_disease_cubit.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/components/shared/widgets/custom_toast.dart';
import 'package:leafora/components/shared/widgets/loading_indicator.dart';
import 'package:leafora/firebase_database_dir/models/diagnosis.dart';
import 'package:leafora/firebase_database_dir/service/diagnosis_service.dart';
import 'package:leafora/services/auth_service.dart';
import 'package:leafora/services/google_translator/google_translator_service.dart';
import 'package:lottie/lottie.dart';
import 'package:leafora/services/cloudinary_service.dart';

class PlantDiseasePage extends StatefulWidget {
  const PlantDiseasePage({super.key});

  @override
  _PlantDiseasePageState createState() => _PlantDiseasePageState();
}

class _PlantDiseasePageState extends State<PlantDiseasePage> {
  bool _isLoading = false;
  bool _translateResults = false;
  Map<String, String> _translatedCache = {};

  void _saveDiagnosis(
    BuildContext context,
    List<String> diseaseInfo,
    PlantDiseaseDetected state,
    String diseaseName,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get the current user
      final authService = AuthService();
      final user = authService.currentUser;

      if (user == null) {
        throw Exception("No user is currently logged in.");
      }

      // Create a unique ID for the diagnosis
      final diagnosisId = DateTime.now().millisecondsSinceEpoch.toString();

      // Convert the list of diseaseInfo into a single string
      final diagnosisResults = diseaseInfo.join("\n");

      // Convert XFile to FilePickerResult
      final filePickerResult = FilePickerResult([
        PlatformFile(
          name: state.image.name,
          path: state.image.path,
          size: File(state.image.path).lengthSync(),
        )
      ]);

      // Upload image to Cloudinary
      dynamic imageUrl = await uploadToCloudinary(filePickerResult);

      // Build the DiagnosisModel
      final diagnosis = DiagnosisModel(
        diagnosisId: diagnosisId,
        diagnosisName: diseaseName,
        diagnosisType: "disease",
        diagnosisImage: imageUrl,
        diagnosisResults: diagnosisResults,
        userId: user.uid,
        checkAt: DateTime.now().toIso8601String(),
      );

      // Save the diagnosis to Firestore
      final diagnosisService = DiagnosisService();
      await diagnosisService.createDiagnosis(diagnosis);

      // Show success message
      CustomToast.show(
        "Diagnosis saved successfully!",
        bgColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      // Handle errors
      CustomToast.show(
        "Failed to save diagnosis: ${e.toString()}",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Modify the translate function to cache results
  Future<String> _translateText(String text) async {
    try {
      if (_translateResults) {
        // Check if we already have a translation
        if (_translatedCache.containsKey(text)) {
          return _translatedCache[text]!;
        }

        GoogleTranslatorService translator = GoogleTranslatorService();
        final translatedText = await translator.translate(text, "bn");
        // Cache the result
        _translatedCache[text] = translatedText;
        return translatedText;
      } else {
        // Clear cache when translations are disabled
        _translatedCache.clear();
        return text;
      }
    } catch (e) {
      print("Translation error: $e");
      return text;
    }
  }

  // Modify the toggle handler
  void _handleTranslateToggle(bool value) {
    setState(() {
      _translateResults = value;
      if (!value) {
        // Clear cached translations when toggled off
        _translatedCache.clear();
      }
    });
  }

  String _extractDiseaseName(String diseaseText) {
    final diseaseLines = diseaseText.split('\n');
    return diseaseLines.isNotEmpty ? diseaseLines.first : "Unknown Disease";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: screenWidth * 0.10,
        title: Center(
          child: Text(
            "Plant Disease Detect",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Switch(
            value: _translateResults,
            onChanged: _handleTranslateToggle,
            activeTrackColor: Colors.green,
            activeColor: Colors.green,
          ),
        ],
      ),
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
    // Ensure `currentState` is of type `PlantDiseaseDetected`
    if (currentState is! PlantDiseaseDetected) {
      return Center(
        child: Text(
          'Unexpected state: Unable to display results.',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Extract the disease name from the first element of the `diseaseInfo` list
    final diseaseText = diseaseInfo.first;
    final diseaseName = _extractDiseaseName(diseaseText);

    return ListView(
      children: [
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
        FutureBuilder<String>(
          future: _translateText(diseaseText),
          builder: (context, snapshot) {
            if (_translateResults &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CustomLoader2(
                lottieAsset: 'assets/images/loader.json',
                size: 80,
              ));
            }

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            return MarkdownBody(
              data: snapshot.data ?? diseaseText,
              shrinkWrap: true,
              onTapLink: (text, href, title) {
                // Handle link taps if needed
              },
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                p: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _isLoading
            ? CustomLoader(color: Colors.green, size: 40.0)
            : ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Diagnosis',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => _saveDiagnosis(
                    context, diseaseInfo, currentState, diseaseName),
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
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.restart_alt_outlined),
          label: const Text(
            'Detect Another Plant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            _translateResults = false;
            context.read<PlantDiseaseCubit>().resetState();
          },
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
