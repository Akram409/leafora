import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/disease.dart';

class DiseaseDetails extends StatefulWidget {
  const DiseaseDetails({super.key});

  @override
  State<DiseaseDetails> createState() => _DiseaseDetailsState();
}

class _DiseaseDetailsState extends State<DiseaseDetails> {
  late final QuillController _descriptionController;
  late DiseaseModel diseaseData;

  @override
  void initState() {
    super.initState();

    diseaseData = Get.arguments as DiseaseModel;

    // Ensure the last operation ends with a newline
    List<dynamic> ops = diseaseData.description.ops.map((op) => op.toJson()).toList();
    if (ops.isNotEmpty && !(ops.last['insert'] as String).endsWith('\n')) {
      ops.last['insert'] = (ops.last['insert'] as String) + '\n';
    }

    _descriptionController = QuillController(
      document: Document.fromJson(ops),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.05;
    return Scaffold(
      appBar: CustomAppBar3(title: "Disease Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Disease Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: diseaseData.diseaseImage.isNotEmpty
                      ? diseaseData.diseaseImage
                      : 'default_image_url',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                  placeholder: (context, url) => const CustomLoader2(
                    lottieAsset: 'assets/images/loader.json',
                    size: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

              const SizedBox(height: 10),

              // Padding for Disease Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quill Description
                    QuillEditor.basic(
                      controller: _descriptionController,
                      focusNode: FocusNode(),
                    ),

                    const SizedBox(height: 16),

                    Divider(color: Colors.black, thickness: 1),
                    Text(
                      "Was this helpful?",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Increment the helpful count or send a feedback action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Thank you for your feedback!"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.black),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Increment the not helpful count or send a feedback action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Thank you for your feedback!"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.black),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
