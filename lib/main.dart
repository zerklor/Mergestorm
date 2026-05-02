import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/ad_manager.dart';
import 'providers/settings_provider.dart';
import 'providers/shop_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  Future.microtask(() async {
    try {
      await MobileAds.instance.initialize();
      await AdManager.preloadAds();
    } catch (_) {
      // L'app doit démarrer même si AdMob prend du temps à se charger.
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          // Initialiser les settings au démarrage
          if (!settings.initialized) {
            settings.initialize();
          }

          // Initialiser aussi la boutique pour charger les skins équipés
          Future.microtask(() async {
            final shop = context.read<ShopProvider>();
            if (!shop.initialized) {
              await shop.initialize();
            }
          });

          return MaterialApp(
            title: '2048',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: settings.darkModeEnabled ? Brightness.dark : Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: settings.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
