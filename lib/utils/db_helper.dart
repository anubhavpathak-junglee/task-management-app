import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/task.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    // await deleteDB();
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // // Remove the tasks.db file
  // Future<void> deleteDB() async {
  //   String path = join(await getDatabasesPath(), 'tasks.db');
  //   await deleteDatabase(path);
  // }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        priority INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

Future<List<Task>> getTasks(String search, DateTime? selectedDate) async {
  final db = await database; 
  String whereClause = 'title LIKE ? OR description LIKE ?';
  List<String> whereArgs = ['%$search%', '%$search%'];

  if (selectedDate != null) {
    whereClause = 'createdAt = ?';
    whereArgs = [selectedDate.toIso8601String().split('T').first];
  }

  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    where: whereClause,
    whereArgs: whereArgs,
  );

  return List.generate(maps.length, (i) {
    return Task.fromMap(maps[i]);
  });
}

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}