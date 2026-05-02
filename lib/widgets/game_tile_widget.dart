import 'package:flutter/material.dart';
import '../models/game_tile.dart';
import '../services/shop_manager.dart';

class GameTileWidget extends StatefulWidget {
  final GameTile? tile;
  final double size;
  final int animationSpeed; // 0=Lent, 1=Normal, 2=Rapide
  final ShopSkin tileSkin;

  const GameTileWidget({
    Key? key,
    required this.tile,
    required this.size,
    required this.tileSkin,
    this.animationSpeed = 1,
  }) : super(key: key);

  @override
  State<GameTileWidget> createState() => _GameTileWidgetState();
}

class _GameTileWidgetState extends State<GameTileWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  int getAnimationDuration() {
    switch (widget.animationSpeed) {
      case 0:
        return 800; // Lent
      case 2:
        return 200; // Rapide
      default:
        return 500; // Normal
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: getAnimationDuration()),
      vsync: this,
    );
    _playAnimation();
  }

  @override
  void didUpdateWidget(GameTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tile != oldWidget.tile) {
      _animationController.duration = Duration(milliseconds: getAnimationDuration());
      _playAnimation();
    }
  }

  void _playAnimation() {
    if (widget.tile?.isNew == true) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.forward(from: 1.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color getTileColor(int value) {
    return widget.tileSkin.tileColors[value] ?? widget.tileSkin.primaryColor;
  }

  Color getTextColor(int value) {
    return widget.tileSkin.textColor;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile == null) {
      return Container(
        width: widget.size,
        height: widget.size,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0xFFCDC1B4),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        ),
        child: Container(
          width: widget.size,
          height: widget.size,
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: getTileColor(widget.tile!.value),
            borderRadius: BorderRadius.circular(6),
            boxShadow: widget.tile!.isMerged
                ? [BoxShadow(color: Colors.black26, blurRadius: 8)]
                : [],
          ),
          child: Center(
            child: Text(
              '${widget.tile!.value}',
              style: TextStyle(
                fontSize: widget.size * 0.35,
                fontWeight: FontWeight.bold,
                color: getTextColor(widget.tile!.value),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
