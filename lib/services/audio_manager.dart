import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  late AudioPlayer _audioPlayer;
  bool _soundEnabled = true;  // Activé par défaut
  late AudioPlayer _backgroundMusic;
  bool _musicEnabled = true;  // Activé par défaut

  AudioManager() {
    _audioPlayer = AudioPlayer();
    _backgroundMusic = AudioPlayer();
  }

  Future<void> initialize() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _backgroundMusic.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing audio: $e');
      }
    }
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      _backgroundMusic.stop();
    }
  }

  void updateSettings(bool soundEnabled, bool musicEnabled) {
    setSoundEnabled(soundEnabled);
    setMusicEnabled(musicEnabled);
  }

  Future<void> playMoveSound() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/move.ogg'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing move sound: $e');
      }
    }
  }

  Future<void> playMergeSound() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/merge.ogg'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing merge sound: $e');
      }
    }
  }

  Future<void> playGameOverSound() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/game_over.ogg'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing game over sound: $e');
      }
    }
  }

  Future<void> playWinSound() async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/win.ogg'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing win sound: $e');
      }
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;
    try {
      await _backgroundMusic.play(AssetSource('sounds/background.ogg'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing background music: $e');
      }
      // Continuer même si le son échoue
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundMusic.stop();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _backgroundMusic.dispose();
  }
}
