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

  final String id;
  final String title;
  final String content;
  final String date;
  int favorite;
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
          'CREATE TABLE notes(id TEXT PRIMARY KEY, title TEXT, content TEXT, date TEXT, favorite INTEGER, color TEXT, image_path TEXT)',
        );
      },
      version: 3,
    );
    return database;
  }

  // レコードを作成
  Future<void> insertNote(Note note) async {
    final db = await initDB();
    await db.insert('notes', note.toMap());
  }

  // 全てのレコードを取得
  static Future<List<Note>> getNotes() async {
    final db = await initDB();
    // データを日付の降順で取得 && お気に入りのものを上に表示
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'favorite DESC, date DESC',
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // レコードを更新
  Future<void> updateNote(Note note) async {
    final db = await initDB();
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // レコードを削除
  Future<void> deleteNote(String id) async {
    final db = await initDB();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // テーブルのスキーマを更新する時に使用
  static Future<void> updateTableSchema() async {
    final db = await initDB();
    await db.transaction((txn) async {
      // 1. 新しいテーブルを作成
      await txn.execute('''
        CREATE TABLE new_notes (
          id TEXT PRIMARY KEY,
          title TEXT,
          content TEXT,
          date TEXT,
          favorite INTEGER,
          color TEXT,
          image_path TEXT
        )
      ''');

      // 2. データを移行
      await txn.execute('''
        INSERT INTO new_notes (id, title, content, date, favorite, color, image_path)
        SELECT id, title, content, date, favorite, color, image_path
        FROM notes
      ''');

      // 3. 元のテーブルを削除
      await txn.execute('DROP TABLE notes');

      // 4. 新しいテーブルの名前を変更
      await txn.execute('ALTER TABLE new_notes RENAME TO notes');
    });
  }
}
