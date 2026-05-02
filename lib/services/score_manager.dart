import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static const String _bestScoreKey = 'best_score';
  static const String _gamesPlayedKey = 'games_played';
  static const String _totalScoreKey = 'total_score';

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  Future<int> getBestScore() async {
    await initialize();
    return _prefs.getInt(_bestScoreKey) ?? 0;
  }

  Future<void> saveBestScore(int score) async {
    await initialize();
    final currentBest = await getBestScore();
    if (score > currentBest) {
      await _prefs.setInt(_bestScoreKey, score);
    }
  }

  Future<int> getGamesPlayed() async {
    await initialize();
    return _prefs.getInt(_gamesPlayedKey) ?? 0;
  }

  Future<void> incrementGamesPlayed() async {
    await initialize();
    final current = await getGamesPlayed();
    await _prefs.setInt(_gamesPlayedKey, current + 1);
  }

  Future<int> getTotalScore() async {
    await initialize();
    return _prefs.getInt(_totalScoreKey) ?? 0;
  }

  Future<void> addToTotalScore(int score) async {
    await initialize();
    final current = await getTotalScore();
    await _prefs.setInt(_totalScoreKey, current + score);
  }

  Future<void> resetAllScores() async {
    await initialize();
    await _prefs.remove(_bestScoreKey);
    await _prefs.remove(_gamesPlayedKey);
    await _prefs.remove(_totalScoreKey);
  }
}
