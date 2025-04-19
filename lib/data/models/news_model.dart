class NewsModel {
  final int id;
  final String title;
  final String body;
  final String image;
  final int isFeaturedNews;
  final String category;
  final String diff;

  NewsModel({
    required this.id,
    required this.title,
    required this.image,
    required this.isFeaturedNews,
    required this.category,
    required this.body,
    required this.diff,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      isFeaturedNews: json['is_featured_news'],
      category: json['category'],
      body: json['body'],
      diff: json['diff'],
    );
  }
}
