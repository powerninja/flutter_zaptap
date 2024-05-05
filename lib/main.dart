import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  bool _isShowingMemoList = true;
  final PageController _pageViewController = PageController();
  final bodyTextController = TextEditingController();
  final titleController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (index) {
          if (index == 1) {
            primaryFocus?.unfocus();
          }
          setState(() {
            _isShowingMemoList = index == 0;
          });
        },
        children: [
          ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: 'Untitled', border: InputBorder.none),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: bodyTextController,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.left,
                      focusNode: this.focusNode,
                      decoration: const InputDecoration(
                          hintText: 'Just start typing...',
                          border: InputBorder.none),
                      maxLines: null,
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) => ListTile(
                    title: Text('Item $index'),
                    subtitle: Text('Subtitle $index'),
                    leading: const Icon(Icons.star),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => {},
                  )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        //保存iconを表示
        child: const Icon(Icons.save),
      ),
    );
  }
}
