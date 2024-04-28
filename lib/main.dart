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
            OutlinedButton(
              onPressed: () {
                // 処理
              },
              child: const Text('メモ'),
            ),
            SizedBox(width: 15.0), // ボタン間の間隔
            OutlinedButton(
              onPressed: () {
                // 処理
              },
              child: const Text('メモ一覧'),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => ListTile(
                title: Text('Item $index'),
                subtitle: Text('Subtitle $index'),
                leading: const Icon(Icons.star),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => {},
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
