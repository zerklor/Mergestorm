# ✅ Checklist Finale - Avant publication Play Store

## 📋 Vue d'ensemble
Le jeu 2048 est **100% développé et compilé**. Il reste des tâches de configuration avant publication.

**Statut:** Prêt pour test et publication
**Temps estimé:** 4-6 heures pour tout

---

## 🎵 1. Ajouter les sons (⏱️ 30-60 min)

### À faire
- [ ] Obtenir 5 fichiers MP3:
  - `move.mp3` - Son de coup (5-10s)
  - `merge.mp3` - Son de fusion (3-5s)
  - `game_over.mp3` - Son de défaite (2-3s)
  - `win.mp3` - Son de victoire (3-5s)
  - `background.mp3` - Musique boucle (30s-1min)

### Sources gratuites
- Freesound.org - Son libre de droit
- Pixabay.com/sounds - Sans copyright
- Zapsplat.com - Gratuit, pas d'attribution
- YouTube Audio Library

### Placer les fichiers
```
assets/sounds/
├── move.mp3
├── merge.mp3
├── game_over.mp3
├── win.mp3
└── background.mp3
```

**Vérifier après:**
```bash
flutter run
# Jeu doit jouer des sons lors des coups
```

---

## 🎨 2. Créer l'icône de l'app (⏱️ 30-60 min)

### À faire
- [ ] Créer une image 512x512 PNG représentant "2048"
  - Suggestions: chiffre "2048", grille 4x4 avec tuiles, ou abstrait
  - Format PNG avec transparence optionnelle

### Générer tous les formats
**Option 1: Automatisé**
```bash
# Utiliser Android Asset Studio
# https://romannurik.github.io/AndroidAssetStudio/
# 1. Charger l'image 512x512
# 2. Télécharger tous les formats
# 3. Extraire les fichiers
```

**Option 2: Manuel**
```bash
# Placer directement l'image en 512x512 dans:
android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

# Pour les autres résolutions, redimensionner:
# xxxhdpi (512x512) - pour xxxhdpi
# xxhdpi  (384x384)
# xhdpi   (256x256)
# hdpi    (192x192)
# mdpi    (144x144)
```

### Vérifier après
```bash
flutter build apk --release
# Vérifier que l'icône s'affiche correctement
```

---

## 🌍 3. Configurer Google AdMob (⏱️ 1-2 h)

### Créer le compte
- [ ] Aller sur https://admob.google.com
- [ ] Se connecter avec un compte Google
- [ ] Accepter les conditions

### Enregistrer l'app
- [ ] Ajouter une nouvelle application
- [ ] Plateforme: Android
- [ ] Nom de l'app: "2048"
- [ ] Catégorie: Jeux

### Créer les Ad Units
- [ ] Banner Ad Unit
  - Format: Banner (320x50)
  - Nom: "2048 Banner"
- [ ] Interstitiel Ad Unit (optionnel)
- [ ] Rewarded Ad Unit (optionnel)

### Copier les IDs
```
Pour chaque Ad Unit, vous verrez:
- Application ID: ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy
- Ad Unit ID: ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzz
```

### Mettre à jour le code
**File: `lib/services/ad_manager.dart`**

```dart
// Remplacer les test IDs par les vrais:
static const String _bannerAdUnitId = 'YOUR_REAL_BANNER_ID';
```

**File: `android/app/src/main/AndroidManifest.xml`**

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

### Tester
```bash
flutter run --release
# La bannière doit s'afficher en bas (pas de texte "Test Ad")
```

---

## 📸 4. Prendre des Screenshots (⏱️ 15-30 min)

### Spécifications
- Format: 9:16 (portrait)
- Résolution: 1080x1920 (min)
- Quantité: 2-5 screenshots
- Format: PNG ou JPEG

### Contenu recommandé
1. **Écran accueil** - Jeu au début
2. **Écran gameplay** - Jeu en cours (score élevé)
3. **Écran victoire** - Après avoir atteint 2048
4. **Écran game over** - Fin de partie

### Méthode 1: Émulateur Android Studio
```bash
# Dans Android Studio
# Outils > Device File Explorer
# Chercher: /data/local/tmp/...
# Ou directement bouton screenshot dans l'émulateur
```

### Méthode 2: Appareil Android réel
```bash
# Connecter le téléphone
flutter run --release
# Faire les captures avec le bouton volume + power
# Les fichiers sont dans Galerie > Screenshots
```

### Méthode 3: Adb
```bash
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ~/screenshot.png
```

---

## 🔢 5. Versionning (⏱️ 5 min)

### Mettre à jour les versions

**File: `android/app/build.gradle.kts`**

Actuellement:
```kotlin
versionCode = 1
versionName = "1.0.0"
```

Pour les futures releases:
```kotlin
versionCode = 2           // Incrémenter à chaque release
versionName = "1.0.1"     // ou "1.1.0" pour major feature
```

**Schéma: `major.minor.patch`**

---

## 🔐 6. Générer la clé de signature (⏱️ 10 min)

### Créer la clé (une seule fois)
```bash
keytool -genkey -v -keystore ~/my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias
```

