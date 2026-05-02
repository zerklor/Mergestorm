import 'dart:math';
import '../models/game_state.dart';
import '../models/game_tile.dart';

enum MoveDirection { up, down, left, right }

class GameEngine {
  static const int gridSize = 4;
  static const int winValue = 2048;

  late GameState _state;
  int _bestScore = 0;  // Track le meilleur score globalement

  GameEngine() {
    _initializeGame();
  }

  GameState get state => _state;

  int get bestScore => _bestScore;

  void setBestScore(int bestScore) {
    _bestScore = bestScore;
    _state = _state.copyWith(bestScore: _bestScore);
  }

  void _initializeGame() {
    final grid = List<List<GameTile?>>.generate(
      gridSize,
      (_) => List<GameTile?>.filled(gridSize, null),
    );
    _state = GameState(grid: grid, score: 0, bestScore: _bestScore);
    _addNewTile();
    _addNewTile();
  }

  void reset() {
    _initializeGame();
  }

  // Mettre à jour le meilleur score quand il y a un nouveau record
  void _updateBestScore(int score) {
    if (score > _bestScore) {
      _bestScore = score;
    }
  }

  void _addNewTile() {
    final emptyPositions = <List<int>>[];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (_state.grid[i][j] == null) {
          emptyPositions.add([i, j]);
        }
      }
    }

    if (emptyPositions.isEmpty) return;

    final randomPosition = emptyPositions[Random().nextInt(emptyPositions.length)];
    final row = randomPosition[0];
    final col = randomPosition[1];

    // 90% chance de 2, 10% chance de 4
    final value = Random().nextDouble() < 0.9 ? 2 : 4;

    final newGrid = _copyGrid(_state.grid);
    newGrid[row][col] = GameTile(value: value, isNew: true);

    _state = _state.copyWith(grid: newGrid);
  }

  bool move(MoveDirection direction) {
    final oldGrid = _copyGrid(_state.grid);
    late List<List<GameTile?>> newGrid;

    switch (direction) {
      case MoveDirection.left:
        newGrid = _moveLeft(_copyGrid(_state.grid));
        break;
      case MoveDirection.right:
        newGrid = _moveRight(_copyGrid(_state.grid));
        break;
      case MoveDirection.up:
        newGrid = _moveUp(_copyGrid(_state.grid));
        break;
      case MoveDirection.down:
        newGrid = _moveDown(_copyGrid(_state.grid));
        break;
    }

    // Vérifie si la grille a changé
    if (_gridsEqual(oldGrid, newGrid)) {
      return false;
    }

    _state = _state.copyWith(grid: newGrid);
    _addNewTile();
    _updateGameStatus();

    // Keep best score in sync even before game over.
    _updateBestScore(_state.score);
    _state = _state.copyWith(bestScore: _bestScore);

    return true;
  }

  List<List<GameTile?>> _moveLeft(List<List<GameTile?>> grid) {
    for (int i = 0; i < gridSize; i++) {
      _slideLeft(grid[i]);
      _mergeLeft(grid[i]);
      _slideLeft(grid[i]);
    }
    return grid;
  }

  List<List<GameTile?>> _moveRight(List<List<GameTile?>> grid) {
    for (int i = 0; i < gridSize; i++) {
      _slideRight(grid[i]);
      _mergeRight(grid[i]);
      _slideRight(grid[i]);
    }
    return grid;
  }

  List<List<GameTile?>> _moveUp(List<List<GameTile?>> grid) {
    for (int j = 0; j < gridSize; j++) {
      final column = List<GameTile?>.generate(gridSize, (i) => grid[i][j]);
      _slideLeft(column);
      _mergeLeft(column);
      _slideLeft(column);
      for (int i = 0; i < gridSize; i++) {
        grid[i][j] = column[i];
      }
    }
    return grid;
  }

  List<List<GameTile?>> _moveDown(List<List<GameTile?>> grid) {
    for (int j = 0; j < gridSize; j++) {
      final column = List<GameTile?>.generate(gridSize, (i) => grid[i][j]);
      _slideRight(column);
      _mergeRight(column);
      _slideRight(column);
      for (int i = 0; i < gridSize; i++) {
        grid[i][j] = column[i];
      }
    }
    return grid;
  }

  void _slideLeft(List<GameTile?> line) {
    final compacted = line.where((tile) => tile != null).toList();
    for (int i = 0; i < gridSize; i++) {
      line[i] = i < compacted.length ? compacted[i] : null;
    }
  }

  void _slideRight(List<GameTile?> line) {
    final compacted = line.where((tile) => tile != null).toList();
    for (int i = 0; i < gridSize; i++) {
      line[i] = i >= gridSize - compacted.length ? compacted[i - (gridSize - compacted.length)] : null;
    }
  }

  void _mergeLeft(List<GameTile?> line) {
    for (int i = 0; i < gridSize - 1; i++) {
      if (line[i] != null && line[i + 1] != null && line[i]!.value == line[i + 1]!.value) {
        line[i] = GameTile(value: line[i]!.value * 2, isMerged: true);
        _state = _state.copyWith(score: _state.score + line[i]!.value);
        line[i + 1] = null;
      }
    }
  }

  void _mergeRight(List<GameTile?> line) {
    for (int i = gridSize - 1; i > 0; i--) {
      if (line[i] != null && line[i - 1] != null && line[i]!.value == line[i - 1]!.value) {
        line[i] = GameTile(value: line[i]!.value * 2, isMerged: true);
        _state = _state.copyWith(score: _state.score + line[i]!.value);
        line[i - 1] = null;
      }
    }
  }

  void _updateGameStatus() {
    bool won = false;
    for (var row in _state.grid) {
      for (var tile in row) {
        if (tile != null && tile.value == winValue) {
          won = true;
          break;
        }
      }
      if (won) break;
    }

    bool gameOver = false;
    if (!_state.hasAvailableMoves) {
      gameOver = true;
    }

    if (won || gameOver) {
      // Mettre à jour le meilleur score
      _updateBestScore(_state.score);
      _state = _state.copyWith(
        gameOver: gameOver,
        won: won,
        bestScore: _bestScore,
      );
    }
  }

  List<List<GameTile?>> _copyGrid(List<List<GameTile?>> grid) {
    return grid.map((row) => [...row]).toList();
  }

  bool _gridsEqual(List<List<GameTile?>> grid1, List<List<GameTile?>> grid2) {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if ((grid1[i][j]?.value ?? 0) != (grid2[i][j]?.value ?? 0)) {
          return false;
        }
      }
    }
    return true;
  }

  void continuePlaying() {
    _state = _state.copyWith(won: false);
  }
}
