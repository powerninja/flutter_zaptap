import 'dart:io';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/note.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';

class NoteDetail extends StatefulWidget {
  final Note note;
  final String filePath;

  const NoteDetail({
    Key? key,
    required this.note,
    required this.filePath,
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
    _imagePaths = [];
    if (widget.note.imagePaths?[0].isNotEmpty == true) {
      for (var i = 0; i < widget.note.imagePaths!.length; i++) {
        _imagePaths.add(File(widget.filePath + widget.note.imagePaths![i]));
      }
    } else {
      _imagePaths = [];
    }

    _title = widget.note.title;
    _content = widget.note.content;
    _date = widget.note.date;
    _color = widget.note.color;
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

  // 画像を選択する
  Future<void> _getImagePath() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      if (_imagePaths.length + pickedFiles.length <= 2) {
        _imagePaths.addAll(pickedFiles.map((file) => File(file.path)).toList());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('選択できる画像は最大5枚までです。')),
        );
      }
    });
  }

  // ノートをアップデートする
  Future _updateNote(bool isDelete) async {
    // ImageServiceクラスをインスタンス化
    final ImageService imageService = ImageService();
    List<String> fileNames = [];
    // 更新日時を取得
    DateTime now = DateTime.now();
    _date = now.toIso8601String();
    // 画像を一時ファイルから保存先に移動し、ファイル名を取得
    if (_imagePaths.isNotEmpty && !isDelete) {
      fileNames = await imageService.moveImagesFromTmp(_imagePaths);
    } else if (isDelete) {
      // _imagePathsからファイル名のみ切り出し
      for (var i = 0; i < _imagePaths.length; i++) {
        fileNames.add(_imagePaths[i].path.split('/').last);
      }
    }
    //TODO: 共通処理にしても良さそう
    if (_titleController.text.isEmpty &&
        _contentController.text.isEmpty &&
        _imagePaths.isNotEmpty) {
      // pic Note 2021-09-01 12:34のように表示する
      _titleController.text =
          'pic Note ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      // タイトルが空の場合、本文の最初の16文字をタイトルにする かつ 本文に改行が含まれている場合
    } else if (_titleController.text.isEmpty &&
        _contentController.text.toString().contains('\n')) {
      final titleLength = _contentController.text.length > 16
          ? 15
          // 改行が含まれている場合は、最初の改行までをタイトルにする
          : _contentController.text.toString().indexOf('\n');
      _titleController.text = _contentController.text.substring(0, titleLength);
      // タイトルが空の場合、本文の最初の16文字をタイトルにする
    } else if (_titleController.text.isEmpty) {
      final titleLength = _contentController.text.length > 16
          ? 15
          : _contentController.text.length;
      _titleController.text = _contentController.text.substring(0, titleLength);
    }

    // ノートをアップデートするためにNoteクラスをインスタンス化
    final note = Note(
      id: widget.note.id,
      title: _titleController.text,
      content: _contentController.text,
      date: _date,
      favorite: _favorite,
      color: _color,
      imagePaths: fileNames,
    );
    // ノートをアップデートする
    await DatabaseService().updateNote(note);
  }

  // 画像をタップしたときにフルスクリーンで表示する
  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (BuildContext context, _, __) {
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 20 || details.primaryDelta! < -20) {
                Navigator.of(context).pop();
              }
            },
            child: Dismissible(
              key: Key(index.toString()),
              direction: DismissDirection.vertical,
              onDismissed: (_) => Navigator.of(context).pop(),
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: _imagePaths[index],
                      child: Image.file(
                        _imagePaths[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //画像のプレビューを表示する
  Widget _buildImagePreviews() {
    return SizedBox(
      height: 100,
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
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                      // 画像を角丸にする
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(children: [
                        Image.file(
                          _imagePaths[index],
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () async {
                              setState(() {
                                // 画像を削除
                                _imagePaths.removeAt(index);
                              });
                              await _updateNote(true);
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
    return Stack(
      children: [
        Scaffold(
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
                      hintText: 'Untitled',
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
                        hintText: 'Just start Flick typing...',
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
              _imagePaths.isNotEmpty
                  ? Positioned(
                      bottom: 80,
                      left: 10,
                      right: 10,
                      child: _buildImagePreviews(),
                    )
                  : Container(),
            ],
          ),
        ),
        Positioned(
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom + 60,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "heroPhotoButtonDetail",
                onPressed: _imagePaths.length >= 2 ? null : _getImagePath,
                child: const Icon(Icons.photo),
                backgroundColor: _imagePaths.length >= 2 ? Colors.grey : null,
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: "heroCameraButtonDetail",
                onPressed: _imagePaths.length >= 2 ? null : _getImagePath,
                child: const Icon(Icons.camera_alt),
                backgroundColor: _imagePaths.length >= 2 ? Colors.grey : null,
              ),
              const SizedBox(height: 10),
              FloatingActionButton.extended(
                heroTag: "heroSaveButtonDetail",
                label: const Text('Save'),
                icon: const Icon(Icons.save),
                onPressed: () async {
                  await _updateNote(false);
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
