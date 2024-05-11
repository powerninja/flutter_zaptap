// ignore: file_names
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.favorite,
    required this.color,
    this.imagePath,
  });

  final int id;
  final String title;
  final String content;
  final String date;
  final int favorite;
  final String color;
  final String? imagePath; // 画像のファイルパスを保持する

  // SQLiteのMapからNoteインスタンスを生成するためのコンストラクタ
  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        content = map['content'],
        date = map['date'],
        favorite = map['favorite'],
        color = map['color'],
        imagePath = map['image_path'];

  // NoteインスタンスをSQLiteに保存するためのMapに変換するメソッド
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'favorite': favorite,
      'color': color,
      'image_path': imagePath, // 画像のファイルパスを保存
    };
  }

  // テーブルを作成する
  static Future<Database> initDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, favorite INTEGER, color TEXT, image_path TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertNote(Note note) async {
    final db = await initDB();
    await db.insert('notes', note.toMap());
  }

  static Future<List<Note>> getNotes() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return maps.map((map) => Note.fromMap(map)).toList();
  }
}
