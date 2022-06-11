import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import 'package:pokemon_card_price_app/parts/border_item.dart';
import 'package:pokemon_card_price_app/parts/card_dialog.dart';
import 'package:pokemon_card_price_app/parts/empty_card_screen.dart';
import 'package:pokemon_card_price_app/parts/empty_search_screen.dart';
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
  late TextEditingController searchTextController;
  var selectSort = 2;
  var searchWord = '';
  bool isSearch = false;

  final sort = [
    "新しい順",
    "あいうえお順",
    "価格の安い順",
    "価格の高い順",
    "特価順",
  ];

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
    var price = int.parse(_price);
    _store.addCard(_shopName, price, _isSale, widget.todo?.id);
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
    searchTextController = TextEditingController(text: searchWord);
  }

  void search(String value) {
    searchWord = value;
    if (searchWord.isEmpty) {
      isSearch = false;
      _store.resetSearchCardList();
    } else {
      isSearch = true;
      _store.searchCard(
        searchWord,
        widget.todo!.id.toString(),
      );
    }
    setState(() {});
  }

  void reset() {
    setState(() {
      isSearch = false;
      searchTextController.text = '';
    });
    _store.resetSearchCardList();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
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
        child: _store.isCardEmpty
            ? const EmptyCardScreen()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: Colors.black12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          color: Colors.white,
                          child: TextField(
                            maxLength: 12,
                            autocorrect: false,
                            textInputAction: TextInputAction.search,
                            decoration: const InputDecoration(
                              counterText: '',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            controller: searchTextController,
                            onChanged: search,
                          ),
                        ),
                        IconButton(
                          onPressed: reset,
                          iconSize: 40,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 250,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectSort,
                            ),
                            itemExtent: 30,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectSort = index;
                              });
                            },
                            children: sort.map((e) => Text(e)).toList(),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _store.sortCardList(
                                todoID: widget.todo!.id,
                                selectSort: selectSort,
                              );
                            });
                          },
                          child: const Text(
                            '並び替え',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _store.isSearchEmpty
                        ? const EmptySearchScreen()
                        : !isSearch
                            ? defaultListView()
                            : searchListView(),
                  ),
                ],
              ),
      ),
    );
  }

  ReorderableListView defaultListView() {
    return ReorderableListView.builder(
      onReorder: (int oldIndex, int newIndex) {
        _store.onCardReorder(
          _store.getCard(),
          oldIndex,
          newIndex,
          widget.todo!.id,
        );
      },
      itemCount: _store.cardCount(),
      itemBuilder: (context, index) {
        var item = _store.findCardByIndex(index);
        return Slidable(
          key: ValueKey(index),
          endActionPane: ActionPane(
            key: ValueKey(index),
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                key: ValueKey(index),
                onPressed: (context) {
                  setState(() {
                    _store.deleteCard(item, widget.todo!.id.toString());
                  });
                },
                backgroundColor: Colors.red,
                icon: Icons.edit,
                label: '削除',
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () async {
              showDialog<void>(
                context: context,
                builder: (_) {
                  return StatefulBuilder(builder: (context, setState) {
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
                key: ValueKey(index),
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
                  // item.price + '円',
                  '${item.price}円',
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
    );
  }

  ListView searchListView() {
    return ListView.builder(
      itemCount: _store.searchCardCount(),
      itemBuilder: (context, index) {
        var item = _store.findSearchByIndex(index);
        return GestureDetector(
          onTap: () async {
            showDialog<void>(
              context: context,
              builder: (_) {
                return StatefulBuilder(builder: (context, setState) {
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
              key: ValueKey(index),
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
                '${item.price}円',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
