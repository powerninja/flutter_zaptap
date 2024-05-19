import 'package:flutter/material.dart';
import 'theme.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dbHelper.dart';
import 'package:uuid/uuid.dart';
import 'noteDetail.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZapTap',
      theme: const MaterialTheme(TextTheme()).light(),
      darkTheme: const MaterialTheme(TextTheme()).dark(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
      home: const MemoScreen(title: 'ZapTap'),
    );
  }
}

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
    // UUIDの生成
    final uuid = Uuid();
    String noteId = uuid.v7();
    final note = Note(
        id: noteId,
        favorite: isFavorite,
        color: 'white',
        title: bodyTextController.text,
        content: titleController.text,
        date: DateTime.now().toIso8601String(),
        imagePath: 'test');

    await note.insertNote(note);
    _getNote();
  }

  // メモを取得する
  Future<void> _getNote() async {
    notes = await Note.getNotes();
    setState(() {});
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
            Center(
              // 背景の透過する
              child: FadeTransition(
                // アニメーションを適用
                opacity: _lightningAnimation!,
                // 背景のサイズや色、形を指定
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  // 雷アイコン
                  child: const Icon(
                    Icons.flash_on,
                    size: 100,
                    color: Colors.yellow,
                  ),
                ),
              ),
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
              ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // タイトル
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                              hintText: 'Untitled', border: InputBorder.none),
                        ),
                        // 余白
                        const SizedBox(height: 20.0),
                        // 本文
                        TextField(
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
                      ],
                    ),
                  ),
                ],
              ),
              // メモ一覧画面
              // TODO: 改修が必要
              notes.isEmpty
                  ? const Center(child: Text('メモがありません'))
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) => Dismissible(
                            key: Key(notes[index].id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              // 削除するメモを一時的に保存
                              final deletedMemo = notes[index];

                              // メモを削除する処理
                              setState(() {
                                notes.removeAt(index);
                              });

                              // データベースからメモを削除する処理
                              await deletedMemo.deleteNote(deletedMemo.id);
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              color: Colors.red,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              title: Text(notes[index].title),
                              subtitle: Text(notes[index]
                                  .date
                                  .substring(0, 19)
                                  .replaceAll('T', ' ')),
                              leading: IconButton(
                                icon: notes[index].favorite == 1
                                    ? const Icon(Icons.favorite)
                                    : const Icon(Icons.favorite_border),
                                onPressed: () async {
                                  // メモのお気に入り状態を更新する処理
                                  setState(() {
                                    notes[index].favorite =
                                        notes[index].favorite == 1 ? 0 : 1;
                                  });

                                  // データベースのお気に入り状態を更新する処理
                                  await notes[index].updateNote(notes[index]);

                                  // メモを取得する
                                  await _getNote();
                                },
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () async {
                                // メモ詳細画面に遷移
                                final updatedMemo = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoteDetail(
                                      note: notes[index],
                                    ),
                                  ),
                                );
                                // 更新した時のみ、メモを取得する
                                if (updatedMemo == true) _getNote();
                              },
                            ),
                          )),
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
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
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
                });
              },
            ),
        ],
      ),
    );
  }
}
// TODO: ファイル整理
// TODO: メモ一覧画面のデザインを変更
// TODO: メモ画面でキーボードの上に、ボタンを配置(お気に入りボタンなどを配置する)
// TODO: 写真の保存機能を追加