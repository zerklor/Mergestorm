# Play Store Listing - Assets & Descriptions

> Document pour organiser tous les éléments nécessaires à la fiche Play Store avant la soumission

**Package Name:** `com.benjaminaubry.mergestorm2048`  
**App ID:** ca-app-pub-1037321049022291~9455546165

---

## 📱 Éléments Requis pour Play Store

### 1. Informations Basiques

| Élément | Valeur |
|---------|--------|
| **App Name** | Mergestorm 2048 |
| **Catégorie** | Games > Puzzle |
| **Type** | Jeu gratuit (avec publicités) |
| **Contenu** | 4+ ans (PEGI 3) |
| **Version** | 1.0.0 (versionCode: 1) |
| **Min SDK** | 21 (Android 5.0 Lollipop) |
| **Target SDK** | 34+ (Android 14+) |

---

### 2. Icône Play Store (Obligatoire)

**Spécifications:**
- Format: PNG 512×512 px (au minimum)
- Sans transparence de fond (fond uni)
- Coins arrondis (en général, pas trop aigus)
- Fichier: `play_store_icon.png` (à placer dans `assets/images/`)

**Icône actuelle:** `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192×192)

**Action requise:** Générer une version haute résolution (512×512) ou utiliser un outil comme:
- [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/)
- Canva, GIMP, Photoshop

---

### 3. Screenshots (Obligatoire: 2-8 images)

**Format & Résolution:**
- Format: Portrait 9:16 (1080×1920 px minimum)
- Nombre: 5-8 images idéalement
- Type: Images actuelles du jeu avec annotations (optionnel)

**Contenu Recommandé:**

| # | Écran | Description |
|---|-------|-------------|
| 1 | Accueil | Menu principal avec 4 boutons (Jouer, Boutique, Paramètres, etc.) |
| 2 | Gameplay | Grille 4×4 en cours de jeu, avec score visible |
| 3 | Score | Score élevé, best score, game state |
| 4 | Dark Mode | Same gameplay en mode sombre (pour montrer la flexibilité) |
| 5 | Boutique | Écran boutique avec skins disponibles |
| 6 | Settings | Écran paramètres (volume, dark mode, etc.) |
| 7 | Win Screen | Écran victoire (2048 atteint) |
| 8 | Game Over | Écran de fin avec best score |

**Comment capturer:**
```bash
# Depuis un terminal, avec apareil connecté ou émulateur:
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ./screenshot_1.png

# Ou depuis l'émulateur VS Code: Ctrl+S (ou menu émulateur)
```

**Emplacements de stockage pour screenshots:**
- Créer: `assets/images/screenshots/`
- Nommer: `screenshot_1.png`, `screenshot_2.png`, etc.
- Uploader ensuite dans Play Console

---

### 4. Titres & Descriptions

#### Short Title (80 caractères max)
```
Mergestorm 2048 - Puzzle Game
```
*(Longueur: 30 caractères - ✅ OK)*

#### Full Title (50 caractères recommandé)
```
Mergestorm 2048
```

#### Short Description (80 caractères max)
```
Fusionnez les tuiles et atteignez 2048! Gratuit et sans inscription.
```
*(Longueur: 70 caractères - ✅ OK)*

#### Full Description (4000 caractères max)

```
🎮 Mergestorm 2048 - Le Jeu de Puzzle Classique!

Jouez au célèbre jeu 2048 sur Android! Fusionnez les tuiles pour atteindre 2048 et au-delà.

✨ CARACTÉRISTIQUES:
✅ Gameplay 2048 authentique et addictif
✅ Meilleur score sauvegardé automatiquement
✅ Sons et musique relaxante intégrés
✅ Thème clair/sombre (adaptatif)
✅ Vibrations haptiques pour meilleure immersion
✅ Gratuit et sans inscription
✅ Fonctionne hors-ligne (sauf pubs)
✅ Interface intuitive en français

🎯 RÈGLES SIMPLES:
1. Glissez vos doigts pour déplacer les tuiles
2. Quand deux tuiles identiques se touchent, elles fusionnent
3. Chaque fusion crée une tuile avec le double de la valeur
4. Objectif: Atteindre la tuile 2048!
5. Continuez à jouer après 2048 pour des scores plus élevés

🧠 PARFAIT POUR:
• Entraîner votre cerveau
• Passer le temps
• Détente et relaxation
• Défi personnel (battez votre record!)

⏱️ DURÉE DE JEU:
• Partie rapide: 2-5 minutes
• Partie complète: 10-20 minutes

💡 CONSEILS:
• Stratégie: Gardez les grandes tuiles dans un coin
• Restez patient: Pas de limite de temps
• Perfectionnez votre technique pour atteindre des scores élevés

Sans publicités intrusives - Publicités subtiles pour soutenir le développement.
Aucune donnée personnelle collectée - Toutes les données restent sur votre appareil.

Téléchargez maintenant et profitez du classique 2048!
```

---

### 5. Contact & Support

| Élément | Valeur |
|---------|--------|
| **Email Support** | support@benjaminaubry.com *(ou email valide)* |
| **Website** | benjaminaubry.com *(optionnel)* |
| **Privacy Policy URL** | benjaminaubry.com/privacy *(requis)* |

---

### 6. Catégories & Métadonnées

| Élément | Valeur |
|---------|--------|
| **Catégorie Principale** | Games |
| **Catégorie Secondaire** | Puzzle |
| **Types de Contenu** | Games / Puzzle / Casual |
| **Langage** | Français, English (si applicable) |
| **Pays de Publication** | Monde entier (tous les pays) |

---

## 📋 Checklist Play Store

- [ ] Package name mis à jour → `com.benjaminaubry.mergestorm2048`
- [ ] Icône Play Store (512×512) prête
- [ ] 5-8 screenshots (1080×1920) prêts et formatés
- [ ] Titres et descriptions révisés
- [ ] Email de support valide
- [ ] Politique de confidentialité rédigée et publiée
- [ ] Content Rating questionnaire complété
- [ ] Data Safety section remplie
- [ ] App Bundle généré et signé
- [ ] App Bundle testé sur appareil/émulateur
- [ ] Aucune erreur de build (flutter analyze)
- [ ] Pas de debug print statements inutiles
- [ ] Tous les AdMob IDs de production (pas de test IDs)
- [ ] Version 1.0.0+1 prête

---

## 🚀 Prochaines Étapes

1. **Créer un compte Google Play Developer** ($25 USD de frais)
2. **Préparer les assets** (screenshots, icône)
3. **Remplir la fiche Play Store** dans Google Play Console
4. **Uploader l'App Bundle** (build/app/outputs/bundle/release/app-release.aab)
5. **Remplir les informations légales** (privacy policy, data safety)
6. **Soumettre pour review** (48-72 heures généralement)
7. **Publication** une fois approuvé

