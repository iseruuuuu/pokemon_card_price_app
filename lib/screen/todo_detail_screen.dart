import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/model/pokemon_card.dart';
import 'package:pokemon_card_price_app/parts/register_dialog.dart';
import 'package:pokemon_card_price_app/state/todo_list_store.dart';
import '../model/todo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoDetailScreen extends StatefulWidget {
  final PokemonCard? pokemonCard;
  final Todo? todo;

  const TodoDetailScreen({
    Key? key,
    this.pokemonCard,
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
  late String _createDate;

  @override
  void initState() {
    super.initState();

    var pokemonCard = widget.pokemonCard;
    _shopName = pokemonCard?.shopName ?? "";
    _price = pokemonCard?.price ?? "";
    _isSale = pokemonCard?.isSale ?? false;
    _createDate = pokemonCard?.createDate ?? "";
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
    _shopName = "";
    _price = "";
    _isSale = false;
    setState(() {});
  }

  void onSale(bool? value) {
    //TODO checkboxが状態変化しない

    print(value);
    setState(() {
      _isSale = value ?? false;
    });
  }

  void onStoreChange(String value) {
    _shopName = value;
  }

  void onPriceChange(String value) {
    _price = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            //TODO 画像検索して一番目に取得したい
            const SizedBox(height: 10),
            Image.network(
              'https://m.media-amazon.com/images/I/51agEFmxcuS._AC_.jpg',
              width: 300,
              height: 300,
            ),
            // Image.network('/<img.+src=[\'"]([^\'"]+)[\'"].*>/i'),
            // Text(widget.todo!.createDate),
            // Text(widget.todo!.updateDate),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _store.cardCount(),
                itemBuilder: (context, index) {
                  var item = _store.findCardByIndex(index);
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              const BorderSide(color: Colors.grey, width: 3),
                          top: index == 0
                              ? const BorderSide(color: Colors.grey, width: 3)
                              : const BorderSide(color: Colors.white),
                        ),
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
