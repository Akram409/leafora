import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leafora/components/shared/widgets/custom_loader.dart';
import 'package:leafora/components/shared/widgets/custom_toast.dart';
import 'package:leafora/firebase_database_dir/models/article.dart';
import 'package:leafora/firebase_database_dir/service/user_service.dart';
import 'package:leafora/services/auth_service.dart';

class ArticleDetails extends StatefulWidget {
  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  late final QuillController _descriptionController;
  late ArticleModel articleData;
  bool isBookmarked = false;
  final authService = AuthService();
  final userService = UserService();

  @override
  void initState() {
    super.initState();

    articleData = Get.arguments as ArticleModel;

    authService.getCurrentUser().then((user) async {
      if (user != null) {
        isBookmarked = await userService.isArticleBookmarked(
            user.uid, articleData.articleId);
        setState(() {}); // Update the UI
      }
    });

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    authService.getCurrentUser().then((user) async {
      if (user != null) {
        final bookmarked = await userService.isArticleBookmarked(
            user.uid, articleData.articleId);
        setState(() {
          isBookmarked = bookmarked;
        });
      }
    });
  }

// Bookmark sate not working after came to the already bookmarked page
  void toggleBookmark() async {
    final user = await authService.getCurrentUser();
    if (user == null) {
      CustomToast2.show(
        context,
        "Please log in to bookmark articles.",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      if (isBookmarked) {
        await userService.removeFromBookmarksOrPlants(
            userId: user.uid,
            id: articleData.articleId,
            type: "article",
            name: articleData.title,
            imageUrl: articleData.articleImage);
        CustomToast2.show(
          context,
          "Bookmark removed!",
          bgColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        await userService.addToBookmarksOrPlants(
          userId: user.uid,
          id: articleData.articleId,
          type: "article",
          name: articleData.title,
          imageUrl: articleData.articleImage,
          plantScientificName: "",
          plantGenus: "",
        );
        CustomToast2.show(
          context,
          "Article bookmarked!",
          bgColor: Colors.green,
          textColor: Colors.white,
        );
      }

      setState(() {
        isBookmarked = !isBookmarked; // Toggle state
      });
    } catch (e) {
      CustomToast2.show(
        context,
        "Failed to update bookmark: $e",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final postDate = articleData.postAt;
    final formattedDate = DateFormat('MMMM d, yyyy').format(postDate);

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
            "Article Details",
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
          // IconButton(
          //   icon: const Icon(Icons.share_outlined, color: Colors.black),
          //   onPressed: () {
          //     // Bookmark button action
          //   },
          // ),
          IconButton(
            mouseCursor: SystemMouseCursors.click,
            icon: Icon(
              size: 30,
              isBookmarked
                  ? Icons.bookmark_added_rounded
                  : Icons.bookmark_add_outlined,
              color: isBookmarked ? Colors.green : Colors.black,
            ),
            onPressed: toggleBookmark,
          ),
        ],
      ),
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

                  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  // TODO: was this helpful do it
                  Text("Was this helpful?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                            side:
                                BorderSide(color: Colors.black), // Black border
                          ),
                          elevation:
                              0, // Optional: remove shadow for a flat look
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
