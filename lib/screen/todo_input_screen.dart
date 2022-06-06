import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/gen/assets.gen.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import 'package:pokemon_card_price_app/parts/image_button.dart';
import 'package:pokemon_card_price_app/state/todo_list_store.dart';

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
  late int _ball;

  @override
  void initState() {
    super.initState();
    var todo = widget.todo;
    _title = todo?.title ?? "";
    _createDate = todo?.createDate ?? "";
    _updateDate = todo?.updateDate ?? "";
    _isCreateTodo = todo == null;
    _ball = todo?.ball ?? 1;
    checkImage();
  }

  var ball1 = true;
  var ball2 = false;
  var ball3 = false;
  var ball4 = false;

  checkImage() {
    switch (_ball) {
      case 1:
        ball1 = true;
        ball2 = ball3 = ball4 = false;
        break;
      case 2:
        ball2 = true;
        ball1 = ball3 = ball4 = false;
        break;
      case 3:
        ball3 = true;
        ball1 = ball2 = ball4 = false;
        break;
      case 4:
        ball4 = true;
        ball1 = ball2 = ball3 = false;
        break;
      default:
        break;
    }
  }

  void selectBall(int selectBall) {
    setState(() {
      switch (selectBall) {
        case 1:
          _ball = 1;
          ball1 = true;
          ball2 = ball3 = ball4 = false;
          break;
        case 2:
          _ball = 2;
          ball2 = true;
          ball1 = ball3 = ball4 = false;
          break;
        case 3:
          _ball = 3;
          ball3 = true;
          ball1 = ball2 = ball4 = false;
          break;
        case 4:
          _ball = 4;
          ball4 = true;
          ball1 = ball2 = ball3 = false;
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_isCreateTodo ? 'カード追加' : 'カード更新'),
        elevation: 0,
      ),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextField(
                    maxLength: 12,
                    autofocus: true,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageButton(
                        isSelected: ball1,
                        image: Assets.ball.ball1.image(),
                        onTap: () => selectBall(1),
                      ),
                      ImageButton(
                        isSelected: ball2,
                        image: Assets.ball.ball2.image(),
                        onTap: () => selectBall(2),
                      ),
                      ImageButton(
                        isSelected: ball3,
                        image: Assets.ball.ball3.image(),
                        onTap: () => selectBall(3),
                      ),
                      ImageButton(
                        isSelected: ball4,
                        image: Assets.ball.ball4.image(),
                        onTap: () => selectBall(4),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_isCreateTodo) {
                              _store.add(_title, _ball);
                            } else {
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
