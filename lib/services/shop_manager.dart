import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ShopItemCategory {
  tileSkin,
  backgroundSkin,
}

class ShopSkin {
  final String id;
  final String name;
  final String description;
  final ShopItemCategory category;
  final int price;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color boardColor;
  final Map<int, Color> tileColors;
  final Color textColor;

  const ShopSkin({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.boardColor,
    required this.tileColors,
    required this.textColor,
  });
}

class ShopManager {
  static final ShopManager instance = ShopManager._internal();

  ShopManager._internal();

  static const String _coinsKey = 'shop_coins';
  static const String _ownedTileSkinsKey = 'owned_tile_skins';
  static const String _ownedBackgroundSkinsKey = 'owned_background_skins';
  static const String _selectedTileSkinKey = 'selected_tile_skin';
  static const String _selectedBackgroundSkinKey = 'selected_background_skin';

  static const String defaultTileSkinId = 'classic_tiles';
  static const String defaultBackgroundSkinId = 'classic_background';

  static final List<ShopSkin> tileSkins = [
    ShopSkin(
      id: defaultTileSkinId,
      name: 'Classique',
      description: 'Palette originale du jeu.',
      category: ShopItemCategory.tileSkin,
      price: 0,
      primaryColor: Color(0xFFEEE4DA),
      secondaryColor: Color(0xFFCDC1B4),
      backgroundColor: Color(0xFFF5F0E8),
      boardColor: Color(0xFFBBADA0),
      tileColors: {
        2: Color(0xFFEEE4DA),
        4: Color(0xFFEDE0C8),
        8: Color(0xFFF2B179),
        16: Color(0xFFF59563),
        32: Color(0xFFF67C5F),
        64: Color(0xFFF65E3B),
        128: Color(0xFFEDCF72),
        256: Color(0xFFEDCC61),
        512: Color(0xFFEDC850),
        1024: Color(0xFFEDC53F),
        2048: Color(0xFFEDC22E),
      },
      textColor: Color(0xFF776E65),
    ),
    ShopSkin(
      id: 'neon_tiles',
      name: 'Néon',
      description: 'Des tuiles plus lumineuses et contrastées.',
      category: ShopItemCategory.tileSkin,
      price: 120,
      primaryColor: Color(0xFFB8F7D4),
      secondaryColor: Color(0xFF3DDC97),
      backgroundColor: Color(0xFF071421),
      boardColor: Color(0xFF17324A),
      tileColors: {
        2: Color(0xFFD6FFF0),
        4: Color(0xFFA7FFE4),
        8: Color(0xFF6DFFD1),
        16: Color(0xFF47F7B8),
        32: Color(0xFF1DDC9B),
        64: Color(0xFF10B981),
        128: Color(0xFF34D399),
        256: Color(0xFF22C55E),
        512: Color(0xFF16A34A),
        1024: Color(0xFF15803D),
        2048: Color(0xFF0F766E),
      },
      textColor: Colors.white,
    ),
    ShopSkin(
      id: 'ember_tiles',
      name: 'Brasier',
      description: 'Un look chaud et agressif pour les grosses tuiles.',
      category: ShopItemCategory.tileSkin,
      price: 150,
      primaryColor: Color(0xFFFFD6A5),
      secondaryColor: Color(0xFFF97316),
      backgroundColor: Color(0xFF1C0B0B),
      boardColor: Color(0xFF46211A),
      tileColors: {
        2: Color(0xFFFFE5C2),
        4: Color(0xFFFFC98A),
        8: Color(0xFFFFA552),
        16: Color(0xFFF97316),
        32: Color(0xFFEA580C),
        64: Color(0xFFDC2626),
        128: Color(0xFFB91C1C),
        256: Color(0xFF991B1B),
        512: Color(0xFF7F1D1D),
        1024: Color(0xFF6B1D1D),
        2048: Color(0xFF4C1D1D),
      },
      textColor: Colors.white,
    ),
  ];

  static final List<ShopSkin> backgroundSkins = [
    ShopSkin(
      id: defaultBackgroundSkinId,
      name: 'Classique',
      description: 'Le fond d’origine du jeu.',
      category: ShopItemCategory.backgroundSkin,
      price: 0,
      primaryColor: Color(0xFFFAF8F3),
      secondaryColor: Color(0xFFF2E8DC),
      backgroundColor: Color(0xFFFAF8F3),
      boardColor: Color(0xFFBBADA0),
      tileColors: {},
      textColor: Color(0xFF776E65),
    ),
    ShopSkin(
      id: 'midnight_background',
      name: 'Minuit',
      description: 'Un fond sombre et propre.',
      category: ShopItemCategory.backgroundSkin,
      price: 80,
      primaryColor: Color(0xFF0F172A),
      secondaryColor: Color(0xFF1E293B),
      backgroundColor: Color(0xFF020617),
      boardColor: Color(0xFF334155),
      tileColors: {},
      textColor: Colors.white,
    ),
    ShopSkin(
      id: 'forest_background',
      name: 'Forêt',
      description: 'Un décor plus organique et apaisant.',
      category: ShopItemCategory.backgroundSkin,
      price: 100,
      primaryColor: Color(0xFF052E16),
      secondaryColor: Color(0xFF166534),
      backgroundColor: Color(0xFF03120A),
      boardColor: Color(0xFF14532D),
      tileColors: {},
      textColor: Colors.white,
    ),
    ShopSkin(
      id: 'sunset_background',
      name: 'Coucher de soleil',
      description: 'Un fond plus chaud et plus premium.',
      category: ShopItemCategory.backgroundSkin,
      price: 130,
      primaryColor: Color(0xFF7C2D12),
      secondaryColor: Color(0xFFEA580C),
      backgroundColor: Color(0xFF1B0F1A),
      boardColor: Color(0xFF9A3412),
      tileColors: {},
      textColor: Colors.white,
    ),
  ];

