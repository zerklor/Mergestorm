import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _musicEnabledKey = 'music_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _darkModeKey = 'dark_mode';
  static const String _animationSpeedKey = 'animation_speed'; // 0=Lent, 1=Normal, 2=Rapide
  static const String _mergeSoundEnabledKey = 'merge_sound_enabled';
  static const String _soundVolumeKey = 'sound_volume'; // 0.0 à 1.0

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Sound Settings
  Future<bool> getSoundEnabled() async {
    return _prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }

  // Sound Volume
  Future<double> getSoundVolume() async {
    return _prefs.getDouble(_soundVolumeKey) ?? 1.0;
  }

  Future<void> setSoundVolume(double volume) async {
    await _prefs.setDouble(_soundVolumeKey, volume.clamp(0.0, 1.0));
  }

  // Music Settings
  Future<bool> getMusicEnabled() async {
    return _prefs.getBool(_musicEnabledKey) ?? true;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool(_musicEnabledKey, enabled);
  }

  // Vibration Settings
  Future<bool> getVibrationEnabled() async {
    return _prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_vibrationEnabledKey, enabled);
  }

  // Dark Mode
  Future<bool> getDarkModeEnabled() async {
    return _prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkModeEnabled(bool enabled) async {
    await _prefs.setBool(_darkModeKey, enabled);
  }

  // Animation Speed (0=Lent, 1=Normal, 2=Rapide)
  Future<int> getAnimationSpeed() async {
    return _prefs.getInt(_animationSpeedKey) ?? 1;
  }

  Future<void> setAnimationSpeed(int speed) async {
    await _prefs.setInt(_animationSpeedKey, speed.clamp(0, 2));
  }

  // Merge Sound
  Future<bool> getMergeSoundEnabled() async {
    return _prefs.getBool(_mergeSoundEnabledKey) ?? true;
  }

  Future<void> setMergeSoundEnabled(bool enabled) async {
    await _prefs.setBool(_mergeSoundEnabledKey, enabled);
  }

  // Animation Duration (en ms)
  Future<int> getAnimationDurationMs() async {
    final speed = await getAnimationSpeed();
    switch (speed) {
      case 0:
        return 800; // Lent
      case 2:
        return 200; // Rapide
      default:
        return 500; // Normal
    }
  }
}
