import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo.dart';

// TODO: Topic안에 ToDo 들어있으니까 db 업뎃 / 로드할 때 이거 반영하게 고치기!!!!!!!

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE topics (
        id INTEGER PRIMARY KEY,
        color INTEGER,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY,
        task TEXT,
        date TEXT,
        description TEXT,
        isCompleted INTEGER,
        topicId INTEGER,
        FOREIGN KEY (topicId) REFERENCES topics (id)
      )
    ''');
  }

  Future<int> addTopic(Topic topic) async {
    Database db = await database;
    return await db.insert('topics', topic.toMap());
  }

  Future<int> addToDo(ToDo todo) async {
    Database db = await database;
    return await db.insert('todos', todo.toMap());
  }

  Future<List<Topic>> fetchTopics() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('topics');
    return List.generate(maps.length, (i) {
      return Topic.fromMap(maps[i]);
    });
  }

  Future<List<ToDo>> fetchToDosByTopic(int topicId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'topicId = ?',
      whereArgs: [topicId],
    );
    return List.generate(maps.length, (i) {
      return ToDo.fromMap(maps[i]);
    });
  }

  Future<int> updateToDo(ToDo todo) async {
    Database db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteToDo(int id) async {
    Database db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTopic(int id) async {
    Database db = await database;
    // Also delete all todos associated with this topic
    await db.delete(
      'todos',
      where: 'topicId = ?',
      whereArgs: [id],
    );
    return await db.delete(
      'topics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
