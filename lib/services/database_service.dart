// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDatabase,
      onUpgrade: _onUpgradeDatabase,
    );
  }

  Future<void> _onUpgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await db
          .execute('ALTER TABLE notes ADD COLUMN imagePath TEXT DEFAULT ""');
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, content TEXT, date TEXT, favorite INTEGER, color TEXT, imagePath TEXT)');
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final getNotes = await db.query(
      'notes',
      orderBy: 'favorite DESC, date DESC',
    );
    final result = await Future.wait(getNotes.map((noteMap) async {
      return Note.fromMap(noteMap);
    }));
    return result;
  }

  Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert('notes', note);
  }

  Future<void> updateNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.update(
      'notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
