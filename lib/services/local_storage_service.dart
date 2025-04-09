import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _highScoreKey = 'highScore';

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> setHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_highScoreKey, score);
  }
}
//Use:
//
// dart
// Copy
// Edit
// final localStorage = LocalStorageService();
// await localStorage.setHighScore(currentScore);
// final bestScore = await localStorage.getHighScore();
// You can integrate this into FlappyGame or the GameOverPage after each run.