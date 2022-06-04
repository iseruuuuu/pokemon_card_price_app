import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pokemon_card_price_app/model/pokemon_card.dart';
import 'package:pokemon_card_price_app/screen/todo_detail_screen.dart';
import 'package:pokemon_card_price_app/screen/todo_input_screen.dart';
import '../state/todo_list_store.dart';
import '../model/todo.dart';

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

  void _pushTodoDetailPage([Todo? todo, PokemonCard? pokemonCard]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          //TODO 後で記載する
          return TodoDetailScreen(
            todo: todo,
            pokemonCard: pokemonCard,
          );
        },
      ),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // _store.load();
    loadStore();
  }

  void loadStore() {
    Future.delayed(
      Duration.zero,
      () {
        setState(() {
          _store.load();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _store.count(),
        itemBuilder: (context, index) {
          var item = _store.findByIndex(index);
          return Slidable(
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
                    // Todoを削除し、画面を更新する
                    setState(() => {_store.delete(item)});
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.edit,
                  label: '削除',
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: const BorderSide(color: Colors.grey),
                  top: index == 0
                      ? const BorderSide(color: Colors.grey)
                      : const BorderSide(color: Colors.white),
                ),
              ),
              child: GestureDetector(
                onDoubleTap: () {
                  _pushTodoDetailPage(item);
                  _store.loadCard(item.id.toString());
                },
                onTap: () {
                  _pushTodoDetailPage(item);
                  _store.loadCard(item.id.toString());
                },
                child: ListTile(
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          );
        },
      ),
      // Todo追加画面に遷移するボタン
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
