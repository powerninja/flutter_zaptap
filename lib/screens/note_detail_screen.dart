import 'dart:io';

import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/note.dart';

class NoteDetail extends StatefulWidget {
  final Note? note;

  const NoteDetail({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _title;
  late String _content;
  late String _date;
  late String _color;
  late String _imagePath;
  late int _favorite;

  @override
  void initState() {
    super.initState();

    _title = widget.note!.title;
    _content = widget.note!.content;
    _date = widget.note!.date;
    _color = widget.note!.color;
    _imagePath = widget.note!.imagePath!;
    _favorite = widget.note!.favorite;

    _titleController = TextEditingController(text: _title);
    _contentController = TextEditingController(text: _content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'タイトル',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) {
              setState(() {
                _title = value;
              });
            },
          ),
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: '内容',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _content = value;
                });
              },
            ),
          ),
          // TODO: 画像を表示できるようにする
          // Image.file(
          //   _imagePath!.isEmpty ? File('') : File(_imagePath),
          //   height: 200,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // フローティングアクションボタン
      floatingActionButton: Row(
        // 中心に配置
        mainAxisSize: MainAxisSize.min,
        children: [
          // 保存ボタン
          FloatingActionButton.extended(
            label: const Text('Save'),
            icon: const Icon(Icons.save),
            onPressed: () async {
              final note = Note(
                id: widget.note!.id,
                title: _titleController.text,
                content: _contentController.text,
                date: _date,
                favorite: _favorite,
                color: _color,
                imagePath: _imagePath,
              );
              await DatabaseService().updateNote(note.toMap());

              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
