import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? _database;
List dataList = [];

class LocalDatabase {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Local.db');
    return _database;
  }

  Future _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        surname TEXT,
        age INTEGER,
        email TEXT
      )
    ''');
  }

  Future addDataLocally({name, surname, age, email}) async {
    final db = await database;
    await db.insert(
      'users',
      {"name": name, "surname": surname, "age": age, "email": email},
    );
    return 'Added';
  }

  Future fetchData() async {
    final db = await database;
    final allData = await db!.query('users');
    dataList = allData;

    return 'Data fetched successfully';
  }
}
