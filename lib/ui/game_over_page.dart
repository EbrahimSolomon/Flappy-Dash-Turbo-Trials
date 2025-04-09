import 'package:flutter/material.dart';

class GameOverPage extends StatelessWidget {
  static const routeName = '/gameOver';

  const GameOverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)!.settings.arguments as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Retry"),
              onPressed: () {
                Navigator.pop(context); // Pop back to HomePage or re-init game
              },
            ),
          ],
        ),
      ),
    );
  }
}
//Displays the final score.
//
// Has a simple “Retry” button to pop back to the home page (or you can push a fresh game route).
//
// Make sure to register the route in MaterialApp if you want named routes: