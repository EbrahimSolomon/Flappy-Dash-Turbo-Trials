class GameConstants {
  // General
  static const double gravity = 500;             // Vertical acceleration (pixels/s^2)
  static const double flapForce = -300;          // Upward velocity when flapping
  static const double obstacleGap = 120;         // Default gap between top/bottom obstacles
  static const double obstacleSpeed = 150;       // Obstacle scroll speed (pixels/s)

  // Timing / BPM
  static const double baseBpm = 120.0;           // Starting BPM
  static const double difficultyIncreaseInterval = 10; // Increase BPM every 10 points

  // Score / Gameplay
  static const int pointsPerObstacle = 1;        // Score increment passing each obstacle

  // Player
  static const double playerSize = 48;           // Basic sprite size
  static const double playerStartX = 100;        // Starting x-position for the player

  // Power-Ups
  static const double powerUpSpawnInterval = 10; // seconds
// ... etc.
}
//Use GameConstants anywhere you want to reference these shared values (to keep your code consistent and flexible).