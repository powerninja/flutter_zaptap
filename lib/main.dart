import 'package:flutter/material.dart';
import 'theme.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dbHelper.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

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
      // TODO: MyHomePageを変更する
      home: const MyHomePage(title: 'ZapTap'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // メモ一覧を表示するかどうか
  bool _isShowingMemoList = true;
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
  List<Note> memoList = [];

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
    String noteId = uuid.v4();
    final note = Note(
        id: noteId,
        favorite: 0,
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
    //TODO: 最後削除する、データベースの初期化用
    // Note.updateTableSchema();
    memoList = await Note.getNotes();
    for (var memo in memoList) {
      print(memo.title);
    }
    // print(memoList[0].title);
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
                  _isShowingMemoList = true;
                  _pageViewController.animateToPage(0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                });
              },
              child: Text(
                'メモ',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: _isShowingMemoList == true
                      ? FontWeight.w800
                      : FontWeight.w400,
                  decoration: _isShowingMemoList == true
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
                  _isShowingMemoList = false;
                });
              },
              child: Text(
                'メモ一覧',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight:
                      _isShowingMemoList ? FontWeight.w400 : FontWeight.w800,
                  decoration: _isShowingMemoList == true
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
                _isShowingMemoList = index == 0;
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
                          focusNode: this.focusNode,
                          decoration: const InputDecoration(
                              hintText: 'Just start typing...',
                              border: InputBorder.none),
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // メモ一覧画面
              // TODO: 改修が必要
              ListView.builder(
                  itemCount: memoList.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Text(memoList[index].title),
                        subtitle: Text(memoList[index]
                            .date
                            .substring(0, 19)
                            .replaceAll('T', ' ')),
                        leading: memoList[index].favorite == 1
                            ? const Icon(Icons.push_pin)
                            : const Icon(Icons.push_pin_outlined),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => {},
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
          if (_isShowingMemoList == true)
            FloatingActionButton.extended(
              label: const Text('Save'),
              icon: const Icon(Icons.save),
              onPressed: () {
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
              },
            ),
          // ボタン間のスペース
          const SizedBox(width: 10.0),
          // クリアボタン
          if (_isShowingMemoList == true)
            FloatingActionButton.extended(
              label: const Text('Clear'),
              icon: const Icon(Icons.delete),
              onPressed: () {
                bodyTextController.clear();
                titleController.clear();
              },
            ),
        ],
      ),
    );
  }
}
