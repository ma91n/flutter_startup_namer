import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
      home: RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.separated(
        padding: EdgeInsets.all(16.0),
        itemCount: 100,
        separatorBuilder: (context, index) => Divider(
          height: 0,
        ),
        itemBuilder: (context, i) {

          // if (i.isOdd) return Divider();

          // final index = i ~/ 2;
          final index = i;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final item = _suggestions[index];

          return Dismissible(
            // // KeyはFlutterが要素を一意に特定できるようにするための値を設定する。
            key: Key(item.asCamelCase),

            // onDismissedの中にスワイプされた時の動作を記述する。
            // directionにはスワイプの方向が入るため、方向によって処理を分けることができる。
            onDismissed: (direction) {
              setState(() {
                // スワイプされた要素をデータから削除する
                _suggestions.removeAt(index);
              });
              // スワイプ方向がendToStart（画面左から右）の場合の処理
              if (direction == DismissDirection.endToStart) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("削除しました"))
                );
                // スワイプ方向がstartToEnd（画面右から左）の場合の処理
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("登録しました"))
                );
              }
            },
            // スワイプ方向がendToStart（画面左から右）の場合のバックグラウンドの設定
            background: Container(color: Colors.red),

            // スワイプ方向がstartToEnd（画面右から左）の場合のバックグラウンドの設定
            secondaryBackground: Container(color: Colors.blue),

            // ListViewの各要素の定義
            child: _buildRow(_suggestions[index]),
          );

        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
