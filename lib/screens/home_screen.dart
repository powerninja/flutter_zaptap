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

// フローティングアクションボタンの位置を調整するためのクラス
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetY;

  CustomFloatingActionButtonLocation(this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset offset =
        FloatingActionButtonLocation.endFloat.getOffset(scaffoldGeometry);
    return Offset(offset.dx, offset.dy - offsetY);
  }
}

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key, required this.title});

  final String title;

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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
  // オーバーレイエントリ
  OverlayEntry? _overlayEntry;
  // doneボタンの高さ
  final double _doneButtonHeight = 50.0;

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
    // キーボードの表示状態を監視
    WidgetsBinding.instance.addObserver(this);
  }

  // timerを破棄する
  @override
  void dispose() {
    _timer?.cancel(); // Timerを破棄する
    // キーボードの表示状態を監視を解除
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlay();
    super.dispose();
  }

  // キーボードの表示状態が変更された時に呼び出される
  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  // オーバーレイを表示する
  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          // メディアクエリを取得
          final mediaQuery = MediaQuery.of(context);
          // ダークモードかどうかを判定
          final isDarkMode = mediaQuery.platformBrightness == Brightness.dark;
          // テーマデータを取得
          final themeData = Theme.of(context);
          // オーバーレイを表示
          return Positioned(
            // キーボードの高さ分だけオーバーレイを表示
            bottom: mediaQuery.viewInsets.bottom,
            right: 0.0,
            left: 0.0,
            // オーバーレイの中身
            child: Container(
              height: _doneButtonHeight,
              color: isDarkMode ? Colors.black : Colors.grey[200],
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 8.0, bottom: 8.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _dismissKeyboard(context),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : themeData.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  // オーバーレイを削除する
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
      // タイトルが空の場合、本文の最初の16文字をタイトルにする かつ 本文に改行が含まれている場合
    } else if (titleController.text.isEmpty &&
        bodyTextController.text.toString().contains('\n')) {
      final titleLength = bodyTextController.text.length > 16
          ? 15
          // 改行が含まれている場合は、最初の改行までをタイトルにする
          : bodyTextController.text.toString().indexOf('\n');
      titleController.text = bodyTextController.text.substring(0, titleLength);
      // タイトルが空の場合、本文の最初の16文字をタイトルにする
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
    if (_selectedImages.length + pickedFiles.length <= 2) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        isButtonEnabled = true;
      });
    } else {
      bool? shouldContinue = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('画像選択'),
            content: const Text('保存できる画像の枚数は2枚までとなります。'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: [
                          Image.file(
                            _selectedImages[index],
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
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
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // 画像をフルスクリーンで表示する
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
                      tag: _selectedImages[index],
                      child: Image.file(
                        _selectedImages[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
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

  // textField以外をタップした時にキーボードを閉じる
  void _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // textField以外をタップした時にキーボードを閉じる
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            // フローティングアクションボタンの位置
            floatingActionButtonLocation:
                // CustomFloatingActionButtonLocationクラスを使用して、フローティングアクションボタンの位置を調整
                CustomFloatingActionButtonLocation(60),
            // アプリバー
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        fontWeight: _isShowingMemoDetail
                            ? FontWeight.w800
                            : FontWeight.w400,
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
                        fontWeight: _isShowingMemoDetail
                            ? FontWeight.w400
                            : FontWeight.w800,
                        decoration: _isShowingMemoDetail
                            ? TextDecoration.none
                            : TextDecoration.underline,
                        decorationThickness: 3,
                        decorationColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
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
                        children: [
                          // 画像表示
                          // 画像が1枚も選択されていない場合隙間を無くし、本文を上に詰める
                          _selectedImages.isEmpty
                              ? const SizedBox()
                              : _buildImagePreviews(),
                          // 余白
                          const SizedBox(height: 20.0),
                          // 本文
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: _doneButtonHeight),
                              child: TextField(
                                controller: bodyTextController,
                                autofocus: true,
                                keyboardType: TextInputType.multiline,
                                textAlign: TextAlign.left,
                                // 画面アクセス時にキーボードを表示する
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                    hintText: 'Just start Flick typing...',
                                    border: InputBorder.none),
                                maxLines: null,
                                expands: true,
                                onChanged: (value) {
                                  setState(() {
                                    // 本文または、画像が選択されている場合、保存ボタンを有効にする
                                    isButtonEnabled = value.isNotEmpty ||
                                        _selectedImages.isNotEmpty;
                                  });
                                },
                              ),
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
                                await DatabaseService()
                                    .updateNote(notes[index]);

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
          ),
          // フローティングアクションボタン
          Positioned(
            right: 16,
            bottom: 16 +
                MediaQuery.of(context).viewInsets.bottom +
                60, // キーボードの高さ + 追加の余白
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isShowingMemoDetail) ...[
                  FloatingActionButton(
                    heroTag: "heroAlbumButton",
                    //5枚以上の画像が選択されていない場合のみ、ボタンを有効にする
                    backgroundColor:
                        _selectedImages.length >= 2 ? Colors.grey : null,
                    onPressed:
                        _selectedImages.length >= 2 ? null : _getImagePath,
                    child: const Icon(Icons.add_photo_alternate),
                  ),
                  // ボタン間のスペース
                  const SizedBox(height: 10),
                  // カメラボタン
                  FloatingActionButton(
                    heroTag: "heroCameraButton",
                    backgroundColor:
                        _selectedImages.length >= 2 ? Colors.grey : null,
                    onPressed: _selectedImages.length >= 2 ? null : pickImage,
                    child: const Icon(Icons.camera_alt),
                  ),
                  // ボタン間のスペース
                  const SizedBox(height: 10),
                  // 保存ボタン
                  FloatingActionButton.extended(
                    heroTag: "heroSaveButton",
                    label: const Text('Save'),
                    icon: const Icon(Icons.save),
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
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
