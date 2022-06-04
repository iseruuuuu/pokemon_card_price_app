import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import 'package:pokemon_card_price_app/parts/border_item.dart';
import 'package:pokemon_card_price_app/screen/todo_detail_screen.dart';
import 'package:pokemon_card_price_app/screen/todo_input_screen.dart';
import 'package:pokemon_card_price_app/state/todo_list_store.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoListStore _store = TodoListStore();

  void _pushTodoInputPage([Todo? todo]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TodoInputScreen(todo: todo);
        },
      ),
    );
    setState(() {});
  }

  void _pushTodoDetailPage([Todo? todo]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TodoDetailScreen(todo: todo);
        },
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadStore();
  }

  void loadStore() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _store.load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: ListView.builder(
        itemCount: _store.count(),
        itemBuilder: (context, index) {
          var item = _store.findByIndex(index);
          return _store.count() != 0
              ? Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _pushTodoInputPage(item);
                        },
                        backgroundColor: Colors.yellow,
                        icon: Icons.edit,
                        label: '編集',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _store.loadCard(item.id.toString());
                          setState(() {
                            _store.delete(
                              todo: item,
                              pokemonCard: _store.getCardList(),
                            );
                          });
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.edit,
                        label: '削除',
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: index == 0
                          ? BorderItem.borderFirst()
                          : BorderItem.borderOther(),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _pushTodoDetailPage(item);
                        _store.loadCard(item.id.toString());
                      },
                      child: ListTile(
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                )
              //TODOリストが空の時の画面を作成する
              : Container(color: Colors.red);
        },
      ),
      floatingActionButton: SizedBox(
        width: 90,
        height: 90,
        child: FloatingActionButton(
          onPressed: _pushTodoInputPage,
          child: const Icon(
            Icons.add,
            size: 50,
          ),
        ),
      ),
    );
  }
}
