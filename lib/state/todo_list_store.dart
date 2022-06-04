import 'package:pokemon_card_price_app/model/pokemon_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../model/todo.dart';

/// Todoストアのクラス
///
/// ※当クラスはシングルトンとなる
///
/// 以下の責務を持つ
/// ・Todoを取得/追加/更新/削除/保存/読込する
class TodoListStore {
  /// 保存時のキー
  final String _saveKey = "Todo";

  /// Todoリスト
  List<Todo> _list = [];

  List<PokemonCard> _cardList = [];

  /// ストアのインスタンス
  static final TodoListStore _instance = TodoListStore._internal();

  /// プライベートコンストラクタ
  TodoListStore._internal();

  /// ファクトリーコンストラクタ
  /// (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory TodoListStore() {
    return _instance;
  }

  /// Todoの件数を取得する
  int count() {
    return _list.length;
  }

  int cardCount() {
    return _cardList.length;
  }

  /// 指定したインデックスのTodoを取得する
  Todo findByIndex(int index) {
    return _list[index];
  }

  PokemonCard findCardByIndex(int index) {
    return _cardList[index];
  }

  /// "yyyy/MM/dd HH:mm"形式で日時を取得する
  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  /// Todoを追加する
  void add(String title) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var dateTime = getDateTime();
    var todo = Todo(id, title, dateTime, dateTime);
    _list.add(todo);
    save();
  }

  //PokemonCardを追加
  void addCard(String shopName, String price, bool isSale, int? cardID) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var createDate = getDateTime();
    var card = PokemonCard(id, shopName, price, isSale, createDate);
    _cardList.add(card);
    saveCard(cardID.toString());
  }

  /// Todoを更新する
  void update(Todo todo, [String? title]) {
    if (title != null) {
      todo.title = title;
    }
    todo.updateDate = getDateTime();
    save();
  }

  /// Todoを削除する
  void delete(Todo todo) {
    _list.remove(todo);
    save();
  }

  void deleteCard(PokemonCard pokemonCard) {
    _cardList.remove(pokemonCard);
    saveCard(pokemonCard.id.toString());
  }

  /// Todoを保存する
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = _list.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  void saveCard(String password) async {
    print(password);
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetList = _cardList.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(password, saveTargetList);
  }

  /// Todoを読込する
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
}
