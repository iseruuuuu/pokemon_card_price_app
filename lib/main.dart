import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/screen/splash_screen.dart';
import 'package:pokemon_card_price_app/screen/todo_list_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
