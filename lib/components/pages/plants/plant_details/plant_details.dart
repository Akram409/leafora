import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/plant.dart';

class PlantDetails extends StatefulWidget {
  const PlantDetails({super.key});

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  late final QuillController _descriptionController;
  late PlantModel plantData;

  @override
  void initState() {
    super.initState();

    // Get the plant data passed from the previous screen
    plantData = Get.arguments as PlantModel;

    // Ensure the last operation ends with a newline
    List<dynamic> ops = plantData.description?.ops?.map((op) {
      return {
        'insert': op.insert,
        if (op.attributes != null) 'attributes': op.attributes?.toJson(),
      };
    }).toList() ?? [];

    if (ops.isNotEmpty && !(ops.last['insert'] as String).endsWith('\n')) {
      ops.last['insert'] = (ops.last['insert'] as String) + '\n';
    }

    // Initialize QuillController for displaying the description
    _descriptionController = QuillController(
      document: Document.fromJson(ops),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    TextStyle iconStyle = TextStyle(fontSize: 18, color: Colors.green);
    TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    TextStyle bodyStyle = TextStyle(fontSize: 16, color: Colors.black87);

    return Scaffold(
      appBar: CustomAppBar4(title: "Plant Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Plant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: plantData.plantImage ?? 'https://via.placeholder.com/250',
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

              // Plant Name and Scientific Name
              Text(
                plantData.plantName ?? "Unknown Plant",
                style: TextStyle(
                    fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Genus and Plant Type
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Genus",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Scientific Name",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ":  ${plantData.genus ?? 'N/A'}",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ":  ${plantData.scientificName ?? 'N/A'}",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Divider(
                thickness: 1,
              ),

              const SizedBox(height: 16),

              // Plant Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: screenWidth * 0.065,
                        color: Colors.greenAccent,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: screenWidth * 0.055,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plantData.plantDescription ?? "No description available.",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.black54,
                    ),
                    // maxLines: 3,
                    // overflow: TextOverflow.ellipsis, // Use ellipsis for overflow text
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quill Description
              QuillEditor.basic(
                controller: _descriptionController,
                focusNode: FocusNode(),
                configurations: QuillEditorConfigurations(
                  padding: EdgeInsets.zero,
                  expands: false,
                  textInputAction: TextInputAction.newline,
                  autoFocus: false,
                  scrollable: true,
                ),
              ),

              const SizedBox(height: 16),

              Divider(
                thickness: 1,
              ),
              Text(
                  "Was this helpful?",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  )
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle "Yes" feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Thank you for your feedback!"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                        side: BorderSide(color: Colors.black), // Black border
                      ),
                      elevation: 0, // Optional: remove shadow for a flat look
                    ),
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black, // Black text
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
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
                      style: TextStyle(
                        color: Colors.black, // Black text
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget buildConditionItem(double screenWidth,
    {required IconData icon,
    required Color iconColor,
    required String title,
    required String value}) {
  return Expanded(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: screenWidth * 0.07,
          color: iconColor,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.040,
                  color: Colors.black54),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.040,
                  color: Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}
