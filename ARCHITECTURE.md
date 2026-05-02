# 🏗️ Architecture & Design Pattern

Documentation technique de l'architecture du jeu 2048.

---

## 📐 Vue d'ensemble architecturale

```
┌─────────────────────────────────────┐
│        UI Layer (Widgets)           │
│  HomeScreen | GameScreen | Settings │
└──────────────────┬──────────────────┘
                   │ Consumer<T>
┌──────────────────▼──────────────────┐
│    State Management Layer           │
│  GameProvider | SettingsProvider    │
│      (ChangeNotifier)               │
└──────────────────┬──────────────────┘
                   │ notifyListeners()
┌──────────────────▼──────────────────┐
│      Service Layer (Singleton)      │
│  GameEngine   | AudioManager        │
│  ScoreManager | SettingsManager     │
│  AdManager    | (Business Logic)    │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│      Data Layer (Persistence)       │
│       SharedPreferences             │
│   (Local key-value storage)         │
└─────────────────────────────────────┘
```
        ↓
Service Layer (GameEngine, ScoreManager, AudioManager, AdManager)
        ↓
Data Layer (SharedPreferences)
```

## 🎮 Logique du jeu (GameEngine)

### Mécaniques principales

**1. Initialisation**
- Grille 4x4 vide
- 2 tuiles de démarrage (valeur 2 ou 4)

**2. Mouvements**
- Swipe en 4 directions (haut, bas, gauche, droite)
- Détection du geste au niveau de GameScreen
- Appel à GameEngine.move(direction)

**3. Glissement (Slide)**
```
Avant: [0, 2, 0, 4]
Après: [2, 4, 0, 0]
```
- Compacte les tuiles non-nulles
- Déplace vers le bord (direction du swipe)

**4. Fusion (Merge)**
```
[2, 2, 0, 0] → [4, 0, 0, 0]  (tuiles identiques fusionnent)
```
- Tuiles identiques adjacent → fusion en une tuile double
- Score += nouvelle tuile value
- Flag `isMerged` pour animation

**5. Ajout de tuile**
- Position aléatoire parmi cases vides
- Valeur: 90% = 2, 10% = 4
- Flag `isNew` pour animation d'apparition

**6. Détection fin de partie**
- **Victoire**: Une tuile atteint 2048
- **Défaite**: Pas de cases vides ET pas de fusion possible
- `hasAvailableMoves` vérifie toutes les conditions

### Code core - Classe GameEngine

```dart
class GameEngine {
  static const int gridSize = 4;
  static const int winValue = 2048;
  
  // État interne
  late GameState _state;
  
  // Mouvements
  bool move(MoveDirection direction)
  
  // Utilitaires
  List<List<GameTile?>> _moveLeft(grid)
  void _slideLeft(List<GameTile?> line)
  void _mergeLeft(List<GameTile?> line)
  void _addNewTile()
}
```

## 🎨 Gestion d'état (Provider Pattern)

### GameProvider

**Responsabilités:**
- Instancie GameEngine
- Expose GameState aux widgets
- Déclenche animations d'audio
- Persiste les scores

**Flow principal:**
```
User Swipe
    ↓
GameScreen.onPanEnd()
    ↓
GameProvider.moveUp/Down/Left/Right()
    ↓
GameEngine.move()
    ↓
notifyListeners()
    ↓
UI rebuild
    ↓
AudioManager.play() + ScoreManager.save()
```

### Consumer Pattern

```dart
Consumer<GameProvider>(
  builder: (context, provider, child) {
    final gameState = provider.gameState;
    // Rebuild UI when gameState changes
  },
)
```

## 🔊 Gestion audio (AudioManager)

**Sons disponibles:**
- `move.mp3`: Chaque coup de joueur (faible volume)
- `merge.mp3`: Fusion de tuiles (satisfait sonore)
- `game_over.mp3`: Fin de jeu
- `win.mp3`: Victoire
- `background.mp3`: Musique en boucle

**Architecture:**
```dart
class AudioManager {
  AudioPlayer _audioPlayer;      // Sons d'événements
  AudioPlayer _backgroundMusic;  // Boucle musique
  
