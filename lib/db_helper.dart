import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'attendance.db');
    print('Initializing Database at: $path');
    
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      print('Creating Tables');
      await db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)');
      await db.execute('CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
    });
  }

  // User functions
  static Future<int> registerUser(String email, String password) async {
    try {
      final dbClient = await db;
      print('Registering user: $email');
      final res = await dbClient.insert('users', {'email': email, 'password': password});
      print('User registered with ID: $res');
      return res;
    } catch (e) {
      print('Register Error: $e');
      return -1;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    try {
      final dbClient = await db;
      print('Logging in user: $email');
      final res = await dbClient.query('users', where: 'email=? AND password=?', whereArgs: [email, password]);
      print('Login found ${res.length} users');
      return res.isNotEmpty;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  // Student CRUD functions
  static Future<List<Map<String, dynamic>>> getStudents() async {
    final dbClient = await db;
    return await dbClient.query('students');
  }

  static Future<int> addStudent(String name) async {
    final dbClient = await db;
    return await dbClient.insert('students', {'name': name});
  }

  static Future<int> updateStudent(int id, String name) async {
    final dbClient = await db;
    return await dbClient.update('students', {'name': name}, where: 'id=?', whereArgs: [id]);
  }

  static Future<int> deleteStudent(int id) async {
    final dbClient = await db;
    return await dbClient.delete('students', where: 'id=?', whereArgs: [id]);
  }
}