  SharedPreferences? _prefs;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
    await _ensureDefaults();
  }

  Future<void> _ensureDefaults() async {
    if (_prefs == null) return;

    if (!_prefs!.containsKey(_coinsKey)) {
      await _prefs!.setInt(_coinsKey, 120);
    }

    if (!_prefs!.containsKey(_selectedTileSkinKey)) {
      await _prefs!.setString(_selectedTileSkinKey, defaultTileSkinId);
    }

    if (!_prefs!.containsKey(_selectedBackgroundSkinKey)) {
      await _prefs!.setString(_selectedBackgroundSkinKey, defaultBackgroundSkinId);
    }

    await _ensureOwnedSet(_ownedTileSkinsKey, defaultTileSkinId);
    await _ensureOwnedSet(_ownedBackgroundSkinsKey, defaultBackgroundSkinId);
  }

  Future<void> _ensureOwnedSet(String key, String defaultItemId) async {
    final values = _prefs!.getStringList(key) ?? <String>[];
    if (!values.contains(defaultItemId)) {
      values.add(defaultItemId);
      await _prefs!.setStringList(key, values);
    }
  }

  int get coins => _prefs?.getInt(_coinsKey) ?? 0;

  String get selectedTileSkinId => _prefs?.getString(_selectedTileSkinKey) ?? defaultTileSkinId;

  String get selectedBackgroundSkinId =>
      _prefs?.getString(_selectedBackgroundSkinKey) ?? defaultBackgroundSkinId;

  List<String> get ownedTileSkinIds => _prefs?.getStringList(_ownedTileSkinsKey) ?? [defaultTileSkinId];

  List<String> get ownedBackgroundSkinIds =>
      _prefs?.getStringList(_ownedBackgroundSkinsKey) ?? [defaultBackgroundSkinId];

  ShopSkin getTileSkin(String id) =>
      tileSkins.firstWhere((skin) => skin.id == id, orElse: () => tileSkins.first);

  ShopSkin getBackgroundSkin(String id) =>
      backgroundSkins.firstWhere((skin) => skin.id == id, orElse: () => backgroundSkins.first);

  Future<void> addCoins(int amount) async {
    if (amount <= 0) return;
    await initialize();
    await _prefs!.setInt(_coinsKey, coins + amount);
  }

  Future<int> addCoinsFromGame(int score) async {
    await initialize();
    final reward = score <= 0 ? 5 : (score ~/ 100) + 10;
    await addCoins(reward);
    return reward;
  }

  Future<int> addCoinsFromAd() async {
    await initialize();
    const reward = 25;
    await addCoins(reward);
    return reward;
  }

  bool owns(String itemId, ShopItemCategory category) {
    return category == ShopItemCategory.tileSkin
        ? ownedTileSkinIds.contains(itemId)
        : ownedBackgroundSkinIds.contains(itemId);
  }

  Future<bool> purchaseSkin(ShopSkin skin) async {
    await initialize();
    if (owns(skin.id, skin.category)) {
      return true;
    }

    if (coins < skin.price) {
      return false;
    }

    await _prefs!.setInt(_coinsKey, coins - skin.price);
    final ownedIds = skin.category == ShopItemCategory.tileSkin
        ? [...ownedTileSkinIds, skin.id]
        : [...ownedBackgroundSkinIds, skin.id];

    if (skin.category == ShopItemCategory.tileSkin) {
      await _prefs!.setStringList(_ownedTileSkinsKey, ownedIds);
    } else {
      await _prefs!.setStringList(_ownedBackgroundSkinsKey, ownedIds);
    }

    return true;
  }

  Future<void> equipSkin(ShopSkin skin) async {
    await initialize();
    if (!owns(skin.id, skin.category)) return;

    if (skin.category == ShopItemCategory.tileSkin) {
      await _prefs!.setString(_selectedTileSkinKey, skin.id);
    } else {
      await _prefs!.setString(_selectedBackgroundSkinKey, skin.id);
    }
  }

  Future<void> resetProgress() async {
    await initialize();
    await _prefs!.setInt(_coinsKey, 120);
    await _prefs!.setStringList(_ownedTileSkinsKey, [defaultTileSkinId]);
    await _prefs!.setStringList(_ownedBackgroundSkinsKey, [defaultBackgroundSkinId]);
    await _prefs!.setString(_selectedTileSkinKey, defaultTileSkinId);
    await _prefs!.setString(_selectedBackgroundSkinKey, defaultBackgroundSkinId);
  }
}