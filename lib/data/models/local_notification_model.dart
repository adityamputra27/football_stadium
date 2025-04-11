class LocalNotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final bool isDeleted;
  final String timestamp;

  LocalNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    this.isDeleted = false,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'is_read': isRead ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory LocalNotificationModel.fromJson(Map<String, dynamic> json) {
    return LocalNotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: json['timestamp'] as String,
      isRead: (json['is_read'] as int) == 1,
      isDeleted: (json['is_deleted'] as int) == 1,
    );
  }

  @override
  String toString() {
    return 'LocalNotificationModel(id: $id, title: $title, body: $body, isRead: $isRead, isDeleted: $isDeleted, timestamp: $timestamp)';
  }
}
