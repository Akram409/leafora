import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';

class PlantDetails extends StatefulWidget {
  const PlantDetails({super.key});

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  Map<String, dynamic> plantData = {
    "P998877": {
      "plantId": "P998877",
      "plantImage":
          "https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg",
      "plantName": "Rose",
      "scientificName": "Rosa",
      "plantType": "Flowering",
      "genus": "Rosa",
      "plantDescription": "Beautiful flowering plant",
      "conditions": [
        {
          "temperature": "15-25°C",
          "sunlight": "Full Sun",
          "soil": "Loamy",
          "caution": "Mildly toxic",
          "hardinessZone": "5-9",
          "growthRate": "Moderate"
        }
      ],
      "care": [
        {
          "water": "Moderate",
          "fertilizer": "Monthly",
          "pruning": "Annual",
          "propagations": "Cuttings",
          "reporting": "Every 2 years",
          "humidity": "Moderate"
        }
      ],
      "common_disease": "Black Spot",
      "specialFeature": "Fragrant Flowers",
      "uses": "Decorative",
      "funFact": "Roses are over 35 million years old.",
      "helpful": 10,
      "not_helpful": 2,
      "author": "U221161"
    }
  };

  @override
  Widget build(BuildContext context) {
    // Access the plant data
    var plant = plantData["P998877"];
    var screenWidth = MediaQuery.of(context).size.width;
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
                  imageUrl:
                      plant['plantImage'] ?? 'https://via.placeholder.com/250',
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
                plant['plantName'],
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
                          ":  ${plant['genus']}",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ":  ${plant['scientificName']}",
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
                    plant['plantDescription'],
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

              // Plant Conditions
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.health_and_safety_outlined,
                        size: screenWidth * 0.065,
                        color: Colors.greenAccent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Conditions",
                        style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Row for Temperature and Sunlight
                      Row(
                        children: [
                          buildConditionItem(
                            screenWidth,
                            icon: FontAwesomeIcons.temperatureThreeQuarters,
                            iconColor: Colors.green,
                            title: "Temperature",
                            value: plant['conditions'][0]['temperature'],
                          ),
                          buildConditionItem(
                            screenWidth,
                            icon: Icons.sunny,
                            iconColor: Colors.yellow,
                            title: "Sunlight",
                            value: plant['conditions'][0]['sunlight'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Row for Hardiness Zones and Soil
                      Row(
                        children: [
                          buildConditionItem(
                            screenWidth,
                            icon: Icons.location_on_outlined,
                            iconColor: Colors.purple,
                            title: "Hardiness Zones",
                            value: plant['conditions'][0]['hardinessZone'],
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          buildConditionItem(
                            screenWidth,
                            icon: FontAwesomeIcons.tree,
                            iconColor: Colors.grey,
                            title: "Soil",
                            value: plant['conditions'][0]['soil'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Row for Growth Rate and Caution
                      Row(
                        children: [
                          buildConditionItem(
                            screenWidth,
                            icon: Icons.trending_up,
                            iconColor: Colors.cyanAccent,
                            title: "Growth Rate",
                            value: plant['conditions'][0]['growthRate'],
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          buildConditionItem(
                            screenWidth,
                            icon: Icons.dangerous_outlined,
                            iconColor: Colors.grey,
                            title: "Caution",
                            value: plant['conditions'][0]['caution'],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Plant Care Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Care:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Water: ${plant['care'][0]['water']}'),
                    Text('Fertilizer: ${plant['care'][0]['fertilizer']}'),
                    Text('Pruning: ${plant['care'][0]['pruning']}'),
                    Text('Propagations: ${plant['care'][0]['propagations']}'),
                    Text('Reporting: ${plant['care'][0]['reporting']}'),
                    Text('Humidity: ${plant['care'][0]['humidity']}'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Special Features and Fun Fact
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Feature:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(plant['specialFeature']),
                    const SizedBox(height: 8),
                    Text(
                      'Fun Fact:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(plant['funFact']),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Common Disease
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Disease:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(plant['common_disease']),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Feedback (Helpful)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text('Helpful: ${plant['helpful']}'),
                    const SizedBox(width: 16),
                    Text('Not Helpful: ${plant['not_helpful']}'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
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
