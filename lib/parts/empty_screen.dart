import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/gen/assets.gen.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            '＋で追加しよう',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          Assets.images.appIcon.image(
            width: 140,
            height: 140,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
