import 'package:flutter/material.dart';
import 'package:flappy_dash_turbo_trials/game/flappy_game.dart';
import 'package:flame/game.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flappy Dash Turbo Trials'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Play"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GameWidget(
                    game: FlappyGame(
                      onGameOver: (score) {
                        // When the game ends, push the GameOver screen
                        Navigator.pushReplacementNamed(
                          context,
                          '/gameOver',
                          arguments: score,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
//A simple homepage with a button that navigates to the GameWidget.
//
// We instantiate our FlappyGame and provide a callback for onGameOver.