import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/shop_provider.dart';
import '../models/game_state.dart';
import '../widgets/game_grid_widget.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/ad_manager.dart';
import '../services/shop_manager.dart';
// import '../widgets/banner_ad_widget.dart';  // TODO: Uncomment after AdMob setup

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late Offset _startPosition;
  late Offset _currentPosition;
  bool _dialogShown = false;  // Track si le dialogue a été montré

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      final gameProvider = context.read<GameProvider>();
      final settingsProvider = context.read<SettingsProvider>();
      gameProvider.initialize();
      // Synchroniser les paramètres audio
      gameProvider.audioManager.updateSettings(
        settingsProvider.soundEnabled,
        settingsProvider.musicEnabled,
      );
    });
  }

  Future<void> _persistAndExit() async {
    final provider = context.read<GameProvider>();
    await provider.persistBestScore();
    await provider.rewardCurrentSession();
    await AdManager.maybeShowInterstitial();
    await provider.audioManager.stopBackgroundMusic();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final provider = context.read<GameProvider>();
    final settings = context.read<SettingsProvider>();

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      provider.persistBestScore();
      provider.rewardCurrentSession();
      AdManager.maybeShowInterstitial();
      provider.audioManager.stopBackgroundMusic();
    } else if (state == AppLifecycleState.resumed && settings.musicEnabled) {
      provider.audioManager.playBackgroundMusic();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final provider = context.read<GameProvider>();
    provider.persistBestScore();
    provider.rewardCurrentSession();
    AdManager.maybeShowInterstitial();
    provider.audioManager.stopBackgroundMusic();
    super.dispose();
  }

  void _handleSwipe(bool vibrationEnabled) {
    final provider = context.read<GameProvider>();
    final dx = _currentPosition.dx - _startPosition.dx;
    final dy = _currentPosition.dy - _startPosition.dy;

    // Détermine la direction avec un seuil minimum
    if (dx.abs() > dy.abs() && dx.abs() > 50) {
      dx > 0 ? provider.moveRight(vibrationEnabled: vibrationEnabled) : provider.moveLeft(vibrationEnabled: vibrationEnabled);
    } else if (dy.abs() > dx.abs() && dy.abs() > 50) {
      dy > 0 ? provider.moveDown(vibrationEnabled: vibrationEnabled) : provider.moveUp(vibrationEnabled: vibrationEnabled);
    }
  }

  void _showGameOverDialog(GameState gameState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(
          gameState.won ? 'Vous avez gagné! 🎉' : 'Jeu terminé 😢',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text(
                'Score: ${gameState.score}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Meilleur score: ${gameState.bestScore}',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (gameState.won) {
                context.read<GameProvider>().continuePlaying();
              }
            },
            child: Text(gameState.won ? 'Continuer' : 'Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GameProvider>().resetGame();
            },
            child: Text('Nouveau jeu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        final shop = context.watch<ShopProvider>();
        final tileSkin = ShopManager.instance.getTileSkin(shop.selectedTileSkinId);
        final backgroundSkin = ShopManager.instance.getBackgroundSkin(shop.selectedBackgroundSkinId);
        final isDarkMode = settings.darkModeEnabled;
        final bgColor = isDarkMode ? backgroundSkin.backgroundColor : backgroundSkin.backgroundColor;
        final appBarColor = isDarkMode ? backgroundSkin.boardColor : backgroundSkin.boardColor;
        final textColor = backgroundSkin.textColor;

        return WillPopScope(
          onWillPop: () async {
            await _persistAndExit();
            return true;
          },
          child: Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              title: Text('2048'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: appBarColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  await _persistAndExit();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            body: Consumer<GameProvider>(
              builder: (context, provider, child) {
                final gameState = provider.gameState;

              // Reset le flag quand on commence une nouvelle partie
              if (!gameState.gameOver && !gameState.won) {
                _dialogShown = false;
              }

              // Affiche le dialogue si le jeu est terminé ET pas encore affiché
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if ((gameState.gameOver || gameState.won) &&
                    !_dialogShown &&
                    ModalRoute.of(context)?.isCurrent == true) {
                  _dialogShown = true;
                  _showGameOverDialog(gameState);
                }
              });

                return SafeArea(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) {
                      _startPosition = details.globalPosition;
                    },
                    onPanUpdate: (details) {
                      _currentPosition = details.globalPosition;
                    },
                    onPanEnd: (details) {
                      _handleSwipe(settings.vibrationEnabled);
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Score',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode ? Colors.grey.shade400 : const Color(0xFF776E65),
                                          ),
                                        ),
                                        Text(
                                          '${gameState.score}',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Meilleur',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode ? Colors.grey.shade400 : const Color(0xFF776E65),
                                          ),
                                        ),
                                        Text(
                                          '${gameState.bestScore}',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        provider.resetGame();
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Nouveau'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF8F7A66),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(isDarkMode ? 0.06 : 0.42),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.swipe, color: textColor.withOpacity(0.9)),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          'Glissez n\'importe où sur la zone de jeu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: textColor.withOpacity(0.9),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: GameGridWidget(
                                    gameState: gameState,
                                    animationSpeed: settings.animationSpeed,
                                    tileSkin: tileSkin,
                                    backgroundSkin: backgroundSkin,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Le geste fonctionne sur toute la zone centrale',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDarkMode ? Colors.grey.shade500 : const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const BannerAdWidget(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
