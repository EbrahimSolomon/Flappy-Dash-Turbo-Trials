import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flappy_dash_turbo_trials/game/components/obstacle.dart';
import 'package:flappy_dash_turbo_trials/game/flappy_game.dart';
import 'package:flappy_dash_turbo_trials/core/constants.dart';
import 'package:flappy_dash_turbo_trials/game/components/obstacle_pipe.dart';


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

    // Clamp position within top and bottom of the screen
    if (y < size.y / 2) {
      y = size.y / 2;
      velocity.y = 0;
    }

    if (y > gameRef.size.y - size.y / 2) {
      y = gameRef.size.y - size.y / 2;
      velocity.y = 0;
    }
  }


  void flap() {
    velocity.y = GameConstants.flapForce;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    print('Player collided with: ${other.runtimeType}');

    // ✅ Game over only when hitting a pipe
    if (other is ObstaclePipe) {
      print('☠️ Collision with obstacle pipe!');
      onHitObstacle?.call();
    }
  }
}
//Key Points:
//
// velocity is updated each frame by adding gravity.
//
// onCollision checks if we’re colliding with an obstacle. If so, triggers onHitObstacle.