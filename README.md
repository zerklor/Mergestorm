# 🎮 Mergestorm - Jeu 2048 Android

Une implémentation moderne du jeu 2048 en Flutter, prête pour le Google Play Store.

## 🌟 Caractéristiques

### Gameplay
- ✅ Mécaniques 2048 authentiques (mouvements, fusions, score)
- ✅ Grille 4×4 classique
- ✅ Système de score en temps réel
- ✅ Sauvegarde automatique du meilleur score
- ✅ Détection victoire (2048) et défaite

### Interface & Expérience
- ✅ Interface moderne et épurée
- ✅ Animations fluides des tuiles (spawn, slide, merge)
- ✅ Système de thème clair/sombre
- ✅ Contrôles tactiles précis (swipe detection)
- ✅ Responsive pour tous les écrans Android

### Fonctionnalités Avancées
- ✅ Son et musique de fond (configurable)
- ✅ Vibrations haptiques pour feedback
- ✅ Contrôle de la vitesse d'animation (3 niveaux)
- ✅ Persistance complète avec SharedPreferences
- ✅ Application 100% hors-ligne (sauf publicités)

### Support
- ✅ Android 5.0+ (minSdk 21)
- ✅ Flutter 3.7+
- ✅ Architecture ARM et ARM64
- ✅ Publicités Google Mobile Ads (optionnel)

---

## 🚀 Démarrage Rapide

### Prérequis
- Flutter 3.7.0+
- Dart 3.5.0+
- Android SDK (minSdk 21)
- Java 11+

### Installation

```bash
# 1. Naviguer au projet
cd c:\Users\benja\StudioProjects\mergestorm

# 2. Installer les dépendances
flutter pub get

# 3. Lancer en développement
flutter run

# 4. Lancer sur appareil (release)
flutter run --release
```

### Vérifier la qualité du code

```bash
flutter analyze
```

## 📚 Documentation

- **[QUICK_START.md](./QUICK_START.md)** - Commandes essentielles
- **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - Guide complet de configuration
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Architecture technique détaillée

## 🏗️ Structure du projet

```
lib/
├── main.dart                    # Entry point
├── models/
│   ├── game_state.dart         # État du jeu
│   └── game_tile.dart          # Modèle de tuile
├── services/
│   ├── game_engine.dart        # Logique 2048
│   ├── score_manager.dart      # Persistance scores
│   ├── audio_manager.dart      # Gestion sons
│   └── ad_manager.dart         # Publicités Google Ads
├── providers/
│   └── game_provider.dart      # Provider (gestion d'état)
├── screens/
│   └── game_screen.dart        # Interface principale
└── widgets/
    ├── game_tile_widget.dart
    ├── game_grid_widget.dart
    └── banner_ad_widget.dart
```

## 🎮 Gameplay

### Contrôles
- **Swipe** - Glisser pour déplacer les tuiles
- **Button "Nouveau"** - Recommencer une partie

### Règles
1. Les tuiles se déplacent dans la direction du swipe
2. Deux tuiles avec la même valeur fusionnent
3. Chaque fusion ajoute au score
4. Une nouvelle tuile (2 ou 4) apparaît après chaque coup
5. **Victoire**: Atteindre 2048
6. **Défaite**: Aucun coup possible

## 🔧 Configuration requise

- **Flutter** 3.7.0+
- **Dart** 3.5.0+
- **Android SDK** 21+ (pour AdMob)
- **Java** 11+

## 📱 Dépendances

```yaml
provider: ^6.0.0                 # Gestion d'état
shared_preferences: ^2.2.0       # Persistance locale
audioplayers: ^5.2.0             # Gestion audio
google_mobile_ads: ^5.1.0        # Publicités
```

## 🌟 Prochaines étapes

### Court terme (avant publication)
1. Ajouter les sons MP3
2. Créer l'icône de l'app
3. Obtenir Ad Unit IDs Google AdMob
4. Générer screenshots

### Moyen terme (après publication)
1. Monitorer les téléchargements
2. Collecter les avis utilisateurs
3. Corriger les bugs remontés

### Long terme (évolutions)
1. Mode 5x5
2. Leaderboard
3. Autres jeux (3×3, Time Attack)
4. Achats in-app

## 📊 Build & Distribution

```bash
# Générer l'APK (test)
flutter build apk --release

# Générer l'App Bundle (Play Store - RECOMMANDÉ)
flutter build appbundle --release

# Installer sur appareil
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 📞 Support

### Ressources
- [Flutter Documentation](https://flutter.dev)
- [Google Play Console](https://play.google.com/console)
- [Google AdMob Help](https://support.google.com/admob)
- [Android Developer Docs](https://developer.android.com)

### FAQ

**Q: Pourquoi les sons ne jouent pas?**
A: Les fichiers MP3 doivent être dans `assets/sounds/` et ils ne sont pas encore présents.

**Q: Les ads s'affichent?**
A: Oui, avec les Test Ad IDs actuels. Cela montre "Test Ad". Remplacez par les vrais IDs avant publication.

**Q: Peut-on jouer hors-ligne?**
A: Oui, 100% hors-ligne sauf pour les publicités Google Ads.

## 📜 Licence

À déterminer avant publication sur Play Store (MIT, Apache, etc.)

## 👨‍💻 Développeur

Créé avec ❤️ pour le Play Store

---

**Version:** 1.0.0  
**Statut:** ✅ Prêt pour développement / Configuration avant publication  
**Date:** 25 avril 2025
