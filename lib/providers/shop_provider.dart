import 'package:flutter/foundation.dart';
import '../services/shop_manager.dart';

class ShopProvider extends ChangeNotifier {
  final ShopManager _shopManager = ShopManager.instance;

  bool _initialized = false;
  bool _isLoading = false;

  bool get initialized => _initialized;
  bool get isLoading => _isLoading;
  int get coins => _shopManager.coins;
  String get selectedTileSkinId => _shopManager.selectedTileSkinId;
  String get selectedBackgroundSkinId => _shopManager.selectedBackgroundSkinId;
  List<ShopSkin> get tileSkins => ShopManager.tileSkins;
  List<ShopSkin> get backgroundSkins => ShopManager.backgroundSkins;

  Future<void> initialize() async {
    if (_initialized) return;
    _isLoading = true;
    notifyListeners();
    await _shopManager.initialize();
    _initialized = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _shopManager.initialize();
    notifyListeners();
  }

  bool ownsSkin(ShopSkin skin) => _shopManager.owns(skin.id, skin.category);

  Future<bool> purchaseSkin(ShopSkin skin) async {
    final success = await _shopManager.purchaseSkin(skin);
    notifyListeners();
    return success;
  }

  Future<void> equipSkin(ShopSkin skin) async {
    await _shopManager.equipSkin(skin);
    notifyListeners();
  }

  Future<int> earnCoinsFromGame(int score) async {
    final reward = await _shopManager.addCoinsFromGame(score);
    notifyListeners();
    return reward;
  }

  Future<int> earnCoinsFromAd() async {
    final reward = await _shopManager.addCoinsFromAd();
    notifyListeners();
    return reward;
  }

  Future<void> resetProgress() async {
    await _shopManager.resetProgress();
    notifyListeners();
  }
}