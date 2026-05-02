import 'game_tile.dart';

class GameState {
  final List<List<GameTile?>> grid;
  final int score;
  final int bestScore;
  final bool gameOver;
  final bool won;

  GameState({
    required this.grid,
    this.score = 0,
    this.bestScore = 0,
    this.gameOver = false,
    this.won = false,
  });

  GameState copyWith({
    List<List<GameTile?>>? grid,
    int? score,
    int? bestScore,
    bool? gameOver,
    bool? won,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      gameOver: gameOver ?? this.gameOver,
      won: won ?? this.won,
    );
  }

  // Compte le nombre de tuiles non-vides
  int get tilesCount {
    int count = 0;
    for (var row in grid) {
      for (var tile in row) {
        if (tile != null) count++;
      }
    }
    return count;
  }

  // Vérifie s'il y a des mouvements possibles
  bool get hasAvailableMoves {
    // Vérifier s'il y a des cases vides
    for (var row in grid) {
      for (var tile in row) {
        if (tile == null) return true;
      }
    }

    // Vérifier les fusions possibles horizontalement
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i][j] != null && grid[i][j + 1] != null) {
          if (grid[i][j]!.value == grid[i][j + 1]!.value) {
            return true;
          }
        }
      }
    }

    // Vérifier les fusions possibles verticalement
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] != null && grid[i + 1][j] != null) {
          if (grid[i][j]!.value == grid[i + 1][j]!.value) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
