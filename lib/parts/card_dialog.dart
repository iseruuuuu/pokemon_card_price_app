import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/parts/children/dialog_text.dart';

class CardDialog extends StatelessWidget {
  final String shopName;
  final String price;
  final String createdTime;
  final bool isSale;

  const CardDialog({
    required this.shopName,
    required this.price,
    required this.createdTime,
    required this.isSale,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          DialogText(title: '店舗名', subTitle: shopName),
          DialogText(title: '金額', subTitle: price + '円'),
          DialogText(title: '登録日', subTitle: createdTime),
          DialogText(
            title: '',
            subTitle: isSale ? '特価品' : '',
            textColor: isSale ? Colors.red : Colors.black,
          ),
        ],
      ),
    );
  }
}
