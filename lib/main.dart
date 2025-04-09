import 'package:flame/game.dart';
import 'package:flappy_dash_turbo_trials/ui/game_over_page.dart';
import 'package:flappy_dash_turbo_trials/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flappy_dash_turbo_trials/ui/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlappyDashApp());
}

class FlappyDashApp extends StatelessWidget {
  const FlappyDashApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Dash Turbo Trials',
      routes: {
        '/gameOver': (context) => const GameOverPage(),
        '/settings': (context) => const SettingsPage(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
//We wrap everything in a standard Flutter MaterialApp.
//
// HomePage is where we’ll provide a “Play” button to go to our game.