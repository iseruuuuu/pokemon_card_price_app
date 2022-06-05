import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import 'package:pokemon_card_price_app/parts/border_item.dart';
import 'package:pokemon_card_price_app/parts/card_dialog.dart';
import 'package:pokemon_card_price_app/parts/register_dialog.dart';
import 'package:pokemon_card_price_app/state/todo_list_store.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo? todo;

  const TodoDetailScreen({
    Key? key,
    this.todo,
  }) : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final TodoListStore _store = TodoListStore();
  late String _shopName;
  late String _price;
  late bool _isSale;

  @override
  void initState() {
    super.initState();
    resetCard();
  }

  void openDialog() {
    showDialog<void>(
      context: context,
      builder: (_) {
        return RegisterDialog(
          onSale: onSale,
          onRegister: onRegister,
          priceController: TextEditingController(text: _price),
          storeController: TextEditingController(text: _shopName),
          onPriceChange: onPriceChange,
          onStoreChange: onStoreChange,
          isSale: _isSale,
        );
      },
    );
  }

  void onRegister() {
    _store.addCard(_shopName, _price, _isSale, widget.todo?.id);
    Navigator.of(context).pop();
    resetCard();
    setState(() {});
  }

  void onSale(value) {
    setState(() {
      _isSale = value;
    });
  }

  void onStoreChange(String value) {
    _shopName = value;
  }

  void onPriceChange(String value) {
    _price = value;
  }

  void resetCard() {
    _shopName = "";
    _price = "";
    _isSale = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.todo!.title),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: openDialog,
            iconSize: 40,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/app_icon.png',
              width: 150,
              height: 150,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _store.cardCount(),
                itemBuilder: (context, index) {
                  var item = _store.findCardByIndex(index);
                  //TODO Cellが空になっているかどうかのチェックをできるようにする
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              _store.deleteCard(item);
                            });
                          },
                          backgroundColor: Colors.red,
                          icon: Icons.edit,
                          label: '削除',
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onLongPress: () async {
                        showDialog<void>(
                          context: context,
                          builder: (_) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return CardDialog(
                                shopName: item.shopName,
                                price: item.price,
                                createdTime: item.createDate,
                                isSale: item.isSale,
                              );
                            });
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: index == 0
                              ? BorderItem.borderFirst()
                              : BorderItem.borderOther(),
                        ),
                        child: ListTile(
                          title: Text(
                            item.shopName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            item.isSale ? '特価' : '',
                            style: TextStyle(
                              color: item.isSale ? Colors.red : Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Text(
                            item.price + '円',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
