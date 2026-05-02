import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../services/ad_manager.dart';
import '../services/shop_manager.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ShopItemCategory _selectedCategory = ShopItemCategory.tileSkin;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ShopProvider>().initialize());
  }

  List<ShopSkin> get _items {
    final provider = context.read<ShopProvider>();
    return _selectedCategory == ShopItemCategory.tileSkin
        ? provider.tileSkins
        : provider.backgroundSkins;
  }

  Future<void> _showRewardedAdSnack() async {
    final provider = context.read<ShopProvider>();
    final rewarded = await AdManager.showRewardedAd(
      onEarnedReward: () {
        provider.earnCoinsFromAd();
      },
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          rewarded ? 'Pub regardée: pièces ajoutées' : 'Pub non disponible pour le moment',
        ),
      ),
    );
  }

  Future<void> _handleSkinAction(ShopSkin skin) async {
    final provider = context.read<ShopProvider>();

    if (provider.ownsSkin(skin)) {
      await provider.equipSkin(skin);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${skin.name} équipé')),
      );
      return;
    }

    final success = await provider.purchaseSkin(skin);
    if (!mounted) return;

    if (success) {
      await provider.equipSkin(skin);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${skin.name} acheté et équipé')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pas assez de monnaie')),
      );
    }
  }

  Widget _buildPreviewCard(ShopSkin skin, bool owned, bool selected) {
    if (skin.category == ShopItemCategory.tileSkin) {
      final sampleValues = [2, 4, 8, 16];
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [skin.primaryColor, skin.secondaryColor]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: sampleValues
                  .map(
                    (value) => Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: skin.tileColors[value] ?? skin.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$value',
                        style: TextStyle(
                          color: skin.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(
              owned ? (selected ? 'Équipé' : 'Possédé') : 'À débloquer',
              style: TextStyle(
                color: skin.textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [skin.primaryColor, skin.secondaryColor]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: skin.backgroundColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Center(
                child: Container(
                  width: 90,
                  height: 56,
                  decoration: BoxDecoration(
                    color: skin.boardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '2048',
                    style: TextStyle(
                      color: skin.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Icon(
              owned ? Icons.check_circle : Icons.lock,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shop, _) {
        final items = _items;

        if (!shop.initialized || shop.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Boutique'),
            centerTitle: true,
            backgroundColor: Colors.blue.shade900,
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade600,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _BalanceCard(
                            coins: shop.coins,
                            onRewardAd: _showRewardedAdSnack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _CategoryButton(
                            label: 'Tuiles',
                            selected: _selectedCategory == ShopItemCategory.tileSkin,
                            onTap: () {
                              setState(() {
                                _selectedCategory = ShopItemCategory.tileSkin;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _CategoryButton(
                            label: 'Fond',
                            selected: _selectedCategory == ShopItemCategory.backgroundSkin,
                            onTap: () {
                              setState(() {
                                _selectedCategory = ShopItemCategory.backgroundSkin;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final skin = items[index];
                        final owned = shop.ownsSkin(skin);
                        final selected = skin.category == ShopItemCategory.tileSkin
                            ? shop.selectedTileSkinId == skin.id
                            : shop.selectedBackgroundSkinId == skin.id;

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      skin.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    skin.price == 0 ? 'Gratuit' : '${skin.price} pièces',
                                    style: TextStyle(
                                      color: skin.price == 0 ? Colors.greenAccent : Colors.amberAccent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                skin.description,
                                style: TextStyle(color: Colors.white.withOpacity(0.85)),
                              ),
                              const SizedBox(height: 12),
                              _buildPreviewCard(skin, owned, selected),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _handleSkinAction(skin),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selected
                                        ? Colors.green.shade600
                                        : owned
                                            ? Colors.blueGrey.shade700
                                            : Colors.orange.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text(
                                    selected
                                        ? 'Équipé'
                                        : owned
                                            ? 'Équiper'
                                            : 'Acheter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final int coins;
  final VoidCallback onRewardAd;

  const _BalanceCard({required this.coins, required this.onRewardAd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                '$coins pièces',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Gagne en jouant ou via les pubs récompensées.',
            style: TextStyle(color: Colors.white.withOpacity(0.85)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRewardAd,
              icon: const Icon(Icons.play_circle_fill, color: Colors.white),
              label: const Text('Regarder une pub (+25)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.white : Colors.white.withOpacity(0.15),
        foregroundColor: selected ? Colors.blue.shade900 : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label),
    );
  }
}