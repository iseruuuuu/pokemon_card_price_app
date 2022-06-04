import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import '../state/todo_list_store.dart';

class TodoInputScreen extends StatefulWidget {
  final Todo? todo;

  const TodoInputScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<TodoInputScreen> createState() => _TodoInputScreenState();
}

class _TodoInputScreenState extends State<TodoInputScreen> {
  final TodoListStore _store = TodoListStore();

  late bool _isCreateTodo;
  late String _title;
  late String _createDate;
  late String _updateDate;

  @override
  void initState() {
    super.initState();
    var todo = widget.todo;
    _title = todo?.title ?? "";
    _createDate = todo?.createDate ?? "";
    _updateDate = todo?.updateDate ?? "";
    _isCreateTodo = todo == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isCreateTodo ? 'カード追加' : 'カード更新'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
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
              controller: TextEditingController(text: _title),
              onChanged: (String value) {
                _title = value;
              },
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
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
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
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
