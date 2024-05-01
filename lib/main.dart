import 'package:flutter/material.dart';
import 'theme.dart';

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
              //TODO: タップした際にメモを書く画面に切り替える
              onPressed: () {
                setState(() {
                  _isShowingMemoList = true;
                });
              },
              child: Text(
                'メモ',
                style: TextStyle(
                    fontWeight: _isShowingMemoList == true
                        ? FontWeight.w800
                        : FontWeight.w400,
                    fontSize: 20.0),
              ),
            ),
            const SizedBox(width: 15.0),
            TextButton(
              onPressed: () {
                setState(() {
                  _isShowingMemoList = false;
                });
              },
              child: Text(
                'メモ一覧',
                style: TextStyle(
                    fontWeight:
                        _isShowingMemoList ? FontWeight.w400 : FontWeight.w800,
                    fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _isShowingMemoList = index == 0;
          });
        },
        children: [
          //TODO: マークダウンでメモを書く
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'タイトル',
                    hintText: 'タイトルを入力してください',
                  ),
                ),
                const SizedBox(height: 20.0),
                const TextField(
                  decoration: InputDecoration(
                    labelText: '内容',
                    hintText: '内容を入力してください',
                  ),
                  maxLines: 10,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => {},
                  child: const Text('保存'),
                ),
              ],
            ),
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
        child: const Icon(Icons.edit),
      ),
    );
  }
}
