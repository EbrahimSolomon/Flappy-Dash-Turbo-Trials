import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flappy_dash_turbo_trials/game/flappy_game.dart';
import 'package:flappy_dash_turbo_trials/core/constants.dart';
import 'package:flappy_dash_turbo_trials/game/components/obstacle_pipe.dart';
import 'dart:math' as math;

class Obstacle extends PositionComponent
    with CollisionCallbacks, HasGameRef<FlappyGame> {
  late ObstaclePipe topPipe;
  late ObstaclePipe bottomPipe;

  bool hasScored = false;

  Obstacle({
    Vector2? position,
  }) : super(
    position: position ?? Vector2.zero(),
    // The bounding box that contains both pipes. We'll position them inside it.
    size: Vector2(60, 200),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final gapCenterY = gameRef.size.y * 0.3 +
        (gameRef.size.y * 0.4) * (gameRef.random.nextDouble() - 0.5);

    final gap = GameConstants.obstacleGap;

    topPipe = ObstaclePipe()
      ..sprite = await gameRef.loadSprite('obstacle.png')
      ..size = Vector2(size.x, size.y)
      ..angle = math.pi
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(0, gapCenterY - gap / 2);

    topPipe.add(RectangleHitbox());
    add(topPipe);

    bottomPipe = ObstaclePipe()
      ..sprite = await gameRef.loadSprite('obstacle.png')
      ..size = Vector2(size.x, size.y)
      ..anchor = Anchor.topLeft
      ..position = Vector2(0, gapCenterY + gap / 2);

    bottomPipe.add(RectangleHitbox());
    add(bottomPipe);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move left at a constant speed
    x -= GameConstants.obstacleSpeed * dt;

    // Once the player's x surpasses (x + width), the player has passed the pipes => increment score
    final playerX = gameRef.player.x;
    if (!hasScored && (x + width) < playerX) {
      gameRef.score += GameConstants.pointsPerObstacle;
      hasScored = true;
    }

    // Remove once the obstacle is fully off-screen
    if ((x + width) < 0) {
      removeFromParent();
    }
  }
}

//Each Obstacle is effectively a pair of top/bottom pipes (or obstacles).
//
// We set a random vertical gap location.
//
// We move left at a fixed speed. Once off-screen, we remove ourselves from the game tree.
//
// We also handle one-time scoring (the “player has passed me” check).
//
// Important: Notice the reference to gameRef.player.x. You might want to expose your player’s position via a getter in FlappyGame or pass it into the Obstacle.
// Alternatively, keep track of it in FlappyGame’s update. The snippet above is just one approach.