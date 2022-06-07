import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/gen/assets.gen.dart';
import 'package:pokemon_card_price_app/model/pokemon_card.dart';
import 'package:pokemon_card_price_app/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class TodoListStore {
  final String _saveKey = "Todo";
  List<Todo> _list = [];
  List<PokemonCard> _cardList = [];
  static final TodoListStore _instance = TodoListStore._internal();
  List<PokemonCard> _searchCardList = [];
  bool isSearchEmpty = false;
  bool isEmpty = false;

  TodoListStore._internal();

  factory TodoListStore() {
    return _instance;
  }

  int count() {
    return _list.length;
  }

  int cardCount() {
    return _cardList.length;
  }

  int searchCardCount() {
    return _searchCardList.length;
  }

  Todo findByIndex(int index) {
    return _list[index];
  }

  List<Todo> getTodo() {
    return _list;
  }

  List<PokemonCard> getCard() {
    return _cardList;
  }

  PokemonCard findCardByIndex(int index) {
    return _cardList[index];
  }

  List<PokemonCard> getSearchCard() {
    return _searchCardList;
  }

  PokemonCard findSearchByIndex(int index) {
    return _searchCardList[index];
  }

  void checkListEmpty() {
    if (_list.isEmpty) {
      isEmpty = true;
    } else {
      isEmpty = false;
    }
  }

  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  String getDate() {
    var format = DateFormat("yyyy/MM/dd");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  Widget ballItem(int ball) {
    switch (ball) {
      case 1:
        return Assets.ball.ball1.image();
      case 2:
        return Assets.ball.ball2.image();
      case 3:
        return Assets.ball.ball3.image();
      case 4:
        return Assets.ball.ball4.image();
      default:
        return Assets.ball.ball5.image();
    }
  }

  void add(String title, int ball) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var dateTime = getDateTime();
    var todo = Todo(id, title, dateTime, dateTime, ball);
    _list.add(todo);
    save();
    checkListEmpty();
  }

  void addCard(String shopName, int price, bool isSale, int? cardID) {
    var id = cardCount() == 0 ? 1 : _cardList.last.id + 1;
    var createDate = getDate();
    var card = PokemonCard(id, shopName, price, isSale, createDate);
    _cardList.add(card);
    saveCard(cardID.toString());
  }

  void update(Todo todo, [String? title]) {
    if (title != null) {
      todo.title = title;
    }
    todo.updateDate = getDateTime();
    save();
  }

  void delete({required Todo todo}) {
    deleteAllCard(index: todo.id);
    _list.remove(todo);
    save();
    checkListEmpty();
  }

  void deleteAllCard({required int index}) {
    _cardList.clear();
    saveCard(index.toString());
  }

  void deleteCard(PokemonCard pokemonCard) {
    _cardList.remove(pokemonCard);
    saveCard(pokemonCard.id.toString());
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();
    var saveTargetList = _list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  void saveCard(String password) async {
    var prefs = await SharedPreferences.getInstance();
    var saveTargetList = _cardList.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(password, saveTargetList);
  }

  void load() async {
    var prefs = await SharedPreferences.getInstance();
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    _list = loadTargetList.map((a) => Todo.fromJson(json.decode(a))).toList();
    checkListEmpty();
  }

  void loadCard(String? password) async {
    var prefs = await SharedPreferences.getInstance();
    var loadTargetList = prefs.getStringList(password ?? '') ?? [];
    _cardList = loadTargetList
        .map((a) => PokemonCard.fromJson(json.decode(a)))
        .toList();
  }

  void onReorder(List<Todo> todo, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    todo.insert(newIndex, todo.removeAt(oldIndex));
    save();
  }

  void onCardReorder(
      List<PokemonCard> pokemonCard, int oldIndex, int newIndex, int cardID) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    pokemonCard.insert(newIndex, pokemonCard.removeAt(oldIndex));
    saveCard(cardID.toString());
    save();
  }

  void sortCardList({required int todoID, required int selectSort}) {
    switch (selectSort) {
      case 0:
        //新しい順
        _cardList.sort((a, b) => b.id.compareTo(a.id));
        save();
        saveCard(todoID.toString());
        break;
      case 1:
        //店名（abc or あいうえお順）
        _cardList.sort((a, b) => a.shopName.compareTo(b.shopName));
        save();
        saveCard(todoID.toString());
        break;
      case 2:
        //価格の安い順
        _cardList.sort((a, b) => a.price.compareTo(b.price));
        save();
        saveCard(todoID.toString());
        break;
      case 3:
        //価格の高い順
        _cardList.sort((a, b) => b.price.compareTo(a.price));
        save();
        saveCard(todoID.toString());
        break;
      case 4:
        //特価順（特価のみを上にする。その他の順番は気にしない）
        _cardList.sort((a, b) {
          int result = b.isSale.toString().compareTo(a.isSale.toString());
          if (result != 0) return result;
          return a.price.compareTo(b.price);
        });
        save();
        saveCard(todoID.toString());
        break;
      default:
        break;
    }
  }

  void searchCard(String text, String todoID) {
    _searchCardList = [];
    for (int i = 0; i < _cardList.length; i++) {
      if (_cardList[i].shopName.contains(text)) {
        var cardList = _cardList[i];
        _searchCardList.add(cardList);
      }
    }
    if (_searchCardList.isEmpty) {
      isSearchEmpty = true;
    } else {
      isSearchEmpty = false;
    }
  }

  void resetSearchCardList() {
    _searchCardList = [];
    isSearchEmpty = false;
  }
}
