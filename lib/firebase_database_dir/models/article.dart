class ArticleModel {
  final String articleId;
  final String articleImage;
  final String title;
  final String semiTitle;
  final Map<String, dynamic> description;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final DateTime postAt;

  ArticleModel({
    required this.articleId,
    required this.articleImage,
    required this.title,
    required this.semiTitle,
    required this.description,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.postAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      articleId: json['articleId'],
      articleImage: json['articleImage'] ?? "",
      title: json['title'],
      semiTitle: json['semi_title'],
      description: Map<String, dynamic>.from(json['description']),
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      postAt: DateTime.parse(json['post_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'articleId': articleId,
      'articleImage': articleImage,
      'title': title,
      'semi_title': semiTitle,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'post_at': postAt.toIso8601String(),
    };
  }
}
