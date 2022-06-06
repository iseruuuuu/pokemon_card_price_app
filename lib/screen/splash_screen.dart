import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_card_price_app/screen/todo_list_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xFF5983FE),
      splash: 'assets/images/splash.gif',
      splashIconSize: MediaQuery.of(context).size.width,
      nextScreen: const TodoListScreen(),
    );
  }
}
