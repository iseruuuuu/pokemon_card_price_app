import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_version/new_version.dart';
import 'package:pokemon_card_price_app/gen/assets.gen.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import 'package:pokemon_card_price_app/parts/border_item.dart';
import 'package:pokemon_card_price_app/parts/delete_dialog.dart';
import 'package:pokemon_card_price_app/parts/empty_screen.dart';
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
    final newVersion = NewVersion(
      androidId: 'com.pokemon_card_price_app',
      iOSId: 'com.pokemonCardPriceApp',
      iOSAppStoreCountry: 'JP',
    );
    openUpdateDialog(newVersion);
    loadStore();
    _store.getTodo();
  }

  void loadStore() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _store.load();
      });
    });
  }

  void openUpdateDialog(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      String storeVersion = status.storeVersion;
      String releaseNote = status.releaseNotes.toString();
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'アップデートが必要です。',
        dialogText:
            'Ver.$storeVersionが公開されています。\n最新バージョンにアップデートをお願いします。\n\nバージョンアップ内容は以下の通りです。\n$releaseNote',
        updateButtonText: 'アップデート',
        allowDismissal: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Image(
          image: Assets.images.appBar1,
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _store.isEmpty
          ? const EmptyScreen()
          : ReorderableListView.builder(
              onReorder: (int oldIndex, int newIndex) {
                _store.onReorder(_store.getTodo(), oldIndex, newIndex);
              },
              itemCount: _store.count(),
              itemBuilder: (context, index) {
                var item = _store.findByIndex(index);
                return Slidable(
                  key: ValueKey(index),
                  startActionPane: ActionPane(
                    key: ValueKey(index),
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        key: ValueKey(index),
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
                    key: ValueKey(index),
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        key: ValueKey(index),
                        onPressed: (context) {
                          _store.loadCard(item.id.toString());
                          showDialog<void>(
                            context: context,
                            builder: (_) {
                              return DeleteDialog(
                                onDelete: () {
                                  setState(() {
                                    _store.delete(
                                      todo: item,
                                    );
                                  });
                                },
                              );
                            },
                          );
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
                        contentPadding: const EdgeInsets.only(
                          left: 15,
                          right: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        key: ValueKey(index),
                        title: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: _store.ballItem(
                                item.ball,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.list,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: SizedBox(
        width: 85,
        height: 85,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: _pushTodoInputPage,
          child: const Icon(
            Icons.add,
            size: 60,
          ),
        ),
      ),
    );
  }
}
