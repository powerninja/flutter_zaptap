import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/lightning_icon.dart';
import '../widgets/note_list_item.dart';
import '../models/note.dart';
import '../services/database_service.dart';
import '../services/image_service.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key, required this.title});

  final String title;

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen>
    with SingleTickerProviderStateMixin {
  // メモ一覧を表示するかどうか
  bool _isShowingMemoDetail = true;
  // ページコントローラー
  final PageController _pageViewController = PageController();
  // テキストコントローラー
  final bodyTextController = TextEditingController();
  // タイトルコントローラー
  final titleController = TextEditingController();
  // フォーカスノード
  FocusNode focusNode = FocusNode();
  // 雷アイコンを表示するかどうか
  bool _showIcon = false;
  // タイマー
  Timer? _timer;
  // 保存ボタン押下時の雷iconのアニメーションコントローラー
  AnimationController? _lightningAnimationController;
  // 保存ボタン押下時の雷iconのアニメーションの進行状況を示す
  Animation<double>? _lightningAnimation;
  // メモ一覧
  List<Note> notes = [];
  // お気に入り
  int isFavorite = 0;
  // 保存ボタンの有効/無効を管理する変数
  bool isButtonEnabled = false;
  //選択された画像
  List<File> _selectedImages = [];
  // 画像のパス
  String? _filePath;

  // 初期化
  @override
  void initState() {
    super.initState();
    // メモを取得する
    _getNote();

    // 雷アイコンのアニメーションを初期化
    _lightningAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // 雷アイコンのアニメーションを設定
    _lightningAnimation =
        Tween(begin: 0.0, end: 3.0).animate(_lightningAnimationController!);
    // 雷アイコンアニメーションの状態を監視する
    _lightningAnimationController!.addStatusListener((status) {
      // 雷アイコンアニメーションが終了しているか確認する
      if (status == AnimationStatus.dismissed) {
        setState(() {
          // 雷アイコンを非表示にする
          _showIcon = false;
        });
      }
    });
    // ImageServiceクラスをインスタンス化
    final ImageService imageService = ImageService();
    // 画像のパスを取得する
    imageService.getLocalPathSync().then((value) => _filePath = value);
  }

  // timerを破棄する
  @override
  void dispose() {
    _timer?.cancel(); // Timerを破棄する
    super.dispose();
  }

  // メモを保存する
  Future<void> _saveNote() async {
    DateTime now = DateTime.now();
    // タイトルが空かつ本文が空かつ、画像が選択されている場合
    if (titleController.text.isEmpty &&
        bodyTextController.text.isEmpty &&
        _selectedImages.isNotEmpty) {
      // pic Note 2021-09-01 12:34のように表示する
      titleController.text =
          'pic Note ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    } else if (titleController.text.isEmpty) {
      final titleLength = bodyTextController.text.length > 16
          ? 15
          : bodyTextController.text.length;
      titleController.text = bodyTextController.text.substring(0, titleLength);
    }
    // ImageServiceクラスをインスタンス化
    final ImageService imageService = ImageService();
    // 画像を移動する
    final fileNames = await imageService.moveImagesFromTmp(_selectedImages);
    // UUIDの生成
    const uuid = Uuid();
    String noteId = uuid.v7();
    // Noteのインスタンスを生成
    final note = Note(
      id: noteId,
      favorite: isFavorite,
      color: 'white',
      title: titleController.text,
      content: bodyTextController.text,
      date: now.toIso8601String(),
      imagePaths: fileNames,
    );
    await DatabaseService().insertNote(note);
    _getNote();
  }

  // メモを取得する
  Future<void> _getNote() async {
    notes = await DatabaseService().getNotes();
    setState(() {});
  }

  // 画像を取得する
  Future<void> _getImagePath() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      if (_selectedImages.length + pickedFiles.length <= 5) {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        isButtonEnabled = true;
      } else {
        // 選択できる画像の枚数が5枚を超える場合は、エラーメッセージを表示するなどの処理を行う
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('選択できる画像は最大5枚までです。')),
        );
      }
    });
  }

  // カメラを起動して写真を撮影する
  Future<void> pickImage() async {
    final picker = ImagePicker();
    //カメラを起動して写真を撮影
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
        isButtonEnabled = true;
      });
    }
  }

  //TODO: 文字とかぶってしまうため、どうにかする
  // 画像プレビューを表示する
  Widget _buildImagePreviews() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length + 1,
        itemBuilder: (context, index) {
          if (index < _selectedImages.length) {
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
                    child: Image.file(
                      _selectedImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _selectedImages.removeAt(index);
                        if (_selectedImages.isEmpty) {
                          isButtonEnabled = false;
                        }
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            return _selectedImages.length < 5
                ? GestureDetector(
                    onTap: _getImagePath,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  )
                : const SizedBox();
          }
        },
      ),
    );
  }

  // 画像をフルスクリーンで表示する
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
                  _selectedImages[index],
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
      // フローティングアクションボタンの位置
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // アプリバー
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isShowingMemoDetail = true;
                  _pageViewController.animateToPage(0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                });
              },
              child: Text(
                'メモ',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight:
                      _isShowingMemoDetail ? FontWeight.w800 : FontWeight.w400,
                  decoration: _isShowingMemoDetail
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationThickness: 3,
                  decorationColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            TextButton(
              onPressed: () {
                primaryFocus?.unfocus();
                _pageViewController.animateToPage(1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
                setState(() {
                  _isShowingMemoDetail = false;
                });
              },
              child: Text(
                'メモ一覧',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight:
                      _isShowingMemoDetail ? FontWeight.w400 : FontWeight.w800,
                  decoration: _isShowingMemoDetail
                      ? TextDecoration.none
                      : TextDecoration.underline,
                  decorationThickness: 3,
                  decorationColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      // ページビュー
      body: Stack(
        children: [
          if (_showIcon)
            // LightningIconを表示
            LightningIcon(
              animationController: _lightningAnimationController,
              animation: _lightningAnimation,
            ),
          // スワイプで画面遷移
          PageView(
            controller: _pageViewController,
            onPageChanged: (index) {
              if (index == 1) {
                primaryFocus?.unfocus();
              }
              setState(() {
                _isShowingMemoDetail = index == 0;
              });
            },
            // メモ画面
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    // タイトル
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: 'Untitled', border: InputBorder.none),
                    ),
                    // 余白
                    const SizedBox(height: 20.0),
                    // 本文
                    Expanded(
                      child: TextField(
                        controller: bodyTextController,
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.left,
                        // 画面アクセス時にキーボードを表示する
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                            hintText: 'Just start typing...',
                            border: InputBorder.none),
                        maxLines: null,
                        onChanged: (value) {
                          // メモが空でない場合、保存ボタンを有効にする
                          if (value.isNotEmpty) {
                            setState(() {
                              isButtonEnabled = true;
                            });
                          } else {
                            setState(() {
                              isButtonEnabled = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // メモ一覧画面
              notes.isEmpty
                  ? const Center(child: Text('メモがありません'))
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) => NoteListItem(
                        note: notes[index],
                        filePath: _filePath ?? '',
                        onTap: (note) async {
                          // メモのお気に入り状態を更新する処理
                          setState(() {
                            notes[index].favorite =
                                notes[index].favorite == 1 ? 0 : 1;
                          });

                          // データベースのお気に入り状態を更新する処理
                          await DatabaseService().updateNote(notes[index]);

                          // メモを取得する
                          _getNote();
                        },
                        onDismissed: (note) async {
                          // メモを削除する処理
                          setState(() {
                            notes.removeAt(index);
                          });

                          await DatabaseService().deleteNote(note.id);
                        },
                        onNoteUpdated: (note) {
                          // メモを更新する処理
                          _getNote();
                        },
                      ),
                    ),
            ],
          ),
          if (_isShowingMemoDetail)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: _buildImagePreviews(),
            ),
        ],
      ),
      // フローティングアクションボタン
      floatingActionButton: Row(
        // 中心に配置
        mainAxisSize: MainAxisSize.min,
        children: [
          // 保存ボタン
          if (_isShowingMemoDetail)
            FloatingActionButton.extended(
              heroTag: "heroSaveButton",
              label: const Text('Save'),
              icon: const Icon(Icons.save),
              // 本文に何か入力されている場合のみ、ボタンを有効にする
              backgroundColor: !isButtonEnabled ? Colors.grey : null,
              onPressed: isButtonEnabled
                  ? () async {
                      // メモを保存する
                      await _saveNote();
                      // メモを取得する
                      _getNote();
                      // 雷アイコンを表示する
                      setState(() {
                        _showIcon = !_showIcon;
                      });
                      // アニメーションを再生
                      _lightningAnimationController?.forward();
                      // 3秒後にiconを消す
                      _timer?.cancel(); // 既存のTimerをキャンセル
                      // 1秒後にアイコンを非表示にする
                      _timer = Timer(const Duration(seconds: 1), () {
                        // アニメーションを逆再生
                        _lightningAnimationController?.reverse();
                      });
                      // 入力後のテキストをクリア
                      bodyTextController.clear();
                      titleController.clear();
                      // お気に入り状態を初期化
                      setState(() {
                        isFavorite = 0;
                        isButtonEnabled = false;
                        _selectedImages = [];
                      });
                    }
                  : null,
            ),

          // ボタン間のスペース
          const SizedBox(width: 10.0),
          // お気に入りボタン
          if (_isShowingMemoDetail)
            FloatingActionButton(
              heroTag: "heroFavoriteButton",
              child: isFavorite == 1
                  ? const Icon(Icons.push_pin)
                  : const Icon(Icons.push_pin_outlined),
              onPressed: () {
                setState(() {
                  isFavorite = isFavorite == 1 ? 0 : 1;
                });
              },
            ),
          // ボタン間のスペース
          const SizedBox(width: 10.0),
          // クリアボタン
          if (_isShowingMemoDetail)
            FloatingActionButton(
              heroTag: "heroClearButton",
              child: const Icon(Icons.delete),
              onPressed: () {
                bodyTextController.clear();
                titleController.clear();
                setState(() {
                  isFavorite = 0;
                  isButtonEnabled = false;
                  _selectedImages = [];
                });
              },
            ),
          // ボタン間のスペース
          const SizedBox(width: 10.0),
          // カメラボタン
          if (_isShowingMemoDetail)
            FloatingActionButton(
              heroTag: "heroCameraButton",
              child: const Icon(Icons.camera_alt),
              //5枚以上の画像が選択されていない場合のみ、ボタンを有効にする
              backgroundColor: _selectedImages.length >= 5 ? Colors.grey : null,
              onPressed: _selectedImages.length >= 5
                  ? null
                  : () async {
                      pickImage();
                    },
            ),
        ],
      ),
    );
  }
}

// TODO: メモ一覧画面のデザインを変更
// TODO: メモ一覧画面の検索機能を追加する
// TODO: メモ作成画面とメモ詳細画面のボタンを揃える