# ⚡ Quick Start - Commandes Essentielles

Référence rapide des commandes Flutter les plus utiles.

---

## 🚀 Démarrage

### Installer les dépendances
```bash
cd c:\Users\benja\StudioProjects\mergestorm
flutter pub get
```

### Lancer l'app en développement
```bash
# Sur émulateur
flutter run

# Sur appareil connecté
flutter run --release
```

### Vérifier la qualité du code
```bash
flutter analyze
```

## 🔨 Build et distribution

### Générer APK (pour test)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Générer App Bundle (pour Play Store - RECOMMANDÉ)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Installer l'APK sur un appareil
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 🎵 Ajouter les sons

1. Obtenir les fichiers MP3 (gratuits):
   - Freesound.org
   - Pixabay.com
   - Zapsplat.com

2. Placer dans `assets/sounds/`:
   - `move.mp3`
   - `merge.mp3`
   - `game_over.mp3`
   - `win.mp3`
   - `background.mp3`

3. Tester:
   ```bash
   flutter run
   ```

## 📱 Configuration Android

### AndroidManifest.xml
- ✅ Permissions Internet ajoutées
- ⚠️ À faire: Ajouter votre Google AdMob APPLICATION_ID

### build.gradle.kts (android/app/)
- ✅ Dépendances Firebase/AdMob configurées
- ⚠️ À faire: Vérifier `minSdk` (min 21 pour AdMob)

## 🎨 Icône de l'app

1. Créer une image 512x512 PNG
2. Convertir en mipmap (outil: [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/))
3. Placer les fichiers dans:
   - `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
   - `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

## 🏪 Play Store - Checklist

- [ ] 1. Enregistrer Ad Unit IDs AdMob
- [ ] 2. Ajouter tous les sons
- [ ] 3. Créer icône 512x512
- [ ] 4. Prendre 2-3 screenshots en 9:16
- [ ] 5. Vérifier versionCode et versionName
- [ ] 6. Générer app-release.aab
- [ ] 7. Créer compte Play Store Developer ($25)
- [ ] 8. Soumettre l'app
- [ ] 9. Attendre la review (24-48h)
- [ ] 10. App en ligne! 🚀

## 🐛 Troubleshooting

### Flutter cmd not found
```bash
# Ajouter Flutter au PATH
# Puis redémarrer le terminal
```

### Build échoue
```bash
# Nettoyer et reconstruire
flutter clean
flutter pub get
flutter build apk --release
```

### Les ads ne s'affichent pas
- Vérifier les Ad Unit IDs dans `lib/services/ad_manager.dart`
- Durant dev, utilisez les Test Ad IDs
- Les vraies ads mettent 24-48h pour s'activer

### L'app plante au démarrage
```bash
# Vérifier les logs
flutter run -v
```

## 📞 Ressources

- [Flutter Docs](https://flutter.dev/docs)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Google AdMob](https://admob.google.com)
- [Android Studio Emulator](https://developer.android.com/studio/run/emulator)

---
**Note:** Les test Ad Unit IDs sont déjà configurés. L'app affichera "Test Ad" jusqu'à la mise en production.
