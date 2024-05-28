import '../services/database_service.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String date;
  int favorite;
  final String color;
  final List<String>? imagePaths;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.favorite,
    required this.color,
    this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'favorite': favorite,
      'color': color,
      'title': title,
      'content': content,
      'date': date,
      'imagePaths': imagePaths?.join(','),
    };
  }

  static Future<Note> fromMap(Map<String, dynamic> map) async {
    return Note(
      id: map['id'],
      favorite: map['favorite'],
      color: map['color'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      imagePaths: (map['imagePaths'] as String).split(','),
    );
  }

  static Future<Note> fromJson(Map<String, dynamic> json) async {
    return Note(
      id: json['id'],
      favorite: json['favorite'],
      color: json['color'],
      title: json['title'],
      content: json['content'],
      date: json['date'],
      imagePaths: (json['imagePaths'] as String).split(','),
    );
  }

  static Future<List<Note>> getNotes() async {
    final databaseService = DatabaseService();
    final noteList = await databaseService.getNotes();
    return noteList;
  }

  static Future<void> insertNote(Note note) async {
    final databaseService = DatabaseService();
    await databaseService.insertNote(note);
  }

  static Future<void> updateNote(Note note) async {
    final databaseService = DatabaseService();
    await databaseService.updateNote(note);
  }

  static Future<void> deleteNote(String id) async {
    final databaseService = DatabaseService();
    await databaseService.deleteNote(id);
  }
}
