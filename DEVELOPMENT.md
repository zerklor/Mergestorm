# 📖 Development Guide - Modifier & Étendre le Code

Guide pour développeurs voulant modifier ou ajouter des fonctionnalités au jeu 2048.

---

## 🎯 Avant de commencer

### Comprendre l'architecture
- Lire [ARCHITECTURE.md](./ARCHITECTURE.md) pour la structure globale
- Comprendre le Provider Pattern utilisé
- Connaître le GameEngine (logique core)

### Setup développement
```bash
cd c:\Users\benja\StudioProjects\mergestorm
flutter pub get
flutter run -v    # Mode verbose pour logs
```

### Outils recommandés
- **VS Code** + Extension Dart/Flutter
- **Android Studio** pour debug avancé
- **DevTools** : `flutter pub global activate devtools`

---

## 🔄 Workflow de développement

### 1. Faire une modification

```dart
// Éditer un fichier, ex: lib/services/game_engine.dart
void myNewMethod() {
  print('Développement');
}
```

### 2. Hot Reload (dev mode)
```bash
# Terminal où flutter run est lancé:
# Appuyer sur R (majuscule) = Hot Reload
R

# Ou appuyer Ctrl+S (si configuré)
```

### 3. Vérifier la qualité
```bash
flutter analyze                # Chercher erreurs
dart format lib/               # Formater code
flutter test                   # Lancer tests (si présents)
```

### 4. Test sur appareil
```bash
flutter run --release          # Build release
# Tester manuellement
```

---

## 📝 Ajout d'une nouvelle fonctionnalité : Exemple

### Scenario : Ajouter un leaderboard local

#### Étape 1 : Créer le modèle de données
```dart
// lib/models/leaderboard_entry.dart
class LeaderboardEntry {
  final int score;
  final DateTime date;
  final int tilesReached;
  
  LeaderboardEntry({
    required this.score,
    required this.date,
    required this.tilesReached,
  });
  
  Map<String, dynamic> toJson() => {
    'score': score,
    'date': date.toIso8601String(),
    'tilesReached': tilesReached,
  };
  
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      score: json['score'] as int,
      date: DateTime.parse(json['date'] as String),
      tilesReached: json['tilesReached'] as int,
    );
  }
}
```

#### Étape 2 : Créer le service de persistance
```dart
// lib/services/leaderboard_manager.dart
class LeaderboardManager {
  static const String _leaderboardKey = 'leaderboard_entries';
  final SharedPreferences _prefs;
  
  LeaderboardManager(this._prefs);
  
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final json = _prefs.getString(_leaderboardKey);
    if (json == null) return [];
    
    final list = jsonDecode(json) as List;
    return list
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  
  Future<void> addEntry(LeaderboardEntry entry) async {
    final current = await getLeaderboard();
    current.add(entry);
    
    // Trier par score (décroissant)
    current.sort((a, b) => b.score.compareTo(a.score));
    
    // Garder top 100
    if (current.length > 100) {
      current.removeRange(100, current.length);
    }
    
    final json = jsonEncode(current);
    await _prefs.setString(_leaderboardKey, json);
  }
}
```

#### Étape 3 : Ajouter au Provider
```dart
// lib/providers/game_provider.dart
class GameProvider extends ChangeNotifier {
  // ... existing code ...
  final LeaderboardManager _leaderboardManager;
  
  Future<void> resetGame() {
    // Existing reset logic
    _engine.reset();
    _state = _engine.gameState;
    
    // ← Nouveau: Sauvegarder entry si score > 0
    if (_state.score > 0) {
      _leaderboardManager.addEntry(
        LeaderboardEntry(
          score: _state.score,
          date: DateTime.now(),
          tilesReached: _findMaxTile(),
        ),
      );
    }
    
    notifyListeners();
  }
  
  int _findMaxTile() {
    int max = 0;
    for (var row in _state.grid) {
      for (var tile in row) {
        if (tile != null && tile.value > max) {
          max = tile.value;
        }
      }
    }
    return max;
  }
}
```

#### Étape 4 : Créer l'écran
```dart
// lib/screens/leaderboard_screen.dart
class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: FutureBuilder<List<LeaderboardEntry>>(
        future: context.read<GameProvider>().getLeaderboard(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          
          final entries = snapshot.data!;
          if (entries.isEmpty) {
            return Center(child: Text('Pas de scores'));
          }
          
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text('${entry.score}'),
                subtitle: Text(entry.date.toString()),
                trailing: Text('Max: ${entry.tilesReached}'),
              );
            },
          );
        },
      ),
    );
  }
}
```