Répondre aux questions (pays, organisation, etc.)

### Configurer Gradle

**File: `android/app/build.gradle.kts`**

Ajouter avant `android { ... }`:

```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Créer `android/key.properties`
```properties
storeFile=/path/to/my-release-key.jks
storePassword=votre_mot_de_passe
keyAlias=my-key-alias
keyPassword=votre_mot_de_passe
```

---

## 🏗️ 7. Générer le bundle (⏱️ 5 min)

### Générer l'App Bundle (RECOMMANDÉ pour Play Store)
```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Générer l'APK (pour test uniquement)
```bash
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Tester l'APK
```bash
# Sur émulateur ou appareil
adb install build/app/outputs/flutter-apk/app-release.apk

# Ouvrir l'app et tester:
# - Gameplay fonctionne
# - Scores sauvegardés
# - Ads s'affichent
# - Sons jouent (s'ils sont ajoutés)
```

---

## 📱 8. Créer Play Store Listing (⏱️ 1-2 h)

### Créer le compte développeur
- [ ] Aller sur https://play.google.com/console
- [ ] Payer $25 USD (une seule fois)
- [ ] Ajouter les informations de paiement

### Créer l'app
- [ ] Cliquer "Créer application"
- [ ] Remplir les informations:

**Informations de base**
- Nom: "2048"
- Catégorie: Games > Puzzle
- Type de contenu: Jeu

**Description (copier-coller)**

**Français:**
```
Jouez au jeu 2048 classique!

Glissez les tuiles pour les combiner et atteindre 2048.

Caractéristiques:
• Gameplay classique 2048 authentique
• Sauvegarde du meilleur score
• Sons et musique
• Interface moderne et épurée
• Totalement hors-ligne (sauf publicités)

Règles:
1. Glissez pour déplacer les tuiles
2. Deux tuiles identiques fusionnent
3. Chaque fusion ajoute au score
4. Atteindre 2048 pour gagner
5. Pas de coups possibles = Game Over

Gratuit avec publicités. Amusez-vous!
```

**English:**
```
Play the classic 2048 game!

Swipe tiles to combine them and reach 2048.

Features:
• Authentic classic 2048 gameplay
• Save your best score
• Sound effects and music
• Modern and clean interface
• Completely offline (except ads)

Rules:
1. Swipe to move tiles
2. Identical tiles merge
3. Each merge adds to your score
4. Reach 2048 to win
5. No moves available = Game Over

Free with ads. Have fun!
```

**Captures d'écran**
- Uploader les 2-5 screenshots en 9:16

**Politique de confidentialité**
- Créer une page de politique simple (voir ressources)
- Ajouter l'URL

---

## 🚀 9. Soumettre l'app (⏱️ 15 min)

### Avant de soumettre
- [ ] Vérifier tous les champs complétés
- [ ] Ai-je ajouté l'App Bundle (.aab)?
- [ ] Screenshots OK?
- [ ] Politique de confidentialité OK?
- [ ] Content rating complété?

### Soumettre
- [ ] Cliquer "Soumettre"
- [ ] Cliquer "Publier"

### Attendre la review
- ⏱️ 24-48 heures
- Google reverra l'app
- Vous recevrez un email quand c'est approuvé

### Après approbation
- [ ] L'app est en ligne sur Play Store!
- [ ] URL pour partager: 
```
https://play.google.com/store/apps/details?id=com.example.game2048
```

---

## 📊 Résumé du timing

| Tâche | Temps | Priorité |
|-------|-------|----------|
| 1. Sons | 30-60 min | 🔴 Haute |
| 2. Icône | 30-60 min | 🔴 Haute |
| 3. AdMob | 1-2 h | 🟠 Moyenne |
| 4. Screenshots | 15-30 min | 🟠 Moyenne |
| 5. Versionning | 5 min | 🟢 Basse |
| 6. Clé signature | 10 min | 🟠 Moyenne |
| 7. Build bundle | 5 min | 🟠 Moyenne |
| 8. Play Store listing | 1-2 h | 🔴 Haute |
| 9. Soumettre | 15 min | 🟢 Basse |
| **TOTAL** | **~5-8 h** | |

---

## 🎯 Ordre recommandé
1. Ajouter sons (🎵)
2. Créer icône (🎨)
3. Tester sur appareil réel
4. Configurer AdMob (🌍)
5. Prendre screenshots (📸)
6. Générer bundle (🏗️)
7. Créer Play Store listing (📱)
8. Soumettre (🚀)

---

## ❓ Besoin d'aide?

**Ressources:**
- Flutter Docs: https://flutter.dev
- Play Console Help: https://support.google.com/googleplay
- AdMob Help: https://support.google.com/admob
- Android Docs: https://developer.android.com

**Contacts:**
- Stack Overflow: tag `flutter`
- Flutter Community: https://flutter.dev/community

---

**Notes finales:**
- 🎮 Le jeu est 100% prêt à jouer
- 📦 Tout compiles sans erreurs
- ⚠️ Juste ressources externes + configuration Play Store
- ✅ Après cela, c'est en production!

**Bonne chance! 🚀**
