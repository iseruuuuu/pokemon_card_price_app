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

  Todo findByIndex(int index) {
    return _list[index];
  }

  List<Todo> getTodo() {
    return _list;
  }

  PokemonCard findCardByIndex(int index) {
    return _cardList[index];
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
  }

  void addCard(String shopName, String price, bool isSale, int? cardID) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
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
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = _list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  void saveCard(String password) async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = _cardList.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(password, saveTargetList);
  }

  void load() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StrigList形式 → JSON形式 → Map形式 → TodoList形式
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    _list = loadTargetList.map((a) => Todo.fromJson(json.decode(a))).toList();
  }

  void loadCard(String? password) async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StrigList形式 → JSON形式 → Map形式 → TodoList形式
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
}
