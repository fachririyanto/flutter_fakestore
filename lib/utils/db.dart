import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;

    _db = await _initDatabase();
    return _db;
  }

  Future<Database> _initDatabase() async {
    String path = 'fakestore_cart.db';
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fakestore_cart (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        image TEXT,
        price REAL,
        quantity INTEGER
      )
    ''');
  }
}
