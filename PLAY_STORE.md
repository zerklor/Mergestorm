# 🚀 Play Store Submission Guide - Checklist Complète

Guide étape par étape pour soumettre le jeu 2048 sur Google Play Store.

---

## 📋 Table des matières

1. [Checklist pré-soumission](#-checklist-pré-soumission)
2. [Configuration Google Play](#-configuration-google-play)
3. [Préparation de l'app bundle](#-préparation-de-lapp-bundle)
4. [Play Store listing](#-play-store-listing)
5. [Soumission finale](#-soumission-finale)
6. [Après publication](#-après-publication)

---

## ✅ Checklist Pré-Soumission

### Code & Build

- [ ] `flutter analyze` retourne 0 erreurs
- [ ] Tous les imports utilisés (pas d'imports inutiles)
- [ ] Pas de debug prints inutiles
- [ ] Pas d'URLs de test (AdMob, etc.)
- [ ] `versionCode` et `versionName` mis à jour
  - versionCode: 1 (entier, augmente à chaque build)
  - versionName: "1.0" (pour utilisateurs)

### Assets & Ressources

- [ ] 5 fichiers sons (.ogg) présents dans `assets/sounds/`
- [ ] App icon en 5 densités présentes (PNG)
- [ ] Screenshots capturés (5-8 images, format 9:16)
- [ ] Pas de fichiers temporaires ou de debug

### Configuration Android

- [ ] `minSdk = 21` configuré
- [ ] `targetSdk = 34+` configuré
- [ ] NDK version correcte (`27.0.12077973`)
- [ ] Application ID unique (`com.example.mergestorm` → à changer)
- [ ] Permissions ajoutées (INTERNET, VIBRATE)
- [ ] Icône de launcher configurée

### Fonctionnalités

- [ ] Jeu jouable du début à la fin
- [ ] Pas de crashes detectés
- [ ] Sons jouent correctement
- [ ] Animations fluides
- [ ] Vibrations fonctionnent (si disponibles)
- [ ] Sauvegarde du score fonctionne
- [ ] Dark mode fonctionne
- [ ] Settings persistentes

### Performance

- [ ] App ne dépasse pas 100 MB APK
- [ ] Pas de memory leaks visibles
- [ ] App responsive (pas de freezes)
- [ ] Animations fluides 60 FPS

---

## 🎯 Configuration Google Play

### 1. Créer un compte Google Play Developer

**Coût:** $25 USD (à payer une fois)

1. Aller sur [Google Play Console](https://play.google.com/console)
2. Se connecter avec un compte Google personnel (créer si nécessaire)
3. Accepter les conditions
4. Payer les $25 USD

**Note:** Utiliser le même compte Google pour toutes les soumissions.

### 2. Créer une nouvelle application

1. Cliquer sur "Create app" dans Google Play Console
2. Remplir les champs:
   - **Nom de l'app:** "Mergestorm 2048" ou "2048"
   - **Langue par défaut:** Français (Français)
   - **Type:** Jeu (Games)
   - **Accès gratuit:** Oui

3. Accepter les conditions Play Store

### 3. Obtenir l'Application ID

1. Aller dans "App settings" → "Technical"
2. Noter le **Package name** (ex: `com.example.mergestorm2048`)
3. Mettre à jour `android/app/build.gradle.kts`:

```kotlin
defaultConfig {
    applicationId = "com.google.play.your_unique_id"  // ← Your Package Name
}
```

### 4. Configuration Google AdMob (Optionnel)

**Si vous voulez des publicités:**

1. Créer compte [Google AdMob](https://admob.google.com)
2. Enregistrer l'app
3. Créer des Ad Units (Banner, Interstitial, etc.)
4. Ajouter l'Application ID à `AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

5. Mettre à jour `lib/services/ad_manager.dart` avec les vrais IDs

---

## 🏗️ Préparation de l'App Bundle

### 1. Vérifier la configuration de signature

**Fichier `android/app/build.gradle.kts`:**

```kotlin
signingConfigs {
    release {
        keyAlias = keystoreProperties['keyAlias']
        keyPassword = keystoreProperties['keyPassword']
        storeFile = file(keystoreProperties['storeFile'])
        storePassword = keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
    }
}
```

### 2. Créer le keystore (première fois seulement)

```bash
# Créer la clé de signature
keytool -genkey -v -keystore ~/my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias

# Le terminal demande:
# - Enter keystore password: [Votre mot de passe]
# - Re-enter new password: [Confirmer]
# - What is your first and last name? [Votre nom]
# - [Remplir autres infos ou appuyer Entrée]
# - Is this information correct? [y]

# Résultat : ~/my-release-key.jks créé
```

**⚠️ Important:** Sauvegarder cette clé de façon sécurisée. Si perdue, impossible de publier des mises à jour de l'app.

### 3. Créer `android/key.properties`

**Fichier `android/key.properties` (local, jamais committé):**

```properties
storePassword=votre_mot_de_passe_keystore
keyPassword=votre_mot_de_passe_clé
keyAlias=my-key-alias
storeFile=../my-release-key.jks
```

### 4. Ajouter à `.gitignore`

```gitignore
# Ne pas commiter les clés
android/key.properties
*.jks
```

### 5. Vérifier `pubspec.yaml`

```yaml
name: mergestorm
description: Jeu 2048 moderne pour Android
publish_to: 'none'

version: 1.0.0+1  # version: "1.0.0+versionCode"

environment:
  sdk: ">=3.5.0 <4.0.0"

dependencies:
  # ... tous les packages ...

flutter:
  uses-material-design: true
  assets:
    - assets/sounds/move.ogg
    - assets/sounds/merge.ogg
    - assets/sounds/game_over.ogg
    - assets/sounds/win.ogg
    - assets/sounds/background.ogg
```

### 6. Générer l'App Bundle

```bash
# Clean le projet
flutter clean

# Installer les dépendances
flutter pub get

# Générer l'App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

**Taille attendue:** 30-50 MB

### 7. Vérifier le bundle

```bash
# Lister le contenu du bundle
unzip -l build/app/outputs/bundle/release/app-release.aab | head -20

# Checker la taille
dir build\app\outputs\bundle\release\app-release.aab
```

---

## 📝 Play Store Listing

### 1. Remplir l'app details

Dans Google Play Console, aller dans "App details":

**Screenshots (5-8 images)**
- Format: 9:16 (portrait)
- Résolution: 1080×1920 pixels minimum
- Contenu:
  1. Écran d'accueil (3 boutons)
  2. Gameplay (grille 4×4)
  3. Score en cours
  4. Paramètres
  5. Dark mode (optionnel)
  6. Game over (optionnel)
  7. Win screen (optionnel)

**Tips pour screenshots:**
```bash
# Capturer screenshot sur appareil
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png
```

Ou utiliser un éditeur (Photoshop, GIMP, Canva) pour ajouter du texte.

### 2. Textes descriptifs

**App name:** (Défaut: "mergestorm")
```
2048 - Puzzle Game
```

**Short description:** (80 caractères max)
```
Le classique 2048 sur Android - Fusionnez les tuiles et atteignez 2048!
```

**Full description:** (4000 caractères max)
```
🎮 Mergestorm 2048 - Le jeu de puzzle classique!

Fonctionnalités:
✅ Gameplay 2048 authentique
✅ Meilleur score sauvegardé automatiquement
✅ Sons et musique relaxante
✅ Thème clair/sombre
✅ Vibrations haptiques
✅ Gratuit, 100% hors-ligne (sauf pubs)

Règles simples:
- Glissez pour déplacer les tuiles
- Fusionnez deux tuiles identiques pour en créer une plus grande
- Atteindre 2048 pour gagner!
- Continuez après 2048 pour des scores plus élevés

Parfait pour:
- Passer le temps
- Entraîner votre cerveau
- Relaxation

Aucune inscription requise!

Développé avec Flutter pour performance optimale.
```

### 3. Catégories et contenu

**Catégorie (Content rating questionnaire):**
- **Type:** Jeu casual/puzzle
- **Contenu:** Pas de violence, pas d'adultes
- **PEGI/ESRB:** 3+ (Universel)

### 4. Contact

**Email de contact développeur:** votre_email@gmail.com
**Site web:** (optionnel)
**Politique de confidentialité:** (requis si collecte données)

---

## 🔒 Content Rating Questionnaire

Dans Play Console, aller dans "Content rating":

1. **Questionnaire:** Remplir le formulaire IARC
   - Aucune violence
   - Aucun contenu adulte
   - Aucune publicité agressive
   - Note: Universel (3+)

2. **Classification:** Doit afficher "All ages" ou "3+"

---

## 🚀 Soumission Finale

### 1. Préparer la release

Dans Google Play Console, aller dans "Testing" → "Internal testing":

1. Cliquer sur "Create release"
2. Uploader l'AAB: `build/app/outputs/bundle/release/app-release.aab`
3. Notes de release (en-US):
```
Version 1.0 - Initial release
- Jeu 2048 complet
- Scores persistants
- Sons et vibrations
- Mode sombre
```

### 2. Tester avant soumission

1. Dans "Internal testing", inviter 1-2 testeurs
2. Ils reçoivent un lien Play Store
3. Attendre 24-48h pour que le test soit disponible
4. Vérifier que tout fonctionne

### 3. Soumettre en production

Une fois test validé:

1. Créer une nouvelle "Release in production"
2. Copier le même AAB
3. Remplir les notes de release
4. **Cliquer "Review release"**
5. Vérifier tous les détails
6. **Cliquer "Start rollout to Production"**

### 4. Sélectionner le % de rollout

**Pour la première version:**
- Option 1: 100% rollout immediate (risqué)
- Option 2: 10% rollout, augmenter à 100% après 24h (recommandé)

Choisir option 2 pour première version.

### 5. Attendre l'approbation

Google va checker:
- Sécurité du code
- Respect des politiques Play Store
- Pas de malware
- Contenu approprié

**Durée:** Généralement 2-4 heures, parfois jusqu'à 24h.

---

## 📊 Après Publication

### 1. Monitorer la performance

Dans "Analytics" → "Android vitals":
- Crashes
- ANRs (Application Not Responding)
- Performance
- Batterie

### 2. Répondre aux avis

Aller dans "Ratings & reviews":
- Répondre aux questions
- Remercier les avis positifs
- Offrir solutions pour négatifs

### 3. Metrics importants

- **Installs:** Nombre d'installations
- **Ratings:** Note moyenne (viser 4.0+)
- **Retention:** % utilisateurs revenant après 1 jour
- **Uninstalls:** Taux de désinstallation

### 4. Mises à jour futures

Pour publier une mise à jour:

1. Augmenter `versionCode` et `versionName`:
```yaml
version: 1.0.1+2  # versionCode: 2, versionName: 1.0.1
```

2. Rebuilder:
```bash
flutter build appbundle --release
```

3. Soumettre la même façon que la version initiale

---

## 🆘 Problèmes Courants & Solutions

### "Certificate validity is about to end"
→ Créer une nouvelle clé avant expiration (10 ans par défaut)

### "Your release is not compliant"
→ Vérifier les warnings dans "Release summary", corriger et resubmitter

### "APK is larger than 100 MB"
→ L'App Bundle est automatiquement optimisé par Google

### "Crash on startup"
→ Vérifier les logs: `adb logcat | grep Flutter`

### "App disappears after 30 days"
→ Dû aux changements API Android; mettre à jour dépendances

### "Can't upload the same versionCode"
→ Augmenter versionCode dans pubspec.yaml avant rebuilder

---

## 📈 Stratégies de Growth (Après publication)

1. **ASO (App Store Optimization):**
   - Améliorer keywords
   - Ajouter plus de screenshots

2. **Partage:**
   - Partager avec amis
   - Poster sur Reddit, Discord, forums

3. **Updates:**
   - Ajouter fonctionnalités chaque mois
   - Corriger bugs rapidement

4. **Monetization (Optionnel):**
   - Activer Google Ads (déjà en place)
   - Pas d'achats in-app pour jeu casual

---

## 📞 Support & Ressources

### Docs officielles
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Flutter Distribution](https://flutter.dev/docs/deployment/android)
- [Play Store Policies](https://play.google.com/about/developer-content-policy/)

### Outils
- [Google Play Console](https://play.google.com/console)
- [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/)
- [App Icon Generator](https://www.appicon.co/)

---

## ✅ Checklist Finale Avant Soumission

- [ ] versionCode et versionName mis à jour
- [ ] App bundle généré sans erreurs
- [ ] Screenshots en 9:16 capturés (5-8 images)
- [ ] Descriptions complètes remplies
- [ ] Content rating questionnaire complété
- [ ] Politique de confidentialité (si applicable)
- [ ] Pas de test Ad Unit IDs dans le code produit
- [ ] Internal testing validé
- [ ] Release reviewed et sans warnings
- [ ] Rollout strategy décidée (% du rollout)

---

**READY TO LAUNCH! 🚀**

Une fois approuvé, votre app sera disponible sur:
```
https://play.google.com/store/apps/details?id=your_package_name
```

Partagez le lien et profitez! 🎉

---

Pour toute question, consultez:
- [SETUP_GUIDE.md](./SETUP_GUIDE.md) - Configuration détaillée
- [README.md](./README.md) - Vue d'ensemble générale
- [QUICK_START.md](./QUICK_START.md) - Commandes rapides
