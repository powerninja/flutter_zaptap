import 'package:flutter/material.dart';
import '../models/note.dart';
import '../screens/note_detail_screen.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final Function(Note) onTap;
  final Function(Note) onDismissed;
  final Function(Note) onNoteUpdated;
  final String filePath;

  const NoteListItem({
    Key? key,
    required this.note,
    required this.onTap,
    required this.onDismissed,
    required this.onNoteUpdated,
    required this.filePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(note),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(
          note.date.substring(0, 19).replaceAll('T', ' '),
        ),
        leading: IconButton(
          icon: note.favorite == 1
              ? const Icon(Icons.push_pin)
              : const Icon(Icons.push_pin_outlined),
          onPressed: () => onTap(note),
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () async {
          // メモ詳細画面に遷移
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetail(note: note, filePath: filePath),
            ),
          );
          // メモが更新された場合は、onNoteUpdatedコールバックを呼び出す
          onNoteUpdated(note);
        },
      ),
    );
  }
}
