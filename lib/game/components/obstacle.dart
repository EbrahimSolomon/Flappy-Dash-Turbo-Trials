import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flappy_dash_turbo_trials/game/flappy_game.dart';
import 'package:flappy_dash_turbo_trials/core/constants.dart';

class Obstacle extends PositionComponent
    with CollisionCallbacks, HasGameRef<FlappyGame> {
  // We can add two SpriteComponents: top and bottom
  late SpriteComponent topObstacle;
  late SpriteComponent bottomObstacle;

  bool hasScored = false; // used to ensure we only increment score once per pair

  Obstacle({Vector2? position})
      : super(
    position: position ?? Vector2.zero(),
    size: Vector2(60, 200), // default widths/heights
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Random vertical offset for the gap
    final gapCenterY = gameRef.size.y * 0.3 +
        (gameRef.size.y * 0.4) * (gameRef.random.nextDouble() - 0.5);

    final gap = GameConstants.obstacleGap;

    // Top obstacle
    topObstacle = SpriteComponent()
      ..sprite = await gameRef.loadSprite('obstacle.png')
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(0, gapCenterY - gap / 2 - size.y)
      ..anchor = Anchor.topLeft;
    topObstacle.add(RectangleHitbox());
    add(topObstacle);

    // Bottom obstacle
    bottomObstacle = SpriteComponent()
      ..sprite = await gameRef.loadSprite('obstacle.png')
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(0, gapCenterY + gap / 2)
      ..anchor = Anchor.topLeft;
    bottomObstacle.add(RectangleHitbox());
    add(bottomObstacle);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move obstacles to the left
    x -= GameConstants.obstacleSpeed * dt;

    // If player passes the obstacle (center of obstacle crosses player's x),
    // increment the score (only once).
    final playerX = gameRef.player.x; // Might need a getter in FlappyGame
    if (!hasScored && x + width < playerX) {
      gameRef.score += GameConstants.pointsPerObstacle;
      hasScored = true;
    }

    // Remove obstacle if it goes off screen completely
    if (x + width < 0) {
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