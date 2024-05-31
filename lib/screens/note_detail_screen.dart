import 'dart:io';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/note.dart';
import 'package:image_picker/image_picker.dart';

class NoteDetail extends StatefulWidget {
  final Note note;

  const NoteDetail({
    Key? key,
    required this.note,
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
  late List<File> _imagePaths;
  late int _favorite;

  @override
  void initState() {
    super.initState();

    _title = widget.note.title;
    _content = widget.note.content;
    _date = widget.note.date;
    _color = widget.note.color;
    _imagePaths =
        widget.note.imagePaths?.map((path) => File(path)).toList() ?? [];
    _favorite = widget.note.favorite;

    _titleController = TextEditingController(text: _title);
    _contentController = TextEditingController(text: _content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _getImagePath() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        if (_imagePaths.length + pickedFiles.length <= 5) {
          _imagePaths
              .addAll(pickedFiles.map((file) => File(file.path)).toList());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('選択できる画像は最大5枚までです。')),
          );
        }
      });
    }
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
                  _imagePaths[index],
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

  Widget _buildImagePreviews() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              GestureDetector(
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
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(children: [
                        Image.file(
                          _imagePaths[index],
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                // _selectedImages.removeAt(index);
                                // if (_selectedImages.isEmpty) {
                                //   isButtonEnabled = false;
                                // }
                              });
                            },
                          ),
                        ),
                      ])),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'タイトル',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            ],
          ),
          _imagePaths[0].path != ''
              ? Positioned(
                  bottom: 80,
                  left: 10,
                  right: 10,
                  child: _buildImagePreviews(),
                )
              : Container(),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "heroCameraButtonDetail",
                  onPressed: _getImagePath,
                  child: const Icon(Icons.camera_alt),
                ),
                const SizedBox(width: 16),
                FloatingActionButton.extended(
                  heroTag: "heroSaveButtonDetail",
                  label: const Text('Save'),
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    final note = Note(
                      id: widget.note.id,
                      title: _titleController.text,
                      content: _contentController.text,
                      date: _date,
                      favorite: _favorite,
                      color: _color,
                      imagePaths: _imagePaths.map((file) => file.path).toList(),
                    );
                    await DatabaseService().updateNote(note);
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
