import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'dart:math';
import 'package:flappy_dash_turbo_trials/game/components/player.dart';
import 'package:flappy_dash_turbo_trials/game/managers/obstacle_spawner.dart';
import 'package:flappy_dash_turbo_trials/core/constants.dart';
import 'dart:ui';

class FlappyGame extends FlameGame
    with HasCollisionDetection, TapCallbacks {
  late Player _player;
  late ObstacleSpawner _obstacleSpawner;

  int score = 0;
  void Function(int)? onGameOver;

  final Random random = Random();
  FlappyGame({this.onGameOver});
  Player get player => _player;

  @override
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(ScreenHitbox());

    // 🔒 Invisible ceiling
    add(
      RectangleComponent(
        position: Vector2(0, 0),
        size: Vector2(size.x, 1),
        paint: Paint()..color = const Color(0x00000000), // transparent
      )..add(RectangleHitbox()),
    );

    // 🔒 Invisible floor
    add(
      RectangleComponent(
        position: Vector2(0, size.y),
        size: Vector2(size.x, 1),
        anchor: Anchor.bottomLeft,
        paint: Paint()..color = const Color(0x00000000),
      )..add(RectangleHitbox()),
    );

    _player = Player(
      onHitObstacle: _handleGameOver,
      onPassObstacle: _incrementScore,
    );
    add(_player);

    _obstacleSpawner = ObstacleSpawner();
    add(_obstacleSpawner);
  }


  void _incrementScore() {
    score += GameConstants.pointsPerObstacle;
    // Every time we pass 10 points, we can increase difficulty:
    if (score % GameConstants.difficultyIncreaseInterval == 0) {
      _obstacleSpawner.increaseBPM(10); // Increase BPM by some fixed amount
    }
  }

  void _handleGameOver() {
    // Notify UI layer
    onGameOver?.call(score);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _player.flap();
  }
}
//We store a reference to Player and ObstacleSpawner.
//
// score is tracked in FlappyGame. When the player passes an obstacle, we call _incrementScore().
//
// If the player collides with an obstacle, we call _handleGameOver() which triggers onGameOver callback. This signals the Flutter layer to show the Game Over screen.
//
// We override onTapDown to pass a flap command to the player.