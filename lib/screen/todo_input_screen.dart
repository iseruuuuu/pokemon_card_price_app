import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import '../state/todo_list_store.dart';

class TodoInputScreen extends StatefulWidget {
  /// Todoのモデル
  final Todo? todo;

  /// コンストラクタ
  /// Todoを引数で受け取った場合は更新、受け取らない場合は追加画面となる
  const TodoInputScreen({Key? key, this.todo}) : super(key: key);

  /// Todo入力画面の状態を生成する
  @override
  State<TodoInputScreen> createState() => _TodoInputScreenState();
}

/// Todo入力ト画面の状態クラス
///
/// 以下の責務を持つ
/// ・Todoを追加/更新する
/// ・Todoリスト画面へ戻る
class _TodoInputScreenState extends State<TodoInputScreen> {
  final TodoListStore _store = TodoListStore();

  /// 新規追加か
  late bool _isCreateTodo;

  /// 画面項目：タイトル
  late String _title;

  /// 画面項目：作成日時
  late String _createDate;

  /// 画面項目：更新日時
  late String _updateDate;

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();
    var todo = widget.todo;
    _title = todo?.title ?? "";
    _createDate = todo?.createDate ?? "";
    _updateDate = todo?.updateDate ?? "";
    _isCreateTodo = todo == null;
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isCreateTodo ? 'カード追加' : 'カード更新'),
        elevation: 0,
      ),
      body: Container(
        // 全体のパディング
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            // タイトルのテキストフィールド
            const Spacer(),
            TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "カード名",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              // TextEditingControllerを使用することで、いちいちsetStateしなくても画面を更新してくれる
              controller: TextEditingController(text: _title),
              onChanged: (String value) {
                _title = value;
              },
            ),
            const SizedBox(height: 20),
            // 詳細のテキストフィールド
            const SizedBox(height: 20),
            // 追加/更新ボタン
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (_isCreateTodo) {
                    // Todoを追加する
                    _store.add(_title);
                  } else {
                    // Todoを更新する
                    _store.update(widget.todo!, _title);
                  }
                  // Todoリスト画面に戻る
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '追加',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            // キャンセルボタン
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Todoリスト画面に戻る
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                child: const Text(
                  "キャンセル",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
