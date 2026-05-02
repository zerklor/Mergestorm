import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'game_tile_widget.dart';
import '../services/shop_manager.dart';

class GameGridWidget extends StatelessWidget {
  final GameState gameState;
  final double gridSize;
  final int animationSpeed; // 0=Lent, 1=Normal, 2=Rapide
  final ShopSkin tileSkin;
  final ShopSkin backgroundSkin;

  const GameGridWidget({
    Key? key,
    required this.gameState,
    required this.tileSkin,
    required this.backgroundSkin,
    this.gridSize = 320,
    this.animationSpeed = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileSize = (gridSize - 20) / 4; // 20 for margins, 4 tiles

    return IgnorePointer(
      ignoring: true,
      child: Container(
        width: gridSize,
        height: gridSize,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundSkin.boardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            final row = index ~/ 4;
            final col = index % 4;
            return GameTileWidget(
              tile: gameState.grid[row][col],
              size: tileSize,
              tileSkin: tileSkin,
              animationSpeed: animationSpeed,
            );
          },
        ),
      ),
    );
  }
}
