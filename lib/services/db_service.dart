import 'package:hear_ai_demo/data/gallery_items_repository.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:sqflite/sqflite.dart';


class DBService implements GalleryItemsRepository {
  static const String _dbName = 'myDb.db';
  static const String _tableName = 'galleryItems';
  static const int _dbVersion = 1;

  DBService._internal();

  static final DBService _instance = DBService._internal();

  factory DBService() => _instance;

  Future<Database> _getDatabase() async {
    return await openDatabase(_dbName, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        mediaUrl TEXT NOT NULL,
        time INTEGER NOT NULL,
        mediaType INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<int> insert(GalleryItem item) async {
    final db = await _getDatabase();
    final id = await db.insert(_tableName, item.toMap());
    return id;
  }

  @override
  Future<int> update(GalleryItem item) async {
    final db = await _getDatabase();
    return await db.update(_tableName, item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  @override
  Future<int> delete(GalleryItem item) async {
    final db = await _getDatabase();
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [item.id]);
  }

  @override
  Future<List<GalleryItem>> getAllItems() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => GalleryItem.fromMap(map)).toList();
  }
}
