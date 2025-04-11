import 'package:football_stadium/data/models/local_notification_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDatabase {
  static final NotificationDatabase instance = NotificationDatabase._init();
  static Database? _database;

  NotificationDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT';
    const boolType = 'INTEGER';

    await db.execute('''
      CREATE TABLE notifications (
        id $idType,
        title $textType,
        body $textType,
        timestamp $textType,
        is_read $boolType,
        is_deleted $boolType
      )
    ''');
  }

  Future<int> insertNotification(LocalNotificationModel notification) async {
    final db = await instance.database;
    return await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LocalNotificationModel>> fetchNotifications() async {
    final db = await instance.database;
    final result = await db.query('notifications', orderBy: 'timestamp DESC');

    return result.map((map) => LocalNotificationModel.fromJson(map)).toList();
  }

  Future<int> markNotificationAsRead(String id) async {
    final db = await instance.database;
    return await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNotification(String id) async {
    final db = await instance.database;
    return await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllNotifications() async {
    final db = await instance.database;
    return await db.delete('notifications');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