  // Deux instances distinctes pour:
  // - Pas interruption musique par sons
  // - Gestion indépendante volume
}
```

**Control:**
```dart
provider.setSoundEnabled(false);   // Toggle des sons
provider.setMusicEnabled(false);   // Toggle musique
```

## 💾 Persistance (ScoreManager)

**Données sauvegardées:**
- `best_score`: Meilleur score de tous les temps
- `games_played`: Nombre de parties jouées
- `total_score`: Total des scores de toutes les parties

**Source:** SharedPreferences (local storage)

```dart
// Exemple d'utilisation
final bestScore = await scoreManager.getBestScore();
await scoreManager.saveBestScore(newScore);
```

## 📺 Affichage (UI Layer)

### Widget hierarchy

```
GameScreen (Scaffold + GestureDetector)
├── AppBar (titre "2048")
├── Column
│   ├── Score + Best score display
│   ├── "New Game" button
│   ├── GameGridWidget
│   │   └── 16x GameTileWidget
│   └── BannerAdWidget
```

### GameTileWidget

**Responsabilités:**
- Affiche une tuile individuelle
- Coloration selon valeur (2=beige, 2048=gold)
- Texte contraste (sombre/clair selon couleur)
- Animation d'apparition pour tuiles neuves

**Palette de couleurs:**
```
2:    #EEE4DA (beige clair)
4:    #EDE0C8 (beige)
8:    #F2B179 (orange clair)
16:   #F59563 (orange)
32:   #F67C5F (rouge-orange)
64:   #F65E3B (rouge)
128:  #EDCF72 (jaune)
256:  #EDCC61 (jaune foncé)
512:  #EDCC50
1024: #EDCC3F
2048: #EDCC2E (or)
```

### Gestion des gestes

```dart
GestureDetector(
  onPanStart: (details) => _startPosition,
  onPanUpdate: (details) => _currentPosition,
  onPanEnd: (details) => _handleSwipe()
)

// Détection swipe
final dx = end.x - start.x;
final dy = end.y - start.y;

if (dx.abs() > dy.abs() && dx.abs() > 50) {
  dx > 0 ? moveRight() : moveLeft()
} else if (dy.abs() > 50) {
  dy > 0 ? moveDown() : moveUp()
}
```

## 📊 Modèles de données

### GameTile
```dart
class GameTile {
  final int value;           // 2, 4, 8, ... 2048+
  final bool isNew;          // Pour animation
  final bool isMerged;       // Pour animation
}
```

### GameState
```dart
class GameState {
  final List<List<GameTile?>> grid;  // Grille 4x4
  final int score;                   // Score actuel
  final int bestScore;               // Meilleur score
  final bool gameOver;               // Jeu terminé?
  final bool won;                    // Victoire?
}
```

## 🌐 Google Mobile Ads

**Test Ad Unit IDs** (développement):
```dart
Banner:       'ca-app-pub-3940256099942544/6300978111'
Interstitial: 'ca-app-pub-3940256099942544/1033173712'
Rewarded:     'ca-app-pub-3940256099942544/5224354917'
```

**À faire avant production:**
1. Enregistrer l'app sur AdMob Console
2. Créer Ad Units
3. Remplacer les Test IDs par les vrais IDs

## 🚀 Performance

### Optimisations

1. **Provider.select()** pour ne rebuild que si relevant change
2. **Const constructors** pour widgets statiques
3. **Grid.builder** au lieu de colonnes générées
4. **Disposal propre** des ressources (AudioManager, BannerAd)

### Complexité

- Move: O(16) = O(1) (grille 4x4 fixe)
- Merge: O(16) = O(1)
- NewTile: O(empties) max O(16) = O(1)
- Total par coup: O(1) ✅

## 🔐 Sécurité

- Pas de requêtes réseau en dehors des ads
- Scores sauvegardés localement (SharedPreferences)
- Aucune donnée sensible partagée
- HTTPS/sécurité gérée par Google Mobile Ads

## 📱 Compatibilité

- **Min SDK:** 21 (Android 5.0)
- **Target SDK:** 34 (Android 14)
- **Flutter:** 3.7.0+
- **Dart:** 3.5.0+

## 🛠️ Debugging

### Logs utiles

```dart
// GameEngine
print('Game Over: ${!state.hasAvailableMoves}');
print('Won: ${state.grid.any((row) => row.any((t) => t?.value == 2048))}');

// Audio
print('Playing: $soundName');

// Ads
MobileAds.instance.setRequestConfiguration(
  RequestConfiguration(keywords: ['game', 'puzzle'])
);
```

### Hot Reload

```bash
flutter run
# Press 'r' for hot reload
# Changes to code (not data) à chaud
```

## 📈 Évolutions futures

1. **Variantes de jeu:**
   - Grille 5x5
   - Spawn de tuiles plus rapide
   - Mode Time Attack

2. **Social:**
   - Leaderboard (Firebase)
   - Share score sur Twitter
   - Multiplayer

3. **Monetization avancée:**
   - Interstitial après chaque partie
   - Rewarded video pour undo move
   - In-app purchases (no ads, skins)

4. **UX:**
   - Undo move
   - Replay d'une partie
   - Themes (dark, neon, etc.)

---

**Version:** 1.0
**Dernière mise à jour:** 2025-04-25
