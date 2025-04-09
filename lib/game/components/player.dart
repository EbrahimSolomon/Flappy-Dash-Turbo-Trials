import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';

import 'package:flappy_dash_turbo_trials/game/flappy_game.dart';
import 'package:flappy_dash_turbo_trials/core/constants.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<FlappyGame> {
  Vector2 velocity = Vector2.zero();
  final void Function()? onHitObstacle;
  final void Function()? onPassObstacle; // Not used directly here but you could pass up if needed.

  Player({this.onHitObstacle, this.onPassObstacle})
      : super(size: Vector2.all(GameConstants.playerSize), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player_bird.png');
    position = Vector2(GameConstants.playerStartX, gameRef.size.y / 2);

    // Add a hitbox for collision detection
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    velocity.y += GameConstants.gravity * dt;
    position += velocity * dt;

    // If we fall below the screen, game over
    if (y > gameRef.size.y + size.y) {
      onHitObstacle?.call();
    }
  }

  void flap() {
    velocity.y = GameConstants.flapForce;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // If we collided with an Obstacle, call onHitObstacle
    if (other is SpriteComponent && other is! Player) {
      onHitObstacle?.call();
    }
  }
}
//Key Points:
//
// velocity is updated each frame by adding gravity.
//
// onCollision checks if we’re colliding with an obstacle. If so, triggers onHitObstacle.