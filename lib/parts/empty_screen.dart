import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/gen/assets.gen.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.red,
                  size: 40,
                ),
                Text(
                  'でカードを追加しよう',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Assets.images.appIcon.image(
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
