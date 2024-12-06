import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leafora/components/shared/widgets/custom_appbar.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/firebase_database_dir/models/article.dart';

class ArticleDetails extends StatefulWidget {
  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  late final QuillController _descriptionController;
  late ArticleModel articleData;

  @override
  void initState() {
    super.initState();

    final Map<String, dynamic> arguments = Get.arguments;
    articleData = ArticleModel.fromJson(arguments);

    // Ensure the last operation ends with a newline
    List<dynamic> ops = articleData.description['ops'] ?? [];
    if (ops.isNotEmpty && !(ops.last['insert'] as String).endsWith('\n')) {
      ops.last['insert'] = (ops.last['insert'] as String) + '\n';
    }

    _descriptionController = QuillController(
      document: Document.fromJson(ops),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }


  // final Map<String, dynamic> articleData = {
  //   "articleImage": "https://i.ibb.co/MsMDWYZ/closeup-ripe-fig-tree-sunlight.jpg",
  //   "title": "Unlock the Secrets of Succulents: Care Tips for Beginners",
  //   "semi_title": "Rose Care 101",
  //   "description": {
  //     "ops": [
  //       {
  //         "insert": "How to Grow Roses\n",
  //         "attributes": {"bold": true, "header": 1}
  //       },
  //       {
  //         "insert": "Introduction\n",
  //         "attributes": {"bold": true, "header": 2}
  //       },
  //       {
  //         "insert": "Roses are one of the most popular flowers in the world, known for their beauty and fragrance. Growing roses can be a rewarding experience, but it requires proper care and attention.\n\n"
  //       },
  //       {
  //         "insert": "Step 1: Choose the Right Variety\n",
  //         "attributes": {"bold": true, "header": 3}
  //       },
  //       {
  //         "insert": "Different rose varieties thrive in different climates. Research and select a type suitable for your region and purpose (e.g., garden roses, climbing roses, or miniature roses).\n\n"
  //       },
  //       {
  //         "insert": "Step 2: Prepare the Soil\n",
  //         "attributes": {"bold": true, "header": 3}
  //       },
  //       {
  //         "insert": "Roses prefer well-drained, loamy soil with a pH level of 6.5. Enrich the soil with compost or organic matter to provide essential nutrients.\n\n"
  //       },
  //       {
  //         "insert": "Care Tips\n",
  //         "attributes": {"bold": true, "header": 2}
  //       },
  //       {
  //         "insert": "Watering: Keep the soil consistently moist but avoid overwatering.\nFertilizing: Feed your roses monthly during the growing season with a balanced fertilizer.\nPruning: Remove dead or weak stems to promote healthy growth.\n"
  //       },
  //       {
  //         "insert": "\nConclusion\n",
  //         "attributes": {"bold": true, "header": 2}
  //       },
  //       {
  //         "insert": "With proper care, roses can bring vibrant colors and delightful scents to your garden. Enjoy the process and watch your roses flourish!\n"
  //       }
  //     ]
  //   },
  //   "articleId": "A334455",
  //   "authorImage": "https://i.ibb.co/WHz0bWq/pngwing-com.png",
  //   "authorId": "U221161",
  //   "authorName": "John Doe",
  //   "post_at": "2024-11-25T10:00:00Z"
  // };

  @override
  Widget build(BuildContext context) {
    final postDate = articleData.postAt;
    final formattedDate = DateFormat('MMMM d, yyyy').format(postDate);

    return Scaffold(
      appBar: CustomAppBar4(title: "Article"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Article Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: articleData.articleImage.isNotEmpty
                    ? articleData.articleImage
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

            // Padding for Article Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    articleData.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Author and Date
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: articleData.authorImage != null
                            ? NetworkImage(articleData.authorImage!)
                            : null,
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            articleData.authorName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            formattedDate,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Quill Description
                  QuillEditor.basic(
                    controller: _descriptionController,
                    focusNode: FocusNode(),
                  ),

                  const SizedBox(height: 16),

                  Divider(color: Colors.black,thickness: 1,),
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
          ],
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
