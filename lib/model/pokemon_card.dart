class PokemonCard {
  /// ID
  late int id;

  /// お店名
  late String shopName;

  late int price;

  //セールかどうか
  late bool isSale;

  /// 購入日
  late String createDate;

  /// コンストラクタ
  PokemonCard(
    this.id,
    this.shopName,
    this.price,
    this.isSale,
    this.createDate,
  );

  /// TodoモデルをMapに変換する(保存時に使用)
  Map toJson() {
    return {
      'id': id,
      'shopName': shopName,
      'isSale': isSale,
      'price': price,
      'createDate': createDate,
    };
  }

  /// MapをTodoモデルに変換する(読込時に使用)
  PokemonCard.fromJson(Map json) {
    id = json['id'];
    shopName = json['shopName'];
    isSale = json['isSale'];
    price = json['price'];
    createDate = json['createDate'];
  }
}