#### Étape 5 : Ajouter la navigation
```dart
// lib/screens/home_screen.dart
// Dans HomeScreen, ajouter un 4e bouton:
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LeaderboardScreen()),
    );
  },
  child: Text('Leaderboard'),
),
```

#### Étape 6 : Test
```bash
flutter run
# Jouer quelques parties
# Cliquer "Leaderboard"
# Vérifier les scores sauvegardés
```

---

## 🎮 Modification de la logique du jeu

### Ajouter une nouvelle tuile de spawn

**Objectif:** Spawner tuiles de 8 (5% des fois) au lieu de juste 2 et 4

```dart
// lib/services/game_engine.dart
void _addNewTile() {
  List<Offset> emptyPositions = [];
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (_state.grid[i][j] == null) {
        emptyPositions.add(Offset(i, j));
      }
    }
  }
  
  if (emptyPositions.isEmpty) return;
  
  final position = emptyPositions[Random().nextInt(emptyPositions.length)];
  
  // ← MODIFICATION : Probabilité 85% (2), 10% (4), 5% (8)
  final rand = Random().nextDouble();
  final value = rand < 0.85
      ? 2
      : rand < 0.95
          ? 4
          : 8;
  
  final newTile = GameTile(value: value, isNew: true);
  _state.grid[position.dx.toInt()][position.dy.toInt()] = newTile;
}
```

### Ajouter une nouvelle direction de mouvement

**Objectif:** Ajouter mouvement diagonale (½ hauteur, ½ largeur)

```dart
// lib/models/game_state.dart (ou models/)
enum MoveDirection {
  up,
  down,
  left,
  right,
  diagonalUpLeft,    // ← Nouveau
  diagonalUpRight,   // ← Nouveau
  diagonalDownLeft,  // ← Nouveau
  diagonalDownRight, // ← Nouveau
}

// lib/services/game_engine.dart
bool move(MoveDirection direction) {
  switch (direction) {
    // ... existing cases ...
    case MoveDirection.diagonalUpLeft:
      return _moveDiagonalUpLeft();
    // ... etc
  }
}

bool _moveDiagonalUpLeft() {
  // Combine moveUp + moveLeft
  bool moved1 = move(MoveDirection.up);
  bool moved2 = move(MoveDirection.left);
  return moved1 || moved2;
}
```

---

## 🎨 Modification de l'UI

### Changer les couleurs des tuiles

```dart
// lib/widgets/game_tile_widget.dart
Color _getTileColor(int value) {
  switch (value) {
    case 2:
      return Color(0xffeee4da); // Beige clair
    case 4:
      return Color(0xffede0c8); // Beige
    case 8:
      return Color(0xfff2b179); // Orange clair
    case 16:
      return Color(0xfff59563); // Orange
    case 32:
      return Color(0xfff67c5f); // Orange-rouge
    case 64:
      return Color(0xfff65e3b); // Rouge
    case 128:
      return Color(0xffddc22e); // Jaune (font blanc)
    case 256:
      return Color(0xffedcf72); // Jaune clair (font gris)
    case 512:
      return Color(0xffedcc61); // Jaune (font gris)
    case 1024:
      return Color(0xffedc850); // Jaune (font gris)
    case 2048:
      return Color(0xffedc53f); // Jaune gold (font gris)
    default:
      return Color(0xff3c3c2f); // Gris très clair
  }
}

// Ou complet palette personnalisée
```

### Ajouter des emojis aux tuiles

```dart
// lib/widgets/game_tile_widget.dart
@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: _getTileColor(widget.tile.value),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${widget.tile.value}',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        // ← Nouveau: Emoji
        Text(_getEmoji(widget.tile.value), style: TextStyle(fontSize: 20)),
      ],
    ),
  );
}

String _getEmoji(int value) {
  const emojis = {
    2: '🌱',
    4: '🌿',
    8: '🌳',
    16: '🏔️',
    32: '⭐',
    64: '💎',
    128: '👑',
    256: '🚀',
    512: '🌟',
    1024: '🔥',
    2048: '💯',
  };
  return emojis[value] ?? '';
}
```

---

## 🔊 Ajout de nouveaux sons

### Ajouter un nouvel événement audio

```dart
// lib/services/audio_manager.dart
class AudioManager {
  // ... existing code ...
  
  // ← Nouveau : Son pour undo
  Future<void> playUndoSound() async {
    if (!_soundEnabled) return;
    await _audioPlayer.play(AssetSource('sounds/undo.ogg'), volume: _soundVolume);
  }
  
  // ← Nouveau : Son pour combos
  Future<void> playComboSound(int comboCount) async {
    if (!_soundEnabled) return;
    // Son différent selon le combo
    final file = comboCount > 3 ? 'sounds/combo_epic.ogg' : 'sounds/combo.ogg';
    await _audioPlayer.play(AssetSource(file), volume: _soundVolume);
  }
}
```

