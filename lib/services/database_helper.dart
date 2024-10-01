// lib/services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/post.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('posts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE posts (
      id TEXT PRIMARY KEY,
      title TEXT,
      content TEXT,
      imageUrl TEXT,
      isLiked INTEGER,
      isSaved INTEGER
    )''');
  }

  Future<void> insertPost(Post post) async {
    final db = await database;
    await db.insert(
      'posts',
      postToMap(post),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Post>> getPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts');

    return List.generate(maps.length, (i) {
      return Post(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        imageUrl: maps[i]['imageUrl'],
        isLiked: maps[i]['isLiked'] == 1,
        isSaved: maps[i]['isSaved'] == 1,
      );
    });
  }

  Future<void> deletePost(String id) async {
    final db = await database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> postToMap(Post post) {
    return {
      'id': post.id,
      'title': post.title,
      'content': post.content,
      'imageUrl': post.imageUrl,
      'isLiked': post.isLiked ? 1 : 0,
      'isSaved': post.isSaved ? 1 : 0,
    };
  }
}
