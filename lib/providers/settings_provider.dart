import 'package:flutter/foundation.dart';
import '../services/settings_manager.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsManager _settingsManager = SettingsManager();

  bool _soundEnabled = true;
  double _soundVolume = 1.0;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;
  int _animationSpeed = 1; // 0=Lent, 1=Normal, 2=Rapide
  bool _mergeSoundEnabled = true;
  bool _initialized = false;

  // Getters
  bool get soundEnabled => _soundEnabled;
  double get soundVolume => _soundVolume;
  bool get musicEnabled => _musicEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  int get animationSpeed => _animationSpeed;
  bool get mergeSoundEnabled => _mergeSoundEnabled;
  bool get initialized => _initialized;

  Future<void> initialize() async {
    await _settingsManager.init();
    _soundEnabled = await _settingsManager.getSoundEnabled();
    _soundVolume = await _settingsManager.getSoundVolume();
    _musicEnabled = await _settingsManager.getMusicEnabled();
    _vibrationEnabled = await _settingsManager.getVibrationEnabled();
    _darkModeEnabled = await _settingsManager.getDarkModeEnabled();
    _animationSpeed = await _settingsManager.getAnimationSpeed();
    _mergeSoundEnabled = await _settingsManager.getMergeSoundEnabled();
    _initialized = true;
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _settingsManager.setSoundEnabled(enabled);
    notifyListeners();
  }

  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume;
    await _settingsManager.setSoundVolume(volume);
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    await _settingsManager.setMusicEnabled(enabled);
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    await _settingsManager.setVibrationEnabled(enabled);
    notifyListeners();
  }

  Future<void> setDarkModeEnabled(bool enabled) async {
    _darkModeEnabled = enabled;
    await _settingsManager.setDarkModeEnabled(enabled);
    notifyListeners();
  }

  Future<void> setAnimationSpeed(int speed) async {
    _animationSpeed = speed.clamp(0, 2);
    await _settingsManager.setAnimationSpeed(_animationSpeed);
    notifyListeners();
  }

  Future<void> setMergeSoundEnabled(bool enabled) async {
    _mergeSoundEnabled = enabled;
    await _settingsManager.setMergeSoundEnabled(enabled);
    notifyListeners();
  }

  String getAnimationSpeedLabel() {
    switch (_animationSpeed) {
      case 0:
        return 'Lent';
      case 2:
        return 'Rapide';
      default:
        return 'Normal';
    }
  }
}
