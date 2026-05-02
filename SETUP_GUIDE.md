# 🔧 Setup Guide - Configuration Complète

Guide détaillé pour configurer le jeu 2048 avant publication sur Google Play Store.

---

## 📋 Index

1. [Prérequis](#prérequis)
2. [Installation initiale](#installation-initiale)
3. [Configuration sons](#1-configuration-des-sons)
4. [Création icône](#2-création-de-licône-de-lapplication)
5. [Google AdMob](#3-configuration-google-admob)
6. [Configuration Android](#4-configuration-android)
7. [Signature & Release](#5-signature-et-build-release)
8. [Test final](#6-test-final)
- Intégration Google Mobile Ads (test ads)
- Support des gestes tactiles (swipe)
- Animations de tuiles

### 📝 Prochaines étapes

## 1️⃣ Ajouter les sons

Les sons doivent être placés dans `assets/sounds/`:
- `move.mp3` - Son d'un coup (glissement de tuile)
- `merge.mp3` - Son de fusion de deux tuiles
- `game_over.mp3` - Son de fin de jeu
- `win.mp3` - Son de victoire
- `background.mp3` - Musique de fond en boucle

**Ressources gratuites:**
- Freesound.org
- Zapsplat.com
- Pixabay Music/Sounds

## 2️⃣ Configurer Google AdMob

### Obtenir les Ad Unit IDs:
1. Aller sur [AdMob Console](https://admob.google.com)
2. Créer un compte Google Ads si vous n'en avez pas
3. Ajouter votre application Android
4. Créer des Ad Units:
   - Banner Ad Unit ID
   - Interstitial Ad Unit ID (optionnel)
   - Rewarded Ad Unit ID (optionnel)

### Mettre à jour les configurations:

**lib/services/ad_manager.dart:**
```dart
// Remplacer les test IDs par vos vrais IDs
static const String _bannerAdUnitId = 'YOUR_BANNER_AD_UNIT_ID';
static const String _interstitialAdUnitId = 'YOUR_INTERSTITIAL_AD_UNIT_ID';
static const String _rewardedAdUnitId = 'YOUR_REWARDED_AD_UNIT_ID';
```

**android/app/src/main/AndroidManifest.xml:**
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

## 3️⃣ Ajouter les bannières publicitaires à l'écran

Modifier `lib/screens/game_screen.dart` pour ajouter la bannière ad (déjà prêt, juste à décommenter la section ads).

## 4️⃣ Configuration Android pour Play Store

### Dans `android/app/build.gradle.kts`:
```kotlin
android {
    namespace = "com.example.mergestorm2048"
    compileSdk = 34  // Ou plus récent
    
    defaultConfig {
        applicationId = "com.example.mergestorm2048"
        minSdk = 21  // Au minimum pour AdMob
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }
}
```

### Générer la clé de signature:
```bash
keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

### Configuration de signature dans `android/app/build.gradle.kts`:
```kotlin
signingConfigs {
    release {
        keyStore = file("path/to/my-release-key.jks")
        keyStorePassword = "password"
        keyAlias = "my-key-alias"
        keyPassword = "key-password"
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
    }
}
```

## 5️⃣ Préparer pour Play Store

### Ressources requises:
1. **Icon de l'app** (512x512 PNG)
   - Placer dans `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

2. **Screenshots** (au minimum 2):
   - Format: 9:16 ou 16:9
   - Taille recommandée: 1080x1920 (portrait)

3. **Description** (English + Français):
   ```
   Play the classic 2048 game!
   Slide tiles to combine numbers and reach 2048.
   Features:
   - Classic 2048 gameplay
   - Save your best score
   - Background music
   - Sound effects
   ```

### Générer l'APK/Bundle:
```bash
# APK (pour test)
flutter build apk --release

# App Bundle (pour Play Store - recommandé)
flutter build appbundle --release
```

### Créer l'application sur Play Store:
1. Aller sur [Google Play Console](https://play.google.com/console)
2. Créer une nouvelle application
3. Remplir les informations:
   - Titre: "2048"
   - Description courte et complète
   - Catégorie: Games
   - Rating: Everyone
4. Uploader le bundle `.aab`
5. Ajouter les screenshots
6. Configurer les politiques de confidentialité
7. Soumettre pour review

## 🎮 Tester avant de soumettre

```bash
# Tester en développement
flutter run --release

# Générer APK de test et installer
flutter build apk
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 📊 Structure du projet
```
lib/
├── main.dart                 # Entry point
├── providers/
│   └── game_provider.dart   # Gestion d'état avec Provider
├── models/
│   ├── game_state.dart      # État du jeu
│   └── game_tile.dart       # Modèle d'une tuile
├── services/
│   ├── game_engine.dart     # Logique du 2048
│   ├── score_manager.dart   # Persistance des scores
│   ├── audio_manager.dart   # Gestion des sons
│   └── ad_manager.dart      # Publicités Google Ads
├── screens/
│   └── game_screen.dart     # Interface principale
└── widgets/
    ├── game_grid_widget.dart
    └── game_tile_widget.dart
```

## 🔧 Dépendances clés
- **provider**: ^6.0.0 - Gestion d'état
- **shared_preferences**: ^2.2.0 - Sauvegarde locale
- **audioplayers**: ^5.2.0 - Sons
- **google_mobile_ads**: ^5.1.0 - Publicités

## 📝 Checklist avant publication
- [ ] Tous les sons ajoutés
- [ ] Ad Unit IDs configurés
- [ ] Icon de l'app créé et placé
- [ ] Screenshots prêts
- [ ] Versionning incrémenté (versionCode, versionName)
- [ ] Politique de confidentialité créée
- [ ] Testés sur plusieurs appareils
- [ ] APK/Bundle generé avec signature
- [ ] Play Store listing complété

## 🚀 Commands utiles

```bash
# Installer dépendances
flutter pub get

# Analyser le code
flutter analyze

# Tester
flutter test

# Build
flutter build apk --release
flutter build appbundle --release

# Run sur émulateur/appareil
flutter run --release
```

## ❓ Troubleshooting

**Les sons ne jouent pas:**
- Vérifier que les fichiers MP3 sont dans `assets/sounds/`
- Vérifier que `pubspec.yaml` inclut bien `assets/sounds/`

**Les ads ne s'affichent:**
- Vérifier les Ad Unit IDs
- Durant le développement, les test IDs affichent une bannière "Test Ad"
- Les vraies ads mettent 24-48h à s'activer

**APK ne s'installe pas:**
- Vérifier le `applicationId` dans `build.gradle.kts`
- Déinstaller l'ancienne version: `adb uninstall com.example.mergestorm2048`

## 📞 Support
Pour des questions sur:
- Flutter: [Flutter Docs](https://flutter.dev)
- Play Store: [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- AdMob: [Google AdMob Help](https://support.google.com/admob)
