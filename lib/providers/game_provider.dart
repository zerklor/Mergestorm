import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../services/game_engine.dart';
import '../services/score_manager.dart';
import '../services/audio_manager.dart';
import '../services/shop_manager.dart';
import '../services/ad_manager.dart';
import '../models/game_state.dart';

class GameProvider extends ChangeNotifier {
  late GameEngine _gameEngine;
  late ScoreManager _scoreManager;
  late AudioManager _audioManager;
  bool _sessionRewardGranted = false;

  GameProvider() {
    _gameEngine = GameEngine();
    _scoreManager = ScoreManager();
    _audioManager = AudioManager();
  }

  GameState get gameState => _gameEngine.state;
  GameEngine get gameEngine => _gameEngine;
  ScoreManager get scoreManager => _scoreManager;
  AudioManager get audioManager => _audioManager;

  Future<void> initialize() async {
    try {
      final storedBestScore = await _scoreManager.getBestScore();
      _gameEngine.setBestScore(storedBestScore);
      await _audioManager.initialize();
      await _audioManager.playBackgroundMusic();
      _sessionRewardGranted = false;
    } catch (e) {
      if (kDebugMode) {
        print('Audio initialization error: $e');
      }
      // Continue même si l'audio échoue
    }
    notifyListeners();
  }

  Future<void> _triggerVibration(bool vibrationEnabled) async {
    if (vibrationEnabled) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (e) {
        if (kDebugMode) {
          print('Vibration error: $e');
        }
      }
    }
  }

  void moveUp({bool vibrationEnabled = true}) async {
    try {
      if (_gameEngine.move(MoveDirection.up)) {
        await _triggerVibration(vibrationEnabled);
        await _audioManager.playMoveSound();
        await _scoreManager.saveBestScore(_gameState.score);
        _checkGameEnd();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error moving up: $e');
      }
    }
  }

  void moveDown({bool vibrationEnabled = true}) async {
    try {
      if (_gameEngine.move(MoveDirection.down)) {
        await _triggerVibration(vibrationEnabled);
        await _audioManager.playMoveSound();
        await _scoreManager.saveBestScore(_gameState.score);
        _checkGameEnd();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error moving down: $e');
      }
    }
  }

  void moveLeft({bool vibrationEnabled = true}) async {
    try {
      if (_gameEngine.move(MoveDirection.left)) {
        await _triggerVibration(vibrationEnabled);
        await _audioManager.playMoveSound();
        await _scoreManager.saveBestScore(_gameState.score);
        _checkGameEnd();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error moving left: $e');
      }
    }
  }

  void moveRight({bool vibrationEnabled = true}) async {
    try {
      if (_gameEngine.move(MoveDirection.right)) {
        await _triggerVibration(vibrationEnabled);
        await _audioManager.playMoveSound();
        await _scoreManager.saveBestScore(_gameState.score);
        _checkGameEnd();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error moving right: $e');
      }
    }
  }

  void _checkGameEnd() async {
    try {
      if (_gameState.won) {
        await _audioManager.playWinSound();
      } else if (_gameState.gameOver) {
        await _audioManager.playGameOverSound();
        await _scoreManager.saveBestScore(_gameState.score);
        await _scoreManager.incrementGamesPlayed();
        await _scoreManager.addToTotalScore(_gameState.score);
        AdManager.recordCompletedGame();
        if (!_sessionRewardGranted) {
          await ShopManager.instance.addCoinsFromGame(_gameState.score);
          _sessionRewardGranted = true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking game end: $e');
      }
    }
  }

  GameState get _gameState => _gameEngine.state;

  Future<void> resetGame() async {
    try {
      await _scoreManager.saveBestScore(_gameState.score);
      if (!_sessionRewardGranted && _gameState.score > 0) {
        await ShopManager.instance.addCoinsFromGame(_gameState.score);
        _sessionRewardGranted = true;
      }
      await AdManager.maybeShowInterstitial();
      _gameEngine.reset();
      _sessionRewardGranted = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting game: $e');
      }
    }
  }

  Future<void> persistBestScore() async {
    try {
      await _scoreManager.saveBestScore(_gameState.score);
    } catch (e) {
      if (kDebugMode) {
        print('Error persisting best score: $e');
      }
    }
  }

  Future<void> rewardCurrentSession() async {
    try {
      if (!_sessionRewardGranted && _gameState.score > 0) {
        await ShopManager.instance.addCoinsFromGame(_gameState.score);
        _sessionRewardGranted = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error rewarding session: $e');
      }
    }
  }

  Future<void> continuePlaying() async {
    try {
      _gameEngine.continuePlaying();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error continuing game: $e');
      }
    }
  }

  void setSoundEnabled(bool enabled) {
    _audioManager.setSoundEnabled(enabled);
  }

  void setMusicEnabled(bool enabled) {
    _audioManager.setMusicEnabled(enabled);
  }

  @override
  void dispose() {
    _audioManager.stopBackgroundMusic();
    _audioManager.dispose();
    super.dispose();
  }
}
