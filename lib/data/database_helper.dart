import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database>? _database;
  static const String _databaseName = 'tmdb_flutter.db';

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE movies('
        'id INTEGER PRIMARY KEY, '
        'adult INTEGER, '
        'backdrop_path TEXT, '
        'genre_ids TEXT, '
        'original_language TEXT, '
        'original_title TEXT, '
        'overview TEXT, '
        'popularity REAL, '
        'poster_path TEXT, '
        'release_date TEXT, '
        'title TEXT, '
        'video INTEGER, '
        'vote_average REAL, '
        'vote_count INTEGER'
        ')',
      );
      await db.execute(
        'CREATE TABLE favourite_movies('
        'id INTEGER PRIMARY KEY, '
        'adult INTEGER, '
        'backdrop_path TEXT, '
        'genre_ids TEXT, '
        'original_language TEXT, '
        'original_title TEXT, '
        'overview TEXT, '
        'popularity REAL, '
        'poster_path TEXT, '
        'release_date TEXT, '
        'title TEXT, '
        'video INTEGER, '
        'vote_average REAL, '
        'vote_count INTEGER'
        ')',
      );
    });
  }
}
