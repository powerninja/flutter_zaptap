import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/lightning_icon.dart';
import '../widgets/note_list_item.dart';
import '../models/note.dart';
import '../services/database_service.dart';

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
  // 選択された画像のパス
  String? _selectedImagePath;
  // 選択された画像
  File? _selectedImage;

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
        _selectedImagePath!.isNotEmpty) {
      // pic Note 2021-09-01 12:34のように表示する
      titleController.text =
          'pic Note ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    } else if (titleController.text.isEmpty) {
      final titleLength = bodyTextController.text.length > 16
          ? 15
          : bodyTextController.text.length;
      titleController.text = bodyTextController.text.substring(0, titleLength);
    }
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
      imagePath: _selectedImagePath ?? '',
    );

    // databaseServiceのinsertNoteメソッドを呼び出す
    await DatabaseService().insertNote(note.toMap());
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
        _selectedImage = File(pickedFile.path);
        isButtonEnabled = true;
      });
    }
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
                    // TODO: 保存ボタンを押下したら画像を非表示にする
                    // TODO: 選択した画像を削除するボタンを追加
                    _selectedImage == null
                        ? const SizedBox()
                        : Image.file(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
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
                        onTap: (note) async {
                          // メモのお気に入り状態を更新する処理
                          setState(() {
                            notes[index].favorite =
                                notes[index].favorite == 1 ? 0 : 1;
                          });

                          // データベースのお気に入り状態を更新する処理
                          await DatabaseService()
                              .updateNote(notes[index].toMap());

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
              label: const Text('Save'),
              icon: const Icon(Icons.save),
              // 本文に何か入力されている場合のみ、ボタンを有効にする
              backgroundColor: !isButtonEnabled ? Colors.grey : null,
              onPressed: isButtonEnabled
                  ? () {
                      // メモを保存する
                      _saveNote();
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
                        _selectedImage = null;
                      });
                    }
                  : null,
            ),

          // ボタン間のスペース
          const SizedBox(width: 10.0),
          // お気に入りボタン
          if (_isShowingMemoDetail)
            FloatingActionButton(
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
              child: const Icon(Icons.delete),
              onPressed: () {
                bodyTextController.clear();
                titleController.clear();
                setState(() {
                  isFavorite = 0;
                  isButtonEnabled = false;
                  _selectedImage = null;
                });
              },
            ),
          // // ボタン間のスペース
          const SizedBox(width: 10.0),
          // カメラボタン
          if (_isShowingMemoDetail)
            FloatingActionButton(
              child: const Icon(Icons.camera_alt),
              onPressed: () async {
                await _getImagePath();
              },
            ),
        ],
      ),
    );
  }
}

// TODO: メモ一覧画面のデザインを変更
// TODO: 写真の保存機能を追加
// TODO: タイトルを入力せずに保存ボタンを押下した場合、タイトルを自動生成する