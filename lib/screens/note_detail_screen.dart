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
  late List<String> _imagePaths;
  late int _favorite;

  @override
  void initState() {
    super.initState();

    _title = widget.note!.title;
    _content = widget.note!.content;
    _date = widget.note!.date;
    _color = widget.note!.color;
    _imagePaths = widget.note!.imagePaths?.toList() ?? <String>[];
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

  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: Image.file(
                  File(_imagePaths[index]),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // xにポストできるボタンを追加
      appBar: AppBar(
        title: const Text('メモ'),
        actions: [
          IconButton(
            // twiiterの投稿ボタン
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
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
          // TODO: 画像の表示場所を調整
          _imagePaths.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imagePaths.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showFullScreenImage(context, index);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.file(
                            File(_imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
                imagePaths: _imagePaths,
              );
              await DatabaseService().updateNote(note);
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
