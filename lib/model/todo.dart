/// Todoモデルのクラス
///
/// 以下の責務を持つ
/// ・Todoのプロパティを持つ
class Todo {
  /// ID
  late int id;

  /// カード名
  late String title;

  /// 作成日時
  late String createDate;

  /// 更新日時
  late String updateDate;

  //ボールの種類
  late int ball;

  /// コンストラクタ
  Todo(
    this.id,
    this.title,
    this.createDate,
    this.updateDate,
    this.ball,
  );

  /// TodoモデルをMapに変換する(保存時に使用)
  Map toJson() {
    return {
      'id': id,
      'title': title,
      'createDate': createDate,
      'updateDate': updateDate,
      'ball': ball,
    };
  }

  /// MapをTodoモデルに変換する(読込時に使用)
  Todo.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
    ball = json['ball'];
  }
}
