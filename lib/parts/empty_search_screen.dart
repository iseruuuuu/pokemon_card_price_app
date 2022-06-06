import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/gen/assets.gen.dart';

class EmptySearchScreen extends StatelessWidget {
  const EmptySearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '検索結果がありません',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 30),
          Assets.images.appIcon.image(
            width: 300,
            height: 300,
          ),
        ],
      ),
    );
  }
}
