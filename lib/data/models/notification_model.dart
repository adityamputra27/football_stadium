class NotificationModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String params;
  final String status;
  final bool isRead;
  final String createdAt;
  final String timeAgo;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.params,
    required this.status,
    required this.isRead,
    required this.createdAt,
    required this.timeAgo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      params: json['params'],
      status: json['status'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      timeAgo: json['time_ago'],
    );
  }
}