### Placer les fichiers sons
```
assets/sounds/
├── undo.ogg           (nouveau)
└── combo.ogg          (nouveau)
└── combo_epic.ogg     (nouveau)
```

### Déclarer dans pubspec.yaml
```yaml
flutter:
  assets:
    - assets/sounds/undo.ogg
    - assets/sounds/combo.ogg
    - assets/sounds/combo_epic.ogg
```

---

## 🧪 Écrire des tests

### Test unitaire (GameEngine)

```dart
// test/game_engine_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mergestorm/services/game_engine.dart';

void main() {
  group('GameEngine', () {
    late GameEngine engine;
    
    setUp(() {
      engine = GameEngine();
    });
    
    test('New game has 2 tiles', () {
      expect(
        engine.gameState.tilesCount(),
        equals(2),
      );
    });
    
    test('Move returns false when no moves available', () {
      // Setup une grille pleine sans possibilité de fusion
      // Puis vérifier que move() retourne false
    });
    
    test('Merging increases score', () {
      // Setup et vérifier que score augmente après fusion
    });
  });
}
```

### Lancer les tests
```bash
flutter test
flutter test -v          # Verbose
flutter test test/game_engine_test.dart  # Test spécifique
```

---

## 🐛 Debug & Troubleshooting

### Hot Reload ne marche pas
```bash
# Hot Restart à la place
r

# Ou relancer complètement
flutter run
```

### Breakpoints non atteints
```bash
# Lancer en debug mode explicite
flutter run --debug

# Ou depuis VS Code : F5
```

### Logs trop longs
```bash
# Filtrer par tag
flutter logs | grep "[GameEngine]"

# Ou limiter la sortie
flutter logs | tail -50
```

### Performance profiling
```bash
flutter run --profile

# Cela affiche un lien DevTools
# DevTools dispose d'outils de performance
```

---

## 📚 Patterns & Bonnes pratiques

### ✅ À faire

```dart
// 1. Utiliser const où possible
const defaultSize = 4;
const winValue = 2048;

// 2. Immutabilité des modèles
class GameTile {
  final int value;
  final bool isNew;
  
  const GameTile({
    required this.value,
    required this.isNew,
  });
}

// 3. Copier plutôt que modifier
GameState copyWith({
  List<List<GameTile?>>? grid,
  int? score,
}) {
  return GameState(
    grid: grid ?? this.grid,
    score: score ?? this.score,
  );
}

// 4. Null safety
int? maybeValue;
if (maybeValue != null) {
  print(maybeValue);
}
```

### ❌ À éviter

```dart
// 1. Mutation d'état
state.grid[0][0] = newTile;  // ❌ Modifie directement

// 2. Nested ternaries
value == 2 ? a : value == 4 ? b : c  // ❌ Illisible

// 3. Hardcoded values
for (int i = 0; i < 4; i++) { ... }  // ❌ Magic number

// 4. Imports * (wildcard)
import 'package:flutter/material.dart' as material;  // Préférer
import 'package:flutter/material.dart';              // À éviter les *
```

---

## 🔄 Continuous Integration / Deployment

### Pré-commit checks
```bash
#!/bin/bash
# Créer .git/hooks/pre-commit avec ce contenu

flutter analyze
if [ $? -ne 0 ]; then
  echo "Fix errors before committing"
  exit 1
fi

dart format lib/
git add lib/
```

### Build automatisé (GitHub Actions)
```yaml
# .github/workflows/flutter.yml
name: Flutter CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.7.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

---

## 📖 Ressources utiles

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Provider Package Docs](https://pub.dev/packages/provider)
- [Flutter Animation API](https://flutter.dev/docs/development/ui/animations)

---

## 🎯 Checklist avant commit

- [ ] Code formé (`dart format`)
- [ ] Pas d'erreurs (`flutter analyze`)
- [ ] Tests passent (`flutter test`)
- [ ] Hot reload fonctionne
- [ ] Testé sur appareil réel
- [ ] Commentaires ajoutés pour code complexe
- [ ] Documentation mise à jour

---

Pour plus d'aide : Consulter [ARCHITECTURE.md](./ARCHITECTURE.md) pour les patterns et [README.md](./README.md) pour la vue d'ensemble.
