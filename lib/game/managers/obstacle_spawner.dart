import 'package:flame/components.dart';
import 'package:flappy_dash_turbo_trials/game/components/obstacle.dart';
import 'package:flappy_dash_turbo_trials/game/flappy_game.dart';
import 'package:flappy_dash_turbo_trials/core/constants.dart';

class ObstacleSpawner extends Component with HasGameRef<FlappyGame> {
  late Timer _spawnTimer;
  double _currentBpm = GameConstants.baseBpm;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spawnTimer = Timer(
      _intervalFromBPM(_currentBpm),
      onTick: spawnObstacle,
      repeat: true,
    )..start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer.update(dt);
  }

  void spawnObstacle() {
    final obstacle = Obstacle(
      position:
      // Start off the right edge:
      // The X position can be something like gameRef.size.x + 40
      // So there's no immediate jump on screen
      // Y is 0 if top-left is zero-based.
      // We handle top/bottom inside the Obstacle itself, so just 0 here:
      Vector2(gameRef.size.x + 40, 0),
    );
    gameRef.add(obstacle);
  }

  // Increments BPM to spawn faster. You can also do other difficulty changes
  void increaseBPM(double amount) {
    _currentBpm += amount;
    _spawnTimer.stop();
    _spawnTimer = Timer(
      _intervalFromBPM(_currentBpm),
      onTick: spawnObstacle,
      repeat: true,
    )..start();
  }

  double _intervalFromBPM(double bpm) {
    // Convert BPM to spawn interval in seconds
    return 60.0 / bpm;
  }
}
//We store _currentBpm and create a Timer that spawns obstacles on each tick.
//
// As you increase BPM, the interval shortens, meaning obstacles spawn more frequently.
//
// The _intervalFromBPM function is a quick helper for BPM to seconds.